Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:55877
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753962AbdIDUni (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 4 Sep 2017 16:43:38 -0400
Date: Mon, 4 Sep 2017 17:43:28 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-doc@vger.kernel.org, linux-media@vger.kernel.org,
        mchehab@infradead.org, linux-kernel@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Aviv Greenberg <aviv.d.greenberg@intel.com>
Subject: Re: [PATCH 1/1] docs-rst: media: Don't use \small for
 V4L2_PIX_FMT_SRGGB10 documentation
Message-ID: <20170904174328.7415ea1f@vento.lan>
In-Reply-To: <20170903224002.071c1587@vento.lan>
References: <82fc5322d611390dca21f28e3fd5f7cbe0c27be4.1504464984.git.mchehab@s-opensource.com>
        <20170903201233.31638-1-sakari.ailus@linux.intel.com>
        <20170903224002.071c1587@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 3 Sep 2017 22:40:02 -0300
Mauro Carvalho Chehab <mchehab@s-opensource.com> escreveu:

> Em Sun,  3 Sep 2017 23:12:33 +0300
> Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:
> 
> > There appears to be an issue in using \small in certain cases on Sphinx
> > 1.4 and 1.5. Other format documents don't use \small either, remove it
> > from here as well.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > ---
> > Hi Mauro,
> > 
> > What would you think of this as an alternative approach? No hacks needed.
> > Just a recognition \small could have issues. For what it's worth, I
> > couldn't reproduce the issue on Sphinx 1.4.9.
> 
> Btw, there are other places where \small runs smoothly. It is *just*
> on this table that it has issues.
> 
> 
> > 
> > Regards,
> > Sakari
> > 
> >  Documentation/media/uapi/v4l/pixfmt-srggb10p.rst | 11 -----------
> >  1 file changed, 11 deletions(-)
> > 
> > diff --git a/Documentation/media/uapi/v4l/pixfmt-srggb10p.rst b/Documentation/media/uapi/v4l/pixfmt-srggb10p.rst
> > index 86cd07e5bfa3..368ee61ab209 100644
> > --- a/Documentation/media/uapi/v4l/pixfmt-srggb10p.rst
> > +++ b/Documentation/media/uapi/v4l/pixfmt-srggb10p.rst
> > @@ -33,13 +33,6 @@ of a small V4L2_PIX_FMT_SBGGR10P image:
> >  **Byte Order.**
> >  Each cell is one byte.
> >  
> > -
> > -.. raw:: latex
> > -
> > -    \small
> 
> Interesting... yeah, that could be possible.
> 
> > -
> > -.. tabularcolumns:: |p{2.0cm}|p{1.0cm}|p{1.0cm}|p{1.0cm}|p{1.0cm}|p{10.0cm}|
> 
> Nah... Without tabularcolumns, LaTeX usually got sizes wrong and don't
> always place things at the right positions I'm actually considering 
> adding it to all media tables, in order to be less dependent on
> LaTex automatic cells resizing - with doesn't seem to work too well.
> 
> So, better to keep it, even if it works without
> \small. Btw, tried your patch here (without tabularcolumns) on
> Sphinx 1.6 (tomorrow, I'll do tests with other version). There, the
> last "(bits x-y)" ends by being wrapped to the next line.
> 
> Yet, I guess the enclosed diff (or something like that) would be
> good enough (applied after my own patch, just to quickly test it). 
> 
> I'll play more with it tomorrow.

OK, that works. Thanks!

I rebased your patch, keeping tabularcolumns and adding blank lines
to reduce the column size.

That works really better.

I also added a second patch doing the same for srggb12p.


Thanks,
Mauro
