Return-path: <mchehab@pedra>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:26193 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932326Ab1CWLJo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Mar 2011 07:09:44 -0400
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8
Received: from eu_spt1 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LII007JQCC59630@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 23 Mar 2011 11:09:41 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LII00JYWCC4JQ@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 23 Mar 2011 11:09:40 +0000 (GMT)
Date: Wed, 23 Mar 2011 12:09:33 +0100
From: Kamil Debski <k.debski@samsung.com>
Subject: =?UTF-8?q?=5BRFC/PATCH=5D=20v4l=3A=20add=20fourcc=20definitons=20for=20compressed=20formats=2E?=
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	kyungmin.park@samsung.com, Kamil Debski <k.debski@samsung.com>
Message-id: <1300878573-13289-1-git-send-email-k.debski@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Add fourcc definitions for the following compressed formats:
H264, H264 without start codes, MPEG1/2/4 ES, DIVX versions
3.11, 4, 5.0-5.0.2, 5.03 and up, XVID, VC1 Simple/Main Profile
and VC1 Advanced profile.
---
Hi,

During the v4l2 brain storming meeting in Warsaw one of the topics was assigning
fourcc values for compressed elementary streams.

I did some research - which included checking the VC1 and DivX formats. For
other codecs: Xvid, MPEG1/2/4 and H263 the choice of fourcc values was clear.
We have also had discussion regarding the H264 codec, which resulted in having
two fourccs - one with start codes and one without.

*** MPEG ***
'MPEG' fourcc will remain reserved for transport/program streams. For elementary
MPEG streams the proposed fourccs are:
* 'MPG1' for MPEG1
* 'MPG2' for MPEG2
* 'MPG4' for MPEG4

*** H263 ***
For H263 the ‘H263’ fourcc value is reasonable.

*** Xvid ***
‘XVID’ fourcc seems a good choice.

*** H264 ***
H264 elementary stream can come in two flavours: one with start codes and one
without.  Following fourccs are proposed:
* 'H264' for NALUs with start codes (start codes are a fixed pattern used to
locate packet boundaries). [1]
* 'AVC1' for NALUs without start codes (framing needs to be provided out of
band, for instance by providing a length field for each packet). [1]

Links:
[1] http://msdn.microsoft.com/en-us/library/dd757808%28v=vs.85%29.aspx

*** VC1 ***
VC1 streams have different content based on the profile. VC1 Advanced profile
has start codes and Main and Simple profile relies on the Transport Layer to
provide frame start and length. For VC1 AP the stream content is defined
Annex E. For VC1 SP and MP the streamz by Annex J and Annex L of the SMPTE 421M.

"In the advanced profile, pictures and slices shall be byte-aligned and carried
in a bitstream data unit (as described in Annex E). Each new picture or a slice,
is detected via start-codes as defined in Annex E. In the simple and main
profiles,pictures shall be byte-aligned. For each coded picture, the pointer to
the coded bitstream, and its size shall be communicated to the decoder by the
Transport Layer. In simple and main profiles, a picture whose coded size is less
than or equal to one byte shall be considered to be a skipped picture."
SMPTE 421M Draft [2]

Following fourccs are proposed:
* 'WVC1' for VC1 Advanced Profile [1]
* 'WMV3' for VC1 Main and Simple profiles [1]

Links:
[1] http://wiki.multimedia.cx/index.php?title=VC1 - Fourccs used by Microsoft
[2] http://multimedia.cx/mirror/s421m.pdf - Proposed SMPTE Standard

*** DivX ***
It is reasonable that versions 3.11, 4 and 5 should have different fourccs.
According to the document I have, there also were important changes and bugfixes
done in DivX 5.0.3. Hence I propose to have a separate fourcc for DivX versions
5.0.0-5.0.2.

Following fourccs are proposed:
* 'DIV3' for DivX 3.11
* 'DIV4' for DivX 4.x
* 'DX50' for Divx 5.0.0-5.0.2
* 'DIV5' for Divx 5.0.3 and newer

There are quite a few differences between versions 5.0 - 5.02 and 5.0.3. Those
include:
- quarter pixel motion compensation follows the algorithm described in the
  Corrigendum 2 of the ISO/IEC 14496-2 document. (versions prior to 5.0.3 had
  used the algorithm described in a previous document)
- new deringing algorithm
- motion vectors are stored in a different way

I appreciate your comments.

Best regards,
--
Kamil Debski
Linux Platform Group
Samsung Poland R&D Center
---
 include/linux/videodev2.h |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index aa6c393..5d80e95 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -372,6 +372,19 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_JPEG     v4l2_fourcc('J', 'P', 'E', 'G') /* JFIF JPEG     */
 #define V4L2_PIX_FMT_DV       v4l2_fourcc('d', 'v', 's', 'd') /* 1394          */
 #define V4L2_PIX_FMT_MPEG     v4l2_fourcc('M', 'P', 'E', 'G') /* MPEG-1/2/4    */
+#define V4L2_PIX_FMT_H264     v4l2_fourcc('H', '2', '6', '4') /* H264 with start codes */
+#define V4L2_PIX_FMT_H264_NO_SC v4l2_fourcc('A', 'V', 'C', '1') /* H264 without start codes */
+#define V4L2_PIX_FMT_H263     v4l2_fourcc('H', '2', '6', '3') /* H263          */
+#define V4L2_PIX_FMT_MPEG1    v4l2_fourcc('M', 'P', 'G', '1') /* MPEG-1 ES     */
+#define V4L2_PIX_FMT_MPEG2    v4l2_fourcc('M', 'P', 'G', '2') /* MPEG-2 ES     */
+#define V4L2_PIX_FMT_MPEG4    v4l2_fourcc('M', 'P', 'G', '4') /* MPEG-4 ES     */
+#define V4L2_PIX_FMT_DIVX3    v4l2_fourcc('D', 'I', 'V', '3') /* DivX 3.11     */
+#define V4L2_PIX_FMT_DIVX4    v4l2_fourcc('D', 'I', 'V', '4') /* DivX 4.12     */
+#define V4L2_PIX_FMT_DIVX500  v4l2_fourcc('D', 'X', '5', '0') /* DivX 5.00 - 5.02  */
+#define V4L2_PIX_FMT_DIVX5    v4l2_fourcc('D', 'I', 'V', '5') /* DivX 5.03 - x  */
+#define V4L2_PIX_FMT_XVID     v4l2_fourcc('X', 'V', 'I', 'D') /* Xvid           */
+#define V4L2_PIX_FMT_VC1      v4l2_fourcc('W', 'M', 'V', '3') /* VC-1 Main and simple profiles */
+#define V4L2_PIX_FMT_VC1_AP   v4l2_fourcc('W', 'V', 'C', '1') /* VC-1 Advanced profile */
 
 /*  Vendor-specific formats   */
 #define V4L2_PIX_FMT_CPIA1    v4l2_fourcc('C', 'P', 'I', 'A') /* cpia1 YUV */
-- 
1.6.3.3
