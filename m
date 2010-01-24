Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail02a.mail.t-online.hu ([84.2.40.7]:51065 "EHLO
	mail02a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932102Ab0AXRVB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Jan 2010 12:21:01 -0500
Message-ID: <4B5C8172.1090306@freemail.hu>
Date: Sun, 24 Jan 2010 18:20:50 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>,
	Thomas Kaiser <thomas@kaiser-linux.li>,
	Hans de Goede <hdegoede@redhat.com>
CC: V4L Mailing List <linux-media@vger.kernel.org>
Subject: [RFC, PATCH] gspca pac7302: propagate footer to userspace
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I'm dealing with Labtec Webcam 2200 and I found that the pac7302 driver does not
forward the image footer information to userspace. This footer contains some information
which might be interesting to the userspace. What exactly this footer means is
not clear as of this writing, but it is easier to analyze the data in
userspace than in kernel space.

I modified the sd_pkt_scan() in order the footer is transfered to the userspace together
with the image. This, however, breaks the image decoding in libv4lconvert. This is
can be easily solved by passing the image buffer to v4lconvert_convert() truncated by
0x4f bytes.

What do you think the right way would be to transfer image footer to userspace?
Is it necessary to add a new V4L2_PIX_FMT_* format in order not to brake userspace
programs?

PAC7302 footer structure I could figure out so far is:

Offset | Length |Description
-------+--------+----------------------------------------------
 0x0   |   1    | Seen values: 0x10, 0x11, 0x12, 0x13, 0x15, 0x16
       |        | Some kind of sequence number or timestamp?
-------+--------+----------------------------------------------
 0x1   |   1    | Seen values: 0x50
-------+--------+----------------------------------------------
 0x2   |   1    | Seen values: 0x00
-------+--------+----------------------------------------------
 0x3   |   1    | Seen values: 0x00
-------+--------+----------------------------------------------
 0x4   |   1    | Seen values: 0x00
-------+--------+----------------------------------------------
 0x5   |   1    | Seen values: 0x00
-------+--------+----------------------------------------------
 0x6   |   25   | Picutre lumination related bytes.
       |        | The gain setting has influcence on the values
       |        | In test modes:
       |        |  test mode 1 (white):   filled with 0xFE
       |        |  test mode 2 (black):   filled with 0x00
       |        |  test mode 3 (red):     filled with 0x4C
       |        |  test mode 4 (green):   filled with 0x96
       |        |  test mode 5 (blue):    filled with 0x1C
       |        |  test mode 6 (cyan):    filled with 0xB3
       |        |  test mode 7 (magenta): filled with 0x69
       |        |  test mode 8 (yellow):  filled with 0xE1
       |        |  test mode 9 (color bars):
       |        |       9B 6A 7B B1 52 71 68 6B 76 62 9F 9F 9F 9F 9F 8D 61 70 A1 4B 99 6A 7A AF 52
       |        |  test mode 10 (high resolution color pattern):
       |        |       A8 AC A5 A6 A6 A3 A3 A1 A2 A4 A2 9F 9F A0 A5 A5 9F 9F 9C A5 A9 A5 A2 A2 A7
       |        |  test mode 11 (black to white gradient from top to bottom):
       |        |       4B 6E 8A A4 BF 48 6A 85 9E B8 47 68 83 9C B5 47 69 84 9D B7 49 6C 88 A1 BC
       |        |  test mode 12 (white to black gradient from left to right):
       |        |       5A 57 57 57 59 80 7D 7D 7D 80 A0 9D 9C 9C A0 BF BB BA BB BE DC D7 D6 D7 DB
       |        |  test mode 13 (white to black gradient repeats from left to right):
       |        |       A8 A5 A4 A5 A7 A4 A0 9F A0 A4 A4 A0 A2 A0 A3 A5 A2 A2 A1 A5 A5 A3 A2 A2 A5
       |        |  test mode 14 (dark gray):  filled with 0x00
       |        |  test mode 15 (dark gray2): filled with 0x00
-------+--------+----------------------------------------------
 0x1f  |    1   | Seen: 0x00
-------+--------+----------------------------------------------
 0x20  |    2   | Picture content related?
-------+--------+----------------------------------------------
 0x22  |    1   | Seen: 0x00
-------+--------+----------------------------------------------
 0x23  |    2   | Compressed picture size related?
-------+--------+----------------------------------------------
 0x25  |    1   | Seen: 0x00
-------+--------+----------------------------------------------
 0x26  |    1   | Seen: 0x00
-------+--------+----------------------------------------------
 0x27  |    1   | Seen: 0x00
-------+--------+----------------------------------------------
 0x28  |    4   | Picture content related?
-------+--------+----------------------------------------------
 0x2c  |    4   | Picture content related?
-------+--------+----------------------------------------------
 0x30  |    4   | Picture content related?
-------+--------+----------------------------------------------
 0x34  |    4   | Picture content related?
-------+--------+----------------------------------------------
 0x38  |    1   | Seen: fixed 0x01
-------+--------+----------------------------------------------
 0x39  |    1   | Seen: fixed 0xAE
-------+--------+----------------------------------------------
 0x3a  |    1   | Seen: fixed 0x01
-------+--------+----------------------------------------------
 0x3b  |    1   | Seen: fixed 0x04
-------+--------+----------------------------------------------
 0x3c  |    1   | Seen: fixed 0x16
-------+--------+----------------------------------------------
 0x3d  |    1   | Seen: fixed 0x14
-------+--------+----------------------------------------------
 0x3e  |    1   | Seen: fixed 0x14
-------+--------+----------------------------------------------
 0x3f  |    1   | Seen: fixed 0x12
-------+--------+----------------------------------------------
 0x40  |   10   | Seen: fixed content: filled with 0x00
-------+--------+----------------------------------------------
 0x4a  |    5   | Fixed content: 0xFF, 0xFF, 0x00, 0xFF, 0x96
-------+--------+----------------------------------------------

Regards,

	Márton Németh

---
From: Márton Németh <nm127@freemail.hu>

Also propagate the image footer received from the webcam at the end of the
image data.

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
diff -r 875c200a19dc linux/drivers/media/video/gspca/pac7302.c
--- a/linux/drivers/media/video/gspca/pac7302.c	Sun Jan 17 07:58:51 2010 +0100
+++ b/linux/drivers/media/video/gspca/pac7302.c	Sun Jan 24 17:49:20 2010 +0100
@@ -870,10 +873,10 @@
 		   image, the 14th and 15th byte after the EOF seem to
 		   correspond to the center of the image */
 		lum_offset = 61 + sizeof pac_sof_marker;
-		footer_length = 74;
+		footer_length = 74 + sizeof(pac_sof_marker);

 		/* Finish decoding current frame */
-		n = (sof - data) - (footer_length + sizeof pac_sof_marker);
+		n = sof - data;
 		if (n < 0) {
 			frame->data_end += n;
 			n = 0;
@@ -881,8 +884,8 @@
 		gspca_frame_add(gspca_dev, INTER_PACKET,
 					data, n);
 		if (gspca_dev->last_packet_type != DISCARD_PACKET &&
-				frame->data_end[-2] == 0xff &&
-				frame->data_end[-1] == 0xd9)
+				frame->data_end[-footer_length-2] == 0xff &&
+				frame->data_end[-footer_length-1] == 0xd9)
 			gspca_frame_add(gspca_dev, LAST_PACKET,
 						NULL, 0);

