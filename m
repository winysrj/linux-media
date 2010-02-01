Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail02d.mail.t-online.hu ([84.2.42.7]:50071 "EHLO
	mail02d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755087Ab0BAVYG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Feb 2010 16:24:06 -0500
Message-ID: <4B67466F.1030301@freemail.hu>
Date: Mon, 01 Feb 2010 22:23:59 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>
CC: V4L Mailing List <linux-media@vger.kernel.org>
Subject: libv4l: possible problem found in PAC7302 JPEG decoding
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hans,

while I was dealing with Labtec Webcam 2200 and with gspca_pac7302 driver I recognised the
following behaviour. The stream received from the webcam is splitted by the gspca_pac7302
subdriver when the byte sequence 0xff, 0xff, 0x00, 0xff, 0x96 is found (pac_find_sof()).
Before transmitting the data to the userspace a JPEG header is added (pac_start_frame())
and the footer after the bytes 0xff, 0xd9 are removed.

The data buffer which arrives to userspace looks like as follows (maybe not every detail is exact):

 1. JPEG header

 2. Some bytes of image data (near to 1024 bytes)

 3. The byte sequence 0xff, 0xff, 0xff, 0x01 followed by 1024 bytes of data.
    This marker sequence and data repeats a couple of time. Exactly how much
    depends on the image content.

 4. The byte sequence 0xff, 0xff, 0xff, 0x02 followed by 512 bytes of data.
    This marker sequence and data also repeats a couple of time.

 5. The byte sequence 0xff, 0xff, 0xff, 0x00 followed by a variable amount of
    image data bytes.

 6. The End of Image (EOI) marker 0xff, 0xd9.

Now what can be wrong with the libv4l? In libv4lconvert/tinyjpeg.c, line 315 there is a
huge macro which tries to remove the 0xff, 0xff, 0xff, xx byte sequence from the received
image. This fails, however, if the image contains 0xff bytes just before the 0xff, 0xff,
0xff, xx sequence because one byte from the image data (the first 0xff) is removed, then
the three 0xff bytes from the marker is also removed. The xx (which really belongs to the
marker) is left in the image data instead of the original 0xff byte.

Based on my experiments this problem sometimes causes corrupted image decoding or that the
JPEG image cannot be decoded at all.

I have done my experiments with a modified gspca_pac7302 kernel space driver (the JPEG header
is not added and the footer is not removed). In userspace I added the JPEG header and
then applied the following filter function to the received data. The result is that I do
not get any corrupted frame anymore. The filter function in userspace is based on a state
machine like this:

static int memcpy_filter(unsigned char *dest, unsigned char *src, int n)
{
	int i = 0;
	int j = 0;
	int state = 0;
	int last_i = 0;

	i = 5;
	j = 0;

	/* Skip the first 5 bytes: 0xff 0xff 0x00 0xff 0x96 */
	memcpy(&(dest[j]), &(src[i]), 1024-5);
	i += 1024-5;
	j += 1024-5;

	while (i < n) {
		switch (state) {
			case 0:
				if (src[i] == 0xff)
					state = 1;
				else {
					state = 0;
					dest[j++] = src[i];
				}
				break;
			case 1:
				if (src[i] == 0xff)
					state = 2;
				else {
					state = 0;
					dest[j++] = src[i-1];
					dest[j++] = src[i];
				}
				break;
			case 2:
				switch (src[i]) {
					case 0xff:
						state = 3;
						break;
					default:
						state = 0;
						dest[j++] = src[i-2];
						dest[j++] = src[i-1];
						dest[j++] = src[i];
				}
				break;
			case 3:
				switch (src[i]) {
					case 0:
						/* found 0xff 0xff 0xff 0x00 */
						state = 0;
						break;
					case 1:
						/* found 0xff 0xff 0xff 0x01 */
						last_i = i+1;
						memcpy(&(dest[j]), &(src[i+1]), 1024);
						i += 1024;
						j += 1024;
						state = 0;
						break;
					case 2:
						/* found 0xff 0xff 0xff 0x02 */
						last_i = i+1;
						memcpy(&(dest[j]), &(src[i+1]), 512);
						i += 512;
						j += 512;
						state = 0;
						break;
					case 0xff:
						/* found the 4th 0xff in a row, lets copy the first
						   one and keep the last three for later use */
						dest[j++] = src[i-3];
						state = 3;
						break;

					default:
						state = 0;
						dest[j++] = src[i-3];
						dest[j++] = src[i-2];
						dest[j++] = src[i-1];
						dest[j++] = src[i];
				
				}
		}
		i++;
	}

	/* return the length of the dest buffer */
	return j;
}

The solution is not 100% solution because there are some cases when the decoding fails, but
the error rate is much lower.

I think it is possible to solve this kind of problem just by modifying the pixart_fill_nbits()
macro. What do you think?

Best regarsd,

	Márton Németh

PS: here is the patch I used in kernel space, just for easier reference

---
Signed-off-by: Márton Németh <nm127@freemail.hu>
---
diff -r 4f102b2f7ac1 linux/drivers/media/video/gspca/pac7302.c
--- a/linux/drivers/media/video/gspca/pac7302.c	Thu Jan 28 20:35:40 2010 +0100
+++ b/linux/drivers/media/video/gspca/pac7302.c	Mon Feb 01 22:09:15 2010 +0100
@@ -835,6 +835,7 @@
 {
 	unsigned char tmpbuf[4];

+#if 0
 	gspca_frame_add(gspca_dev, FIRST_PACKET,
 		pac_jpeg_header1, sizeof(pac_jpeg_header1));

@@ -847,6 +848,11 @@
 		tmpbuf, sizeof(tmpbuf));
 	gspca_frame_add(gspca_dev, INTER_PACKET,
 		pac_jpeg_header2, sizeof(pac_jpeg_header2));
+#else
+	gspca_frame_add(gspca_dev, FIRST_PACKET,
+		NULL, 0);
+#endif
+
 }

 /* this function is run at interrupt level */
@@ -873,10 +879,10 @@
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
@@ -884,11 +890,13 @@
 		gspca_frame_add(gspca_dev, INTER_PACKET,
 					data, n);
 		if (gspca_dev->last_packet_type != DISCARD_PACKET &&
-				frame->data_end[-2] == 0xff &&
-				frame->data_end[-1] == 0xd9)
+				frame->data_end[-footer_length-2] == 0xff &&
+				frame->data_end[-footer_length-1] == 0xd9)
 			gspca_frame_add(gspca_dev, LAST_PACKET,
 						NULL, 0);

+		sof -= 5;
+
 		n = sof - data;
 		len -= n;
 		data = sof;
