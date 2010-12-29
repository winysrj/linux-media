Return-path: <mchehab@gaivota>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:1543 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753519Ab0L2SlL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Dec 2010 13:41:11 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Hans de Goede <hdegoede@redhat.com>
Subject: Re: nasty bug at qv4l2
Date: Wed, 29 Dec 2010 19:40:53 +0100
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <4D11E170.6050500@redhat.com> <4D15FB27.7080302@redhat.com> <4D1A6A54.8050401@redhat.com>
In-Reply-To: <4D1A6A54.8050401@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <201012291940.53929.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Tuesday, December 28, 2010 23:53:08 Hans de Goede wrote:
> Hi,
> 
> On 12/25/2010 03:09 PM, Mauro Carvalho Chehab wrote:
> > Em 25-12-2010 07:14, Mauro Carvalho Chehab escreveu:
> >> Em 24-12-2010 16:54, Hans Verkuil escreveu:
> >>> On Friday, December 24, 2010 15:41:10 Hans de Goede wrote:
> >>>> Hi,
> >>>>
> >>>> On 12/24/2010 03:20 PM, Hans Verkuil wrote:
> >>>>> On Friday, December 24, 2010 15:19:26 Hans de Goede wrote:
> >>>>>> Hi,
> >>>>>>
> >>>>>> On 12/22/2010 12:30 PM, Mauro Carvalho Chehab wrote:
> >>>>>>> Hans V/Hans G,
> >>>>>>>
> >>>>>>> There's a nasty bug at qv4l2 or at libv4l: it is not properly updating
> >>>>>>> all info, if you change the video device. On my tests with uvcvideo (video0)
> >>>>>>> and a gspca camera (pac7302, video1), it was showing the supported formats
> >>>>>>> for the uvcvideo camera when I changed from video0 to video1.
> >>>>>>>
> >>>>>>> The net result is that the image were handled with the wrong decoder
> >>>>>>> (instead of using fourcc V4L2_PIX_FMT_PJPG, it were using BGR3), producing
> >>>>>>> a wrong decoding.
> >>>>>>>
> >>>>>>> Could you please take a look on it?
> >
> > <snip>
> >
> >>> I wonder if Mauro got confused by the different behavior as well.
> >>
> >> I think I used the libv4l way. I'll re-try on both modes. This way, we'll know for sure if
> >> the issue is at libv4l or not.
> >
> > Double checked: when opening in raw mode, everything works fine. However, when
> > opening with "libv4l" mode, it doesn't update the supported formats.
> >
> 
> I've spend some time looking at this, with interesting results. There is a bug
> in libv4lconvert, which gets exposed when using qv4l2 with a pac7311 camera
> (no need to first open another type of device).
> 
> As suspected, qv4l2 tries to call into libv4lconvert directly even when going
> through libv4l. So what happens is:
> 1) qv4l2 sees rgb24 as a format supported by the device and selects it
>     (because of libv4l2 being used)
> 2) qv4l2 still tries to use libv4lconvert directly and ends up setting up
>     conversion from rgb24 to rgb24 (the conversion from pjpg to rgb24 is
>     already done transparently by libv4l)
> 3) libv4lconvert (or rather libv4lcontrol which is part of libv4lconvert)
>     enables software whitebalancing by default on pac7311 cameras
> 
> libv4lconvert has special code to detect src_fmt == dest_fmt and just do
> a memcpy, however this code does not trigger because of 3 (as when doing
> processing just a memcpy is not what we want). However libv4lconvert
> API is based on providing a src and destination buffer, and in this case
> libv4lconvert_convert ends up skipping all steps (conversion, cropping,
> flipping and rotating) except for processing, and the processing code
> works by modifying the buffer it is passed rather then using a separate
> input output buffer, so since none of the other separate input output
> buffer needing steps where done, the data never gets copied to the
> destination buffer!
> 
> I've just pushed a patch to v4l-utils git fixing this bug.
> 
> Note that qv4l2 should still be fixed to not call libv4lconvert directly
> when not in raw mode (instead it should just do a s_fmt rgb24, which
> libv4l will always offer for all supported devices), as the way things
> are now libv4lconvert_convert ends up getting called twice. Which will
> lead to various software processing steps being done twice, which
> is not a problem for whitebalance, but it makes software vflip and
> hflip no-ops. And for cameras which need 90 degrees rotation (pac7302)
> it will completely screw up the image.
> 
> In general an app can either use libv4lconvert directly, or call
> libv4l2 functions and let it deal with handling conversion transparently
> using both at the same time is not supported.

Makes a lot of sense.

I've made a patch for qv4l2 that should fix this. It's included below, but
before I push this I'd like to have some test feedback. I could only test with
ivtv and not with any webcams since I don't have access to them at the moment.

So let me know if this fixes qv4l2 and if so, I'll push the patch.

Regards,

	Hans

