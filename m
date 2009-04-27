Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail3.sea5.speakeasy.net ([69.17.117.5]:52542 "EHLO
	mail3.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099AbZD0Tbk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Apr 2009 15:31:40 -0400
Date: Mon, 27 Apr 2009 12:31:39 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: MJPEG-tools user list <mjpeg-users@lists.sourceforge.net>
cc: Andrew Morton <akpm@linux-foundation.org>, roel.kluin@gmail.com,
	linux-media@vger.kernel.org
Subject: Re: [Mjpeg-users] [PATCH] zoran: invalid test on unsigned
In-Reply-To: <20090427165256.57940d06@lxorguk.ukuu.org.uk>
Message-ID: <Pine.LNX.4.58.0904271039510.3753@shell2.speakeasy.net>
References: <49F48183.50302@gmail.com> <20090427165256.57940d06@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 27 Apr 2009, Alan Cox wrote:
> On Sun, 26 Apr 2009 17:45:07 +0200
> Roel Kluin <roel.kluin@gmail.com> wrote:
> > fmt->index is unsigned. test doesn't work
> >
> > Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> > ---
> > Is there another test required?
> >
> > +++ b/drivers/media/video/zoran/zoran_driver.c
> > @@ -1871,7 +1871,7 @@ static int zoran_enum_fmt(struct zoran *zr, struct v4l2_fmtdesc *fmt, int flag)
> >  		if (num == fmt->index)
> >  			break;
> >  	}
> > -	if (fmt->index < 0 /* late, but not too late */  || i == NUM_FORMATS)
> > +	if (i == NUM_FORMATS)
> >  		return -EINVAL;
>
> If it's unsigned then don't we need i >= NUM_FORMATS ?

That part of the patch is fine.  It turns out there is another problem that
already existed in this function.  It's clearer with a few more lines of
context.

        int num = -1, i;
        for (i = 0; i < NUM_FORMATS; i++) {
                if (zoran_formats[i].flags & flag)
                        num++;
                if (num == fmt->index)
                        break;
        }
      	if (i == NUM_FORMATS)
                return -EINVAL;
	/* stuff to return format i */

The v4l2 api enumerates formats separately for each buffer type, e.g. there
is one list of formats for video capture and a different list for video
output.  The driver just has one list of formats and each format is flagged
with the type(s) it can be used with.  So when someone requests the capture
format at index 2 we search the list and return the 3rd capture format we
find.  Since we don't know how many capture formats there are (NUM_FORMATS
is the number of formats in the driver's single list, i.e. the union of all
format types) we can't reject an index that is too large until after
searching the whole list.

The problem with this code is if someone requests a format at fmt->index ==
(unsigned)-1.  If the first format in the array doesn't have the requested
type then num will still be -1 when it's compared to fmt->index and there
will appear to be a match.

Here's a patch to redo the function that should fix everything:

zoran: fix bug when enumerating format -1

If someone requests a format at fmt->index == (unsigned)-1 and the first
format in the array doesn't have the requested type then num will still be
-1 when it's compared to fmt->index and there will appear to be a match.

Restructure the loop so this can't happen.  It's simpler this way too.  The
unnecessary check for (unsigned)fmt->index < 0 found by Roel Kluin
<roel.kluin@gmail.com> is removed this way too.

Signed-off-by: Trent Piepho <xyzzy@speakeasy.org>

diff -r 63eba6df4b8a -r c247021eb11c linux/drivers/media/video/zoran/zoran_driver.c
--- a/linux/drivers/media/video/zoran/zoran_driver.c    Mon Apr 27 12:13:04 2009 -0700
+++ b/linux/drivers/media/video/zoran/zoran_driver.c    Mon Apr 27 12:25:51 2009 -0700
@@ -1871,22 +1871,20 @@ static int zoran_querycap(struct file *f

 static int zoran_enum_fmt(struct zoran *zr, struct v4l2_fmtdesc *fmt, int flag)
 {
-       int num = -1, i;
-
-       for (i = 0; i < NUM_FORMATS; i++) {
-               if (zoran_formats[i].flags & flag)
-                       num++;
-               if (num == fmt->index)
-                       break;
-       }
-       if (fmt->index < 0 /* late, but not too late */  || i == NUM_FORMATS)
-               return -EINVAL;
-
-       strncpy(fmt->description, zoran_formats[i].name, sizeof(fmt->description)-1);
-       fmt->pixelformat = zoran_formats[i].fourcc;
-       if (zoran_formats[i].flags & ZORAN_FORMAT_COMPRESSED)
-               fmt->flags |= V4L2_FMT_FLAG_COMPRESSED;
-       return 0;
+       unsigned int num, i;
+
+       for (num = i = 0; i < NUM_FORMATS; i++) {
+               if (zoran_formats[i].flags & flag && num++ == fmt->index) {
+                       strncpy(fmt->description, zoran_formats[i].name,
+                               sizeof(fmt->description) - 1);
+                       /* fmt struct pre-zeroed, so adding '\0' not neeed */
+                       fmt->pixelformat = zoran_formats[i].fourcc;
+                       if (zoran_formats[i].flags & ZORAN_FORMAT_COMPRESSED)
+                               fmt->flags |= V4L2_FMT_FLAG_COMPRESSED;
+                       return 0;
+               }
+       }
+       return -EINVAL;
 }

 static int zoran_enum_fmt_vid_cap(struct file *file, void *__fh,

