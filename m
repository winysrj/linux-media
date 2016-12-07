Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:59412 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752371AbcLGKw1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Dec 2016 05:52:27 -0500
Date: Wed, 7 Dec 2016 12:52:17 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        mchehab@kernel.org, tiwai@suse.com, perex@perex.cz,
        hans.verkuil@cisco.com, javier@osg.samsung.com,
        chehabrafael@gmail.com, g.liakhovetski@gmx.de, ONeukum@suse.com,
        k@oikw.org, daniel@zonque.org, mahasler@gmail.com,
        clemens@ladisch.de, geliangtang@163.com, vdronov@redhat.com,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH v6 3/3] sound/usb: Use Media Controller API to share
 media resources
Message-ID: <20161207105207.GW16630@valkosipuli.retiisi.org.uk>
References: <cover.1480539942.git.shuahkh@osg.samsung.com>
 <ebeaa42019b102f76d87a2fc4aa7793e1f87072c.1480539942.git.shuahkh@osg.samsung.com>
 <69ad05a8-8572-43e7-ef76-7510edd904c6@osg.samsung.com>
 <2368883.8y0L28vD2m@avalon>
 <d0a8e556-915c-4f14-d45e-a36a11fb5c6d@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d0a8e556-915c-4f14-d45e-a36a11fb5c6d@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Shuah,

On Mon, Dec 05, 2016 at 05:38:23PM -0700, Shuah Khan wrote:
> On 12/05/2016 04:21 PM, Laurent Pinchart wrote:
> > Hi Shuah,
> > 
> > On Monday 05 Dec 2016 15:44:30 Shuah Khan wrote:
> >> On 11/30/2016 03:01 PM, Shuah Khan wrote:
> >>> Change ALSA driver to use Media Controller API to share media resources
> >>> with DVB, and V4L2 drivers on a AU0828 media device.
> >>>
> >>> Media Controller specific initialization is done after sound card is
> >>> registered. ALSA creates Media interface and entity function graph
> >>> nodes for Control, Mixer, PCM Playback, and PCM Capture devices.
> >>>
> >>> snd_usb_hw_params() will call Media Controller enable source handler
> >>> interface to request the media resource. If resource request is granted,
> >>> it will release it from snd_usb_hw_free(). If resource is busy, -EBUSY is
> >>> returned.
> >>>
> >>> Media specific cleanup is done in usb_audio_disconnect().
> >>>
> >>> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
> >>
> >> Hi Takashi,
> >>
> >> If you are good with this patch, could you please Ack it, so Mauro
> >> can pull it into media tree with the other two patches in this series,
> >> when he is ready to do so.
> > 
> > I *really* want to address the concerns raised by Sakari before pulling more 
> > code that makes fixing the race conditions more difficult. Please, let's all 
> > work on fixing the core code to build a stable base on which we can build 
> > additional features. V4L2 and MC need teamwork, it's time to give the 
> > subsystem the love it deserves.
> > 
> 
> Hi Laurent,
> 
> The issue Sakari brought up is specific to using devm for video_device in
> omap3 and vsp1. I tried reproducing the problem on two different drivers
> and couldn't on Linux 4.9-rc7.
> 
> After sharing that with Sakari, I suggested to Sakari to pull up his patch
> that removes the devm usage and see if he still needs all the patches in his
> patch series. He didn't back to me on that. I also requested him to rebase on

Just to see what remains, I made a small hack to test this with omap3isp by
just replacing the devm_() functions by their plain counterparts. The memory
is thus never released, for there is no really a proper moment to release it
--- something which the patchset resolves. The result is here:

<URL:http://www.retiisi.org.uk/v4l2/tmp/media-ref-dmesg.txt>

What happens there is that as part of the device unbinding, the graph
objects are unregistered (by media_device_unregister()) while streaming is
ongoing. Their parent media device pointers are set to NULL.

Then, when the user process exists, the streaming media pipeline is stopped.
This requires parsing of the media graph, a job which will obviously fail
miserably and immediately: the media device is obtained from the entity
where graph traversal is expected to begin.

Two mutexes are also acquired but they've been already destroyed at that
point (and the memory of which would also be released now without the hack
to test this "without devm"). There's just a single warning on this though.

> top of media dev allocator because the allocator routines he has don't address
> the shared media device need.

I do strongly prefer fixing the existing object lifetime issues in the
framework before extending it and thus making the problem domain more
complex than it is already.

What I mentioned as an example of this are the other callbacks to the media
device: presumably they do suffer from the exactly same problems as the
enable_source() and disable_source() ones.

As drivers do refer to other entities and controls they do expose also to
the user space, we can't really even remove entities safely at the moment.
We should have a solution to this as well, my patchset at the moment does
not address this.

What we do need a sound basis for the framework rather than hastily written
improvements to support a particular device. Also, testing device removal
with a particular device in a particular use case does not guarantee that no
further object lifetime issues related to device removal exist, even with
that same driver, let alone other devices.

Instead, we must consider how the frameworks and drivers manage the memory
allocated for the various objects, what are relations of those objects and
how they're exposed to the user space either directly or indirectly. As long
as objects (such as the media graph objects) with different lifetimes are
referred to from other objects without taking a reference or alternatively
serialising code paths that may access those objects and those that remove
them, we do have a problem.

The media graph with all the subsystem specific device nodes that are
exported to the user space is a rather complex data structure. I don't think
that acquiring the media graph lock in order to fix all the serialisation
problems is the right approach here.

> 
> He also didn't respond to my response regarding the reasons for choosing
> graph_mutex to protect enable_source and disable_source handlers.

I did. The point is that this is a partial fix and that does not properly
address the problem of device removal. It probably does decrease of the
probability of hitting the bug but it does not fix it.

> 
> So I am not sure how to move forward at the moment without a concrete plan
> for Sakari's RFC series. Sakari's patch series is still RFC and doesn't address
> shared media_device and requires all drivers to change.

I'm all for extending the functionality of the Media controller framework,
but existing known problems touching the same parts of the framework should
be fixed first.

Reviewing patches, pointing out problems and proposing improvements would
certainly help to achieve that goal.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