>From 9e66659528c5aec7ca7bfd1ec881fe4a921e3c7c Mon Sep 17 00:00:00 2001
Message-Id: <9e66659528c5aec7ca7bfd1ec881fe4a921e3c7c.1293647806.git.hverkuil@xs4all.nl>
From: Hans Verkuil <hverkuil@xs4all.nl>
Date: Wed, 29 Dec 2010 19:33:31 +0100
Subject: [PATCH] qv4l2: don't use v4lconvert directly when using libv4l.
To: linux-media@vger.kernel.org

Only in 'raw' mode should v4lconvert be used, otherwise it will be
called twice causing all software image processing to be done twice
as well.

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 utils/qv4l2/qv4l2.cpp |   34 ++++++++++++++++++++++++++--------
 1 files changed, 26 insertions(+), 8 deletions(-)

diff --git a/utils/qv4l2/qv4l2.cpp b/utils/qv4l2/qv4l2.cpp
index 5646bcf..a085f86 100644
--- a/utils/qv4l2/qv4l2.cpp
+++ b/utils/qv4l2/qv4l2.cpp
@@ -178,7 +178,10 @@ void ApplicationWindow::capFrame()
 	switch (m_capMethod) {
 	case methodRead:
 		s = read(m_frameData, m_capSrcFormat.fmt.pix.sizeimage);
-		err = v4lconvert_convert(m_convertData, &m_capSrcFormat, &m_capDestFormat,
+		if (useWrapper())
+			memcpy(m_capImage->bits(), m_frameData, m_capSrcFormat.fmt.pix.sizeimage);
+		else
+			err = v4lconvert_convert(m_convertData, &m_capSrcFormat, &m_capDestFormat,
 				m_frameData, m_capSrcFormat.fmt.pix.sizeimage,
 				m_capImage->bits(), m_capDestFormat.fmt.pix.sizeimage);
 		break;
@@ -190,7 +193,11 @@ void ApplicationWindow::capFrame()
 			return;
 		}
 
-		err = v4lconvert_convert(m_convertData, &m_capSrcFormat, &m_capDestFormat,
+		if (useWrapper())
+			memcpy(m_capImage->bits(), (unsigned char *)m_buffers[buf.index].start,
+					m_capSrcFormat.fmt.pix.sizeimage);
+		else
+			err = v4lconvert_convert(m_convertData, &m_capSrcFormat, &m_capDestFormat,
 				(unsigned char *)m_buffers[buf.index].start, buf.bytesused,
 				m_capImage->bits(), m_capDestFormat.fmt.pix.sizeimage);
 
@@ -209,7 +216,11 @@ void ApplicationWindow::capFrame()
 					&& buf.length == m_buffers[i].length)
 				break;
 
-		err = v4lconvert_convert(m_convertData, &m_capSrcFormat, &m_capDestFormat,
+		if (useWrapper())
+			memcpy(m_capImage->bits(), (unsigned char *)buf.m.userptr,
+					m_capSrcFormat.fmt.pix.sizeimage);
+		else
+			err = v4lconvert_convert(m_convertData, &m_capSrcFormat, &m_capDestFormat,
 				(unsigned char *)buf.m.userptr, buf.bytesused,
 				m_capImage->bits(), m_capDestFormat.fmt.pix.sizeimage);
 
@@ -410,6 +421,11 @@ void ApplicationWindow::capStart(bool start)
 	}
 	m_capMethod = m_genTab->capMethod();
 	g_fmt_cap(m_capSrcFormat);
+	if (useWrapper()) {
+		m_capSrcFormat.fmt.pix.pixelformat = V4L2_PIX_FMT_RGB24;
+		s_fmt(m_capSrcFormat);
+		g_fmt_cap(m_capSrcFormat);
+	}
 	m_frameData = new unsigned char[m_capSrcFormat.fmt.pix.sizeimage];
 	m_capDestFormat = m_capSrcFormat;
 	m_capDestFormat.fmt.pix.pixelformat = V4L2_PIX_FMT_RGB24;
@@ -421,11 +437,13 @@ void ApplicationWindow::capStart(bool start)
 			break;
 		}
 	}
-	v4lconvert_try_format(m_convertData, &m_capDestFormat, &m_capSrcFormat);
-	// v4lconvert_try_format sometimes modifies the source format if it thinks
-	// that there is a better format available. Restore our selected source
-	// format since we do not want that happening.
-	g_fmt_cap(m_capSrcFormat);
+	if (!useWrapper()) {
+		v4lconvert_try_format(m_convertData, &m_capDestFormat, &m_capSrcFormat);
+		// v4lconvert_try_format sometimes modifies the source format if it thinks
+		// that there is a better format available. Restore our selected source
+		// format since we do not want that happening.
+		g_fmt_cap(m_capSrcFormat);
+	}
 	m_capture->setMinimumSize(m_capDestFormat.fmt.pix.width, m_capDestFormat.fmt.pix.height);
 	m_capImage = new QImage(m_capDestFormat.fmt.pix.width, m_capDestFormat.fmt.pix.height, dstFmt);
 	m_capImage->fill(0);
-- 
1.6.4.2



-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
