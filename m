Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:34864 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753815AbcLANwJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 1 Dec 2016 08:52:09 -0500
Date: Thu, 1 Dec 2016 15:51:25 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: mchehab@kernel.org, mkrufky@linuxtv.org, klock.android@gmail.com,
        elfring@users.sourceforge.net, max@duempel.org,
        hans.verkuil@cisco.com, javier@osg.samsung.com,
        chehabrafael@gmail.com, sakari.ailus@linux.intel.com,
        laurent.pinchart+renesas@ideasonboard.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] media: protect enable and disable source handler
 checks and calls
Message-ID: <20161201135125.GR16630@valkosipuli.retiisi.org.uk>
References: <cover.1480384155.git.shuahkh@osg.samsung.com>
 <54975937478803ef4883e9caecb8af0ef282e35c.1480384155.git.shuahkh@osg.samsung.com>
 <20161129092230.GL16630@valkosipuli.retiisi.org.uk>
 <4249d032-ecdc-06bb-d11a-cf88b7a8d86c@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4249d032-ecdc-06bb-d11a-cf88b7a8d86c@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Shuah,

On Tue, Nov 29, 2016 at 10:41:51AM -0700, Shuah Khan wrote:
> On 11/29/2016 02:22 AM, Sakari Ailus wrote:
> > Hi Shuah,
> > 
> > On Mon, Nov 28, 2016 at 07:15:14PM -0700, Shuah Khan wrote:
> >> Protect enable and disable source handler checks and calls from dvb-core
> >> and v4l2-core. Hold graph_mutex to check if enable and disable source
> >> handlers are present and invoke them while holding the mutex. This change
> >> ensures these handlers will not be removed while they are being checked
> >> and invoked.
> >>
> >> au08282 enable and disable source handlers are changed to not hold the
> >> graph_mutex.
> >>
> >> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
> >> ---
> >>  drivers/media/dvb-core/dvb_frontend.c  | 24 ++++++++++++++++++------
> >>  drivers/media/usb/au0828/au0828-core.c | 17 +++++------------
> >>  drivers/media/v4l2-core/v4l2-mc.c      | 26 ++++++++++++++++++--------
> >>  3 files changed, 41 insertions(+), 26 deletions(-)
> >>
> >> diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
> >> index 01511e5..2f09c7e 100644
> >> --- a/drivers/media/dvb-core/dvb_frontend.c
> >> +++ b/drivers/media/dvb-core/dvb_frontend.c
> >> @@ -2527,9 +2527,13 @@ static int dvb_frontend_open(struct inode *inode, struct file *file)
> >>  		fepriv->voltage = -1;
> >>  
> >>  #ifdef CONFIG_MEDIA_CONTROLLER_DVB
> >> -		if (fe->dvb->mdev && fe->dvb->mdev->enable_source) {
> >> -			ret = fe->dvb->mdev->enable_source(dvbdev->entity,
> >> +		if (fe->dvb->mdev) {
> >> +			mutex_lock(&fe->dvb->mdev->graph_mutex);
> >> +			if (fe->dvb->mdev->enable_source)
> >> +				ret = fe->dvb->mdev->enable_source(
> >> +							   dvbdev->entity,
> >>  							   &fepriv->pipe);
> >> +			mutex_unlock(&fe->dvb->mdev->graph_mutex);
> > 
> > You have to make sure the media device actually will stay aronud while it is
> > being accessed. In this case, when dvb_frontend_open() runs, it will proceed
> > to access the media device without knowing whether it's going to stay around
> > or not. Without doing so, it may well be in the process of being removed by
> > au0828_unregister_media_device() at the same time.
> 
> Right. What this is trying to protect is just the check for enable_source
> and disable handlers before calling them.

Yes, but that's not enough.

The other handlers in the ops structure must stay there as long as the media
device does. So we need to make sure it does. One, perhaps the only way to
do that could be to obtain a reference to the device that first set those
callbacks.

> 
> > 
> > The approach I took in my patchset was that the device that requires the
> > media device will acquire a reference to it, this way the media device will
> > stick around as long as other data structures have references to it. The
> > current set did not yet implement this to dvb devices but I can add that.
> > Then there's no even a need for the frontend driver to acquire the graph
> > lock just to call the enable_source() callback.
> 
> Taking reference to media_device alone will not solve this problem of enable
> and disable handlers going away. au0828_unregister_media_device() will clear
> the handlers and then call media_device_unregister() and it also does
> media_device_cleanup(). Your patch set and media dev allocator api I did solve

Then, that should be applied to all the other callbacks in the ops structure
as well. Not only to the callbacks that the au0828 driver needs. All the
callbacks are really need to stay unchanged as long as the device may be in
use.

Acquiring the graph mutex is hardly a workable solution to fix this.

> the problem of media_device not going away, however, it doesn't fix this race
> where callers of enable and disable source handlers checking for them and calling
> them while the driver might be clearing them.
> 
> So here is the scenario these patches fix. Say user app starts
> and during start of video streaming v4l2 checks to see if enable
> source handler is defined. This check is done without holding the
> graph_mutex. If unbind happens to be in progress, au0828 could
> clear enable and disable source handlers. So these could race.
> I am not how large this window is, but could happen.
> 
> If graph_mutex protects the check for enable source handler not
> being null, then it has to be released before calling enable source
> handler as shown below:
> 
> if (mdev) {
> 	mutex_lock(&mdev->graph_mutex);
> 	if (mdev->disable_source) {
> 		mutex_unlock(&mdev->graph_mutex);
> 		mdev->disable_source(&vdev->entity);
> 	} else
> 		mutex_unlock(&mdev->graph_mutex);
> }
> 
> The above will leave another window for handlers to be cleared.
> That is why it would make sense for the caller to hold the lock
> and the call enable and disable source handlers.
> 
> We do need a way to protect enable and disable handler access and the
> call itself. I am using the same graph_mutex for both, hence I decided
> to have the caller hold the lock.
> 
> Hope this helps.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
