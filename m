Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:37240 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755871Ab2IFPNo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Sep 2012 11:13:44 -0400
Received: by bkwj10 with SMTP id j10so890083bkw.19
        for <linux-media@vger.kernel.org>; Thu, 06 Sep 2012 08:13:43 -0700 (PDT)
Message-ID: <5048BDA2.7090203@googlemail.com>
Date: Thu, 06 Sep 2012 17:13:38 +0200
From: =?ISO-8859-15?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: hdegoede@redhat.com
Subject: pac7302-webcams and libv4lconvert interaction
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi,

I'm currently looking into the gspca_pac7302-driver and how it interacts
with libv4lconvert.
This is how it currently works
- driver announces v4l2_pix_format 640x480 (width x height)
- the frames (jpeg) passed to userspace are encoded as 480x640 and this
complies with the jpeg-header we generate
- libv4lconvert checks width/height in the jpeg-header and compares them
with the image format announced by the kernel:
   a) values are the same:
      1) V4LCONTROL_ROTATED_90_JPEG is NOT set for the device (standard
case):
          => everything is fine, image is decoded
      2) V4LCONTROL_ROTATED_90_JPEG is set for the device:
          => libv4lconvert bails out with -EIO displaying the error
message "unexpected width / height in JPEG header: expected: 640x480,
header: 480x640"
   b) values are different:
      1) V4LCONTROL_ROTATED_90_JPEG is NOT set:
          => libv4lconvert bails out with -EIO displaying the error
message "unexpected width / height in JPEG header: expected: 640x480,
header: 480x640"
      2) V4LCONTROL_ROTATED_90_JPEG is set:
          => image is decoded and rotated correctly


Thinking about this for some minutes:

1) shouldn't the kernel always announce the real image format (size) of
the data it passes to userspace ?
Current behavior seems inconsistent to me...
Announcing the actual image size allows applications which trust the API
value more than the value in the frame header to decode the image
correctly without using libv4lconvert (although the image would still be
rotated).

2) shouldn't libv4lconvert always rotate the image if
V4LCONTROL_ROTATED_90_JPEG is set for a device ?
It seems like a2) is a bug, because the expected size should be 640x480,
too.

3) because all pac7302 devices are sending rotated image data, we should
add them ALL to libv4lconvert. Currently only 4 of the 14 devices are on
the list.
Do you want me to send a patch ?


What do you think ?

Regards,
Frank

