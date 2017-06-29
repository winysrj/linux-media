Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:34804 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751678AbdF2IJ4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Jun 2017 04:09:56 -0400
Date: Thu, 29 Jun 2017 11:09:52 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH 1/1] docs-rst: media: Document s_stream() core op usage
Message-ID: <20170629080952.lm5cj5pj2al47kfe@valkosipuli.retiisi.org.uk>
References: <1498718333-26287-1-git-send-email-sakari.ailus@linux.intel.com>
 <20170629072153.GM30481@bigcity.dyn.berto.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170629072153.GM30481@bigcity.dyn.berto.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hejssan!

On Thu, Jun 29, 2017 at 09:21:53AM +0200, Niklas Söderlund wrote:
> Hi Sakari,
> 
> Thanks for your patch.
> 
> On 2017-06-29 09:38:53 +0300, Sakari Ailus wrote:
> > As we begin to add support for systems with media pipelines controlled by
> > more than one device driver, it is essential that we precisely define the
> > responsibilities of each component in the stream control and common
> > practices.
> > 
> > Specifically, this patch documents two things:
> > 
> > 1) streaming control is done per sub-device and sub-device drivers
> > themselves are responsible for streaming setup in upstream sub-devices and
> > 
> > 2) broken frames should be tolerated at streaming stop. It is the
> > responsibility of the sub-device driver to stop the transmitter after
> > itself if it cannot handle broken frames (and it should be probably be
> > done anyway).
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > ---
> >  Documentation/media/kapi/v4l2-subdev.rst | 36 ++++++++++++++++++++++++++++++++
> >  1 file changed, 36 insertions(+)
> > 
> > diff --git a/Documentation/media/kapi/v4l2-subdev.rst b/Documentation/media/kapi/v4l2-subdev.rst
> > index e1f0b72..27e371e 100644
> > --- a/Documentation/media/kapi/v4l2-subdev.rst
> > +++ b/Documentation/media/kapi/v4l2-subdev.rst
> > @@ -262,6 +262,42 @@ is called. After all subdevices have been located the .complete() callback is
> >  called. When a subdevice is removed from the system the .unbind() method is
> >  called. All three callbacks are optional.
> >  
> > +Streaming control
> > +^^^^^^^^^^^^^^^^^
> > +
> > +Starting and stopping the stream are somewhat complex operations that
> > +often require walking the media graph to enable streaming on
> > +sub-devices which the pipeline consists of. This involves interaction
> > +between multiple drivers, sometimes more than two.
> > +
> > +The ``.s_stream()`` core op is responsible for starting and stopping
> 
> .s_stream() is a video or audio op not a core op right? But at the same 
> time it's all part of the v4l2 core :-) Apart from this nit-pick which 
> I'm fine to leave as is at your leisure.
> 
> Acked-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

Good point. The audio s_stream() op appears to be much less used and not by
MC enabled drivers.

I'll fix that, as well as add a proper reference to struct
v4l2_subdev_video_ops.

-- 
Hälsningar,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
