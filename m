Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:51810 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752721Ab3FFVlL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 6 Jun 2013 17:41:11 -0400
Date: Fri, 7 Jun 2013 00:41:08 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Andrzej Hajda <a.hajda@samsung.com>, linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	hj210.choi@samsung.com, sw0312.kim@samsung.com
Subject: Re: [PATCH RFC v3 2/3] media: added managed v4l2 control
 initialization
Message-ID: <20130606214107.GD3103@valkosipuli.retiisi.org.uk>
References: <1368692074-483-1-git-send-email-a.hajda@samsung.com>
 <201305231239.32156.hverkuil@xs4all.nl>
 <51A7F811.5090805@iki.fi>
 <201305310959.11948.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201305310959.11948.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andrzej and Hans,

On Fri, May 31, 2013 at 09:59:11AM +0200, Hans Verkuil wrote:
> On Fri May 31 2013 03:08:33 Sakari Ailus wrote:
> > Hi Hans,
> > 
> > Hans Verkuil wrote:
> > > On Fri 17 May 2013 00:34:51 Sakari Ailus wrote:
> > >> Hi Andrzej,
> > >>
> > >> Thanks for the patchset!
> > >>
> > >> On Thu, May 16, 2013 at 10:14:33AM +0200, Andrzej Hajda wrote:
> > >>> This patch adds managed version of initialization
> > >>> function for v4l2 control handler.
> > >>>
> > >>> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
> > >>> Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> > >>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> > >>> ---
> > >>> v3:
> > >>> 	- removed managed cleanup
> > >>> v2:
> > >>> 	- added missing struct device forward declaration,
> > >>> 	- corrected few comments
> > >>> ---
> > >>>   drivers/media/v4l2-core/v4l2-ctrls.c |   32 ++++++++++++++++++++++++++++++++
> > >>>   include/media/v4l2-ctrls.h           |   16 ++++++++++++++++
> > >>>   2 files changed, 48 insertions(+)
> > >>>
> > >>> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
> > >>> index ebb8e48..f47ccfa 100644
> > >>> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> > >>> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> > >>> @@ -1421,6 +1421,38 @@ void v4l2_ctrl_handler_free(struct v4l2_ctrl_handler *hdl)
> > >>>   }
> > >>>   EXPORT_SYMBOL(v4l2_ctrl_handler_free);
> > >>>
> > >>> +static void devm_v4l2_ctrl_handler_release(struct device *dev, void *res)
> > >>> +{
> > >>> +	struct v4l2_ctrl_handler **hdl = res;
> > >>> +
> > >>> +	v4l2_ctrl_handler_free(*hdl);
> > >>
> > >> v4l2_ctrl_handler_free() acquires hdl->mutex which is independent of the
> > >> existence of hdl. By default hdl->lock is in the handler, but it may also be
> > >> elsewhere, e.g. in a driver-specific device struct such as struct
> > >> smiapp_sensor defined in drivers/media/i2c/smiapp/smiapp.h. I wonder if
> > >> anything guarantees that hdl->mutex still exists at the time the device is
> > >> removed.
> > >
> > > If it is a driver-managed lock, then the driver should also be responsible for
> > > that lock during the life-time of the control handler. I think that is a fair
> > > assumption.
> > 
> > Agreed.
> > 
> > >> I have to say I don't think it's neither meaningful to acquire that mutex in
> > >> v4l2_ctrl_handler_free(), though, since the whole going to be freed next
> > >> anyway: reference counting would be needed to prevent bad things from
> > >> happening, in case the drivers wouldn't take care of that.
> > >
> > > It's probably not meaningful today, but it might become meaningful in the
> > > future. And in any case, not taking the lock when manipulating internal
> > > lists is very unexpected even though it might work with today's use cases.
> > 
> > I simply don't think it's meaningful to acquire a lock related to an 
> > object when that object is being destroyed. If something else was 
> > holding that lock, you should not have begun destroying that object in 
> > the first place. This could be solved by reference counting the handler 
> > which I don't think is needed.
> 
> Right now the way controls are set up is very static, but in the future I
> expect to see more dynamical behavior (I'm thinking of FPGAs supporting
> partial reconfiguration). In cases like that it you do want to take the
> lock preventing others from making modifications while the handler is
> freed. I am well aware that much more work will have to be done if we want
> to support such scenarios, but it is one reason why I would like to keep
> the lock there.

I'm ok with that.

How about adding a note to the comment above devm_v4l2_ctrl_handler_init()
that the function cannot be used with drivers that wish to use their own
lock?

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
