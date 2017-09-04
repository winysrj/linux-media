Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:53099
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753120AbdIDBkN (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 3 Sep 2017 21:40:13 -0400
Date: Sun, 3 Sep 2017 22:40:02 -0300
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
Message-ID: <20170903224002.071c1587@vento.lan>
In-Reply-To: <20170903201233.31638-1-sakari.ailus@linux.intel.com>
References: <82fc5322d611390dca21f28e3fd5f7cbe0c27be4.1504464984.git.mchehab@s-opensource.com>
        <20170903201233.31638-1-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun,  3 Sep 2017 23:12:33 +0300
Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:

> There appears to be an issue in using \small in certain cases on Sphinx
> 1.4 and 1.5. Other format documents don't use \small either, remove it
> from here as well.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
> Hi Mauro,
> 
> What would you think of this as an alternative approach? No hacks needed.
> Just a recognition \small could have issues. For what it's worth, I
> couldn't reproduce the issue on Sphinx 1.4.9.

Btw, there are other places where \small runs smoothly. It is *just*
on this table that it has issues.


> 
> Regards,
> Sakari
> 
>  Documentation/media/uapi/v4l/pixfmt-srggb10p.rst | 11 -----------
>  1 file changed, 11 deletions(-)
> 
> diff --git a/Documentation/media/uapi/v4l/pixfmt-srggb10p.rst b/Documentation/media/uapi/v4l/pixfmt-srggb10p.rst
> index 86cd07e5bfa3..368ee61ab209 100644
> --- a/Documentation/media/uapi/v4l/pixfmt-srggb10p.rst
> +++ b/Documentation/media/uapi/v4l/pixfmt-srggb10p.rst
> @@ -33,13 +33,6 @@ of a small V4L2_PIX_FMT_SBGGR10P image:
>  **Byte Order.**
>  Each cell is one byte.
>  
> -
> -.. raw:: latex
> -
> -    \small

Interesting... yeah, that could be possible.

> -
> -.. tabularcolumns:: |p{2.0cm}|p{1.0cm}|p{1.0cm}|p{1.0cm}|p{1.0cm}|p{10.0cm}|

Nah... Without tabularcolumns, LaTeX usually got sizes wrong and don't
always place things at the right positions I'm actually considering 
adding it to all media tables, in order to be less dependent on
LaTex automatic cells resizing - with doesn't seem to work too well.

So, better to keep it, even if it works without
\small. Btw, tried your patch here (without tabularcolumns) on
Sphinx 1.6 (tomorrow, I'll do tests with other version). There, the
last "(bits x-y)" ends by being wrapped to the next line.

Yet, I guess the enclosed diff (or something like that) would be
good enough (applied after my own patch, just to quickly test it). 

I'll play more with it tomorrow.

Thanks,
Mauro

diff --git a/Documentation/media/uapi/v4l/pixfmt-srggb10p.rst b/Documentation/media/uapi/v4l/pixfmt-srggb10p.rst
index aa3dbf163b97..10350f3e4350 100644
--- a/Documentation/media/uapi/v4l/pixfmt-srggb10p.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-srggb10p.rst
@@ -33,24 +33,7 @@ of a small V4L2_PIX_FMT_SBGGR10P image:
 **Byte Order.**
 Each cell is one byte.
 
-.. raw:: latex
-
-    \small
-
-.. HACK:
-
-   On Sphinx 1.4 and 1.5, the usage of \small just before the table
-   causes it to continue at the same column where the above text ended.
-
-   A possible solution would be to add a \newline on latex raw.
-   Unfortunately, that causes a breakage on Sphinx 1.6.
-
-   So, we're placing the \small before this note, with should be producing
-   the same result on all versions
-
-.
-
-.. tabularcolumns:: |p{2.0cm}|p{1.0cm}|p{1.0cm}|p{1.0cm}|p{1.0cm}|p{10.0cm}|
+.. tabularcolumns:: |p{2.0cm}|p{1.0cm}|p{1.0cm}|p{1.0cm}|p{1.0cm}|p{6.0cm}|
 
 .. flat-table::
     :header-rows:  0
@@ -63,6 +46,7 @@ Each cell is one byte.
       - B\ :sub:`02high`
       - G\ :sub:`03high`
       - G\ :sub:`03low`\ (bits 7--6) B\ :sub:`02low`\ (bits 5--4)
+
 	G\ :sub:`01low`\ (bits 3--2) B\ :sub:`00low`\ (bits 1--0)
     * - start + 5:
       - G\ :sub:`10high`
@@ -70,6 +54,7 @@ Each cell is one byte.
       - G\ :sub:`12high`
       - R\ :sub:`13high`
       - R\ :sub:`13low`\ (bits 7--6) G\ :sub:`12low`\ (bits 5--4)
+
 	R\ :sub:`11low`\ (bits 3--2) G\ :sub:`10low`\ (bits 1--0)
     * - start + 10:
       - B\ :sub:`20high`
@@ -77,6 +62,7 @@ Each cell is one byte.
       - B\ :sub:`22high`
       - G\ :sub:`23high`
       - G\ :sub:`23low`\ (bits 7--6) B\ :sub:`22low`\ (bits 5--4)
+
 	G\ :sub:`21low`\ (bits 3--2) B\ :sub:`20low`\ (bits 1--0)
     * - start + 15:
       - G\ :sub:`30high`
@@ -84,8 +70,5 @@ Each cell is one byte.
       - G\ :sub:`32high`
       - R\ :sub:`33high`
       - R\ :sub:`33low`\ (bits 7--6) G\ :sub:`32low`\ (bits 5--4)
-	R\ :sub:`31low`\ (bits 3--2) G\ :sub:`30low`\ (bits 1--0)
-
-.. raw:: latex
 
-    \normalsize
+	R\ :sub:`31low`\ (bits 3--2) G\ :sub:`30low`\ (bits 1--0)
