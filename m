Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:8077 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778Ab0DXM5u (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Apr 2010 08:57:50 -0400
Received: by fg-out-1718.google.com with SMTP id d23so1346912fga.1
        for <linux-media@vger.kernel.org>; Sat, 24 Apr 2010 05:57:49 -0700 (PDT)
Message-ID: <4BD2EACA.5040005@googlemail.com>
Date: Sat, 24 Apr 2010 14:57:46 +0200
From: Sven Barth <pascaldragon@googlemail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Problem with cx25840 and Terratec Grabster AV400
Content-Type: multipart/mixed;
 boundary="------------050502090607070406090508"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050502090607070406090508
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hello together!

I'm the owner of a Terratec Grabster AV400, which is supported by the 
pvrusb2 (currently standalone version only). Video works well, but I 
have a problem with audio, when I use an unmodified v4l-dvb: the audio 
is too slow, as if the bitrate is set to low.

The device contains a cx25837-3 (according to dmesg) and audio routing 
has to be set to CX25840_AUDIO_SERIAL.

The problem now is, that this audio route setting is never applied, 
because there are (at least) two locations in cx25840-core.c where a 
check with is_cx2583x is done.
Locally I've simply disabled that checks (see attached patch) and the 
AV400 works as expected now. Of course this can't be the correct 
solution for the official v4l. Also I have to apply that patch after 
every kernel update (which happens rather often with ArchLinux ^^).

Thus I ask how this situation might be solved so that I can use the 
AV400 without patching around in the source of v4l.

Attached:
* dmesg output with unpatched cx25840 module
* my "quick & dirty" patch for cx25840-core.c

Regards,
Sven

--------------050502090607070406090508
Content-Type: text/plain;
 name="dmesg-log.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg-log.txt"

usb 1-5: new high speed USB device using ehci_hcd and address 9
pvrusb2: Hardware description: Terratec Grabster AV400
cx25840 4-0044: cx25837-3 found @ 0x88 (pvrusb2_a)
pvrusb2: Attached sub-driver cx25840
pvrusb2: Supported video standard(s) reported available in hardware: PAL-B/B1/D/D1/G/H/I/K/M/N/Nc/60;NTSC-M/
pvrusb2: Mapping standards mask=0xffffff (PAL-B/B1/D/D1/G/H/I/K/M/N/Nc/60;NTSC-M/Mj/443/Mk;SECAM-B/D/G/H/K/K1/L/LC)
pvrusb2: Setting up 28 unique standard(s)
pvrusb2: Set up standard idx=0 name=PAL-B/G
pvrusb2: Set up standard idx=1 name=PAL-D/K
pvrusb2: Set up standard idx=2 name=SECAM-B/G
pvrusb2: Set up standard idx=3 name=SECAM-D/K
pvrusb2: Set up standard idx=4 name=NTSC-M
pvrusb2: Set up standard idx=5 name=NTSC-Mj
pvrusb2: Set up standard idx=6 name=NTSC-443
pvrusb2: Set up standard idx=7 name=NTSC-Mk
pvrusb2: Set up standard idx=8 name=PAL-B
pvrusb2: Set up standard idx=9 name=PAL-B1
pvrusb2: Set up standard idx=10 name=PAL-G
pvrusb2: Set up standard idx=11 name=PAL-H
pvrusb2: Set up standard idx=12 name=PAL-I
pvrusb2: Set up standard idx=13 name=PAL-D
pvrusb2: Set up standard idx=14 name=PAL-D1
pvrusb2: Set up standard idx=15 name=PAL-K
pvrusb2: Set up standard idx=16 name=PAL-M
pvrusb2: Set up standard idx=17 name=PAL-N
pvrusb2: Set up standard idx=18 name=PAL-Nc
pvrusb2: Set up standard idx=19 name=PAL-60
pvrusb2: Set up standard idx=20 name=SECAM-B
pvrusb2: Set up standard idx=21 name=SECAM-D
pvrusb2: Set up standard idx=22 name=SECAM-G
pvrusb2: Set up standard idx=23 name=SECAM-H
pvrusb2: Set up standard idx=24 name=SECAM-K
pvrusb2: Set up standard idx=25 name=SECAM-K1
pvrusb2: Set up standard idx=26 name=SECAM-L
pvrusb2: Set up standard idx=27 name=SECAM-LC
pvrusb2: Initial video standard auto-selected to PAL-B/G
pvrusb2: Device initialization completed successfully.
usb 1-5: firmware: requesting v4l-cx2341x-enc.fw
pvrusb2: registered device video0 [mpeg]
cx25840 4-0044: 0x0000 is not a valid video input!

--------------050502090607070406090508
Content-Type: text/plain;
 name="cx25840-core.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="cx25840-core.patch"

--- v4l-src/linux/drivers/media/video/cx25840/cx25840-core.c	2010-04-24 10:48:56.392367351 +0200
+++ v4l-build/linux/drivers/media/video/cx25840/cx25840-core.c	2010-04-24 14:54:08.797561848 +0200
@@ -849,10 +849,10 @@
 
 	state->vid_input = vid_input;
 	state->aud_input = aud_input;
-	if (!is_cx2583x(state)) {
+//	if (!is_cx2583x(state)) {
 		cx25840_audio_set_path(client);
 		input_change(client);
-	}
+//	}
 
 	if (is_cx2388x(state)) {
 		/* Audio channel 1 src : Parallel 1 */
@@ -1504,8 +1504,8 @@
 	struct cx25840_state *state = to_state(sd);
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 
-	if (is_cx2583x(state))
-		return -EINVAL;
+/*	if (is_cx2583x(state))
+		return -EINVAL;*/
 	return set_input(client, state->vid_input, input);
 }
 

--------------050502090607070406090508--
