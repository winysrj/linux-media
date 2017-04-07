Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:60658 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752766AbdDGXCZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Apr 2017 19:02:25 -0400
Date: Sat, 8 Apr 2017 02:02:21 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, linux-acpi@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v2 7/8] docs-rst: media: Switch documentation to V4L2
 fwnode API
Message-ID: <20170407230220.GO4192@valkosipuli.retiisi.org.uk>
References: <1491484330-12040-1-git-send-email-sakari.ailus@linux.intel.com>
 <1491484330-12040-8-git-send-email-sakari.ailus@linux.intel.com>
 <1640047.4eZCzTnCCW@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1640047.4eZCzTnCCW@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Fri, Apr 07, 2017 at 12:59:01PM +0300, Laurent Pinchart wrote:
> Hi Sakari,
> 
> Thank you for the patch.
> 
> On Thursday 06 Apr 2017 16:12:09 Sakari Ailus wrote:
> > Instead of including the V4L2 OF header in ReST documentation, use the
> > V4L2 fwnode header instead.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > ---
> >  Documentation/media/kapi/v4l2-core.rst   | 2 +-
> >  Documentation/media/kapi/v4l2-fwnode.rst | 3 +++
> >  Documentation/media/kapi/v4l2-of.rst     | 3 ---
> >  3 files changed, 4 insertions(+), 4 deletions(-)
> >  create mode 100644 Documentation/media/kapi/v4l2-fwnode.rst
> >  delete mode 100644 Documentation/media/kapi/v4l2-of.rst
> > 
> > diff --git a/Documentation/media/kapi/v4l2-core.rst
> > b/Documentation/media/kapi/v4l2-core.rst index e967715..1bc8a14 100644
> > --- a/Documentation/media/kapi/v4l2-core.rst
> > +++ b/Documentation/media/kapi/v4l2-core.rst
> > @@ -19,7 +19,7 @@ Video2Linux devices
> >      v4l2-mc
> >      v4l2-mediabus
> >      v4l2-mem2mem
> > -    v4l2-of
> > +    v4l2-fwnode
> 
> I wonder whether we should keep this alphabetically sorted.

It's not fully sorted at the moment --- see tuner / common below. It'd be
good if it was though. I'll add a patch for that.

> 
> Apart from that,
> 
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Thanks!

> 
> >      v4l2-rect
> >      v4l2-tuner
> >      v4l2-common
> > diff --git a/Documentation/media/kapi/v4l2-fwnode.rst
> > b/Documentation/media/kapi/v4l2-fwnode.rst new file mode 100644
> > index 0000000..6c8bccd
> > --- /dev/null
> > +++ b/Documentation/media/kapi/v4l2-fwnode.rst
> > @@ -0,0 +1,3 @@
> > +V4L2 fwnode kAPI
> > +^^^^^^^^^^^^^^^^
> > +.. kernel-doc:: include/media/v4l2-fwnode.h
> > diff --git a/Documentation/media/kapi/v4l2-of.rst
> > b/Documentation/media/kapi/v4l2-of.rst deleted file mode 100644
> > index 1ddf76b..0000000
> > --- a/Documentation/media/kapi/v4l2-of.rst
> > +++ /dev/null
> > @@ -1,3 +0,0 @@
> > -V4L2 Open Firmware kAPI
> > -^^^^^^^^^^^^^^^^^^^^^^^
> > -.. kernel-doc:: include/media/v4l2-of.h
> 
> -- 
> Regards,
> 
> Laurent Pinchart
> 

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
