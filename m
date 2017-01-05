Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:36200 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751525AbdAESgi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 5 Jan 2017 13:36:38 -0500
Date: Thu, 5 Jan 2017 20:27:17 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: ayaka <ayaka@soulik.info>
Cc: dri-devel@lists.freedesktop.org, ville.syrjala@linux.intel.com,
        randy.li@rock-chips.com, linux-kernel@vger.kernel.org,
        daniel.vetter@intel.com, mchehab@kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH v2 2/2] [media] v4l: Add 10/16-bits per channel YUV pixel
 formats
Message-ID: <20170105182717.GU3958@valkosipuli.retiisi.org.uk>
References: <1483547351-5792-1-git-send-email-ayaka@soulik.info>
 <1483547351-5792-3-git-send-email-ayaka@soulik.info>
 <20170105103037.GT3958@valkosipuli.retiisi.org.uk>
 <9a7e7ffd-27d5-0fff-2be5-03f14cc78683@soulik.info>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a7e7ffd-27d5-0fff-2be5-03f14cc78683@soulik.info>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Randy,

On Thu, Jan 05, 2017 at 11:22:26PM +0800, ayaka wrote:
> 
> 
> On 01/05/2017 06:30 PM, Sakari Ailus wrote:
> >Hi Randy,
> >
> >Thanks for the update.
> >
> >On Thu, Jan 05, 2017 at 12:29:11AM +0800, Randy Li wrote:
> >>The formats added by this patch are:
> >>	V4L2_PIX_FMT_P010
> >>	V4L2_PIX_FMT_P010M
> >>	V4L2_PIX_FMT_P016
> >>	V4L2_PIX_FMT_P016M
> >>Currently, none of driver uses those format, but some video device
> >>has been confirmed with could as those format for video output.
> >>The Rockchip's new decoder has supported those 10 bits format for
> >>profile_10 HEVC/AVC video.
> >>
> >>Signed-off-by: Randy Li <ayaka@soulik.info>
> >>
> >>v4l2
> >>---
> >>  Documentation/media/uapi/v4l/pixfmt-p010.rst  |  86 ++++++++++++++++
> >>  Documentation/media/uapi/v4l/pixfmt-p010m.rst |  94 ++++++++++++++++++
> >>  Documentation/media/uapi/v4l/pixfmt-p016.rst  | 126 ++++++++++++++++++++++++
> >>  Documentation/media/uapi/v4l/pixfmt-p016m.rst | 136 ++++++++++++++++++++++++++
> >You need to include the formats in pixfmt.rst in order to compile the
> >documentation.
> >
> >$ make htmldocs
> >
> >And you'll find it in Documentation/output/media/uapi/v4l/v4l2.html .
> >
> >In Debian you'll need to install sphinx-common and python3-sphinx-rtd-theme
> >.
> OK, I would fix them in new version.
> The view of byte order for P010 serial is left empty, it is a little hard
> for me to use flat-table to draw them. Is there possible to use something
> like latex to do this job?

Hmm. Not as far as I know. We recently switched from DocBook mostly due to
ReST being more simple to use AFAIU. I think LaTeX output could be produced
ReST, that might not be very helpful here though.

> >
> >Regarding P010 and the rest --- I'm fine with that, considering also that
> >NV12 was never a great name for a format...
> >
> 

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
