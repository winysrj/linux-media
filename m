Return-path: <mchehab@pedra>
Received: from utopia.booyaka.com ([72.9.107.138]:53528 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809Ab0JIEbl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Oct 2010 00:31:41 -0400
Date: Fri, 8 Oct 2010 22:31:40 -0600 (MDT)
From: Paul Walmsley <paul@booyaka.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	mchehab@infradead.org, linux-media@vger.kernel.org
Subject: [PATCH] V4L/DVB: tvp5150: COMPOSITE0 input should not force-enable
 TV mode
Message-ID: <alpine.DEB.2.00.1010082229160.15379@utopia.booyaka.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


When digitizing composite video from a analog videotape source using the 
TVP5150's first composite input channel, the captured stream exhibits 
tearing and synchronization problems[1].

It turns out that commit c0477ad9feca01bd8eff95d7482c33753d05c700 caused 
"TV mode" (as opposed to "VCR mode" or "auto-detect") to be forcibly 
enabled for both composite inputs.  According to the chip 
documentation[2], "TV mode" disables a "chrominance trap" input filter, 
which appears to be necessary for high-quality video capture from an 
analog videotape source.  [ Commit 
c7c0b34c27bbf0671807e902fbfea6270c8f138d subsequently restricted the 
problem to the first composite input, apparently inadvertently. ]

Since any type of composite signal source can be connected to the 
TVP5150's first composite input, unconditionally forcing "TV mode" isn't 
correct.  There doesn't appear to be a good way for applications to tell 
the driver what is connected.  Fortunately, the TVP5150 has an operating 
mode auto-detection feature, which, when enabled, should cause the TVP5150 
to auto-detect whether it should use "VCR mode" or "TV mode".  Enabling 
operating mode auto-detection improved video capture quality 
significantly[3].

Therefore, fix this bug by using operating mode auto-detection. (Also, 
while here, fix a CodingStyle issue.)

For those users who may find this patch via a mailing list archive but who 
are not able to upgrade to a kernel with a fixed driver: the TVP5150's 
S-Video and second composite input sources have auto-detection enabled, so 
you may wish to try using those -- if available on your device -- until 
this fix makes it a downstream distribution near you.

References:

1. Pre-patch tvtime snapshot using a Pinnacle PCTV HD Pro as the
   capture device and a Sony EV-S2000 as a video source:
   http://www.booyaka.com/~paul/tvp5150/1a.png

2. Section 3.21.3, "Operation Mode Control Register", _TVP5150AM1
   Ultralow-Power NTSC/PAL/SECAM Video Decoder (Rev. D)_ [SLES209D],
   downloaded 8 October 2010, available via
   http://focus.ti.com/lit/ds/symlink/tvp5150am1.pdf

3. Post-patch tvtime snapshot (same signal chain as #1, above):
   http://www.booyaka.com/~paul/tvp5150/1b.png

Signed-off-by: Paul Walmsley <paul@booyaka.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>

---
 drivers/media/video/tvp5150.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/tvp5150.c b/drivers/media/video/tvp5150.c
index 1654f65..e4dfb67 100644
--- a/drivers/media/video/tvp5150.c
+++ b/drivers/media/video/tvp5150.c
@@ -277,7 +277,7 @@ static int tvp5150_log_status(struct v4l2_subdev *sd)
 
 static inline void tvp5150_selmux(struct v4l2_subdev *sd)
 {
-	int opmode=0;
+	int opmode = 0;
 	struct tvp5150 *decoder = to_tvp5150(sd);
 	int input = 0;
 	unsigned char val;
@@ -290,12 +290,10 @@ static inline void tvp5150_selmux(struct v4l2_subdev *sd)
 		input |= 2;
 		/* fall through */
 	case TVP5150_COMPOSITE0:
-		opmode=0x30;		/* TV Mode */
 		break;
 	case TVP5150_SVIDEO:
 	default:
 		input |= 1;
-		opmode=0;		/* Auto Mode */
 		break;
 	}
 
-- 
1.7.1

