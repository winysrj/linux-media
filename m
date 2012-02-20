Return-path: <linux-media-owner@vger.kernel.org>
Received: from 7of9.schinagl.nl ([88.159.158.68]:60785 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753016Ab2BTTaV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Feb 2012 14:30:21 -0500
Received: from [10.2.0.137] (unknown [10.2.0.137])
	by 7of9.schinagl.nl (Postfix) with ESMTPA id C244622D54
	for <linux-media@vger.kernel.org>; Mon, 20 Feb 2012 20:27:40 +0100 (CET)
Message-ID: <4F429DF1.3010500@schinagl.nl>
Date: Mon, 20 Feb 2012 20:24:33 +0100
From: Oliver Schinagl <oliver@schinagl.nl>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: USB ID for Asus U3100MINI Plus DVB-T tuner
Content-Type: multipart/mixed;
 boundary="------------060906070904040102080006"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060906070904040102080006
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

i'm partial writer of 
http://www.linuxtv.org/wiki/index.php/Asus_U3100_Mini_plus_DVB-T and 
host the mentioned git repository.

I have noticed that the Asus U3100Mini plus dvb-t tuner still does not 
have it's USB ID added to usb-ids.h and thus supply this patch.

The DVB-T tuner uses the "Afa Technologies Inc. AF9035A USB Device" and 
has an USB ID of 0b05:1779.

Btw, my /usr/share/misc/usb.ids does list this device properly.

Bus 002 Device 002: ID 0b05:1779 ASUSTek Computer, Inc. My Cinema U3100 
Mini Plus [AF9035A]


Also, what is afa's current status in supporting (or not) the af903a and 
what specifications are required to piggy back the driver possibly ontop 
of the previous afa drivers?


I know afa is 'working on it' as quited from the wiki:
"

For its part, Afatech does not want any of the above driver attempts to 
make their way into the kernel, as none of them are very robust in terms 
of chip support.

Instead, AFA has embarked upon the development of yet another OSS 
driver, which will be generic in that it will be capable of supporting 
the entire AF901x family as well as all possible device configurations 
permitted. In addition to the expectation that it will be this driver 
that is eventually adopted into the kernel, AFA have also signaled that 
they intend provide continuous support (i.e. they will stay on as the 
driver's maintainer).

Currently, this newest driver has reached a second round of testing in 
AFA labs, but that has only been in conjunction (with some peripheral 
manufacturers) with a few devices, and, as it stands, the code is still 
not particularly generic (due to both the complexities of the chip 
itself as well as those involved in getting the various device 
configurations to work). So, as of yet, there currently isn't anything 
for the end user to test. However, as soon things progress past this 
stage, there will be something released for users to test. There is no 
specific release timeframe set for this, but hopefully it will be soon, 
as the chip manufacturer (as well as everybody else involved) is under 
pressure, due to the large adoption of the chip by different peripheral 
manufacturers (Avermedia, Terratec, Azurewave, DigitalNow, Pinnacle, as 
well as some number of unbranded Chinese manufacturers too). In short, a 
lot more devices based on this chipset are expected to materialize."

Oliver


--------------060906070904040102080006
Content-Type: text/x-patch;
 name="asus_dvb-usb-ids.h.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="asus_dvb-usb-ids.h.diff"

--- v4l/dvb-usb-ids.h	2011-10-24 09:10:05.000000000 +0200
+++ v4l/dvb-usb-ids.h_asus	2012-02-20 20:06:57.980979949 +0100
@@ -294,6 +294,7 @@
 #define USB_PID_ASUS_U3000				0x171f
 #define USB_PID_ASUS_U3000H				0x1736
 #define USB_PID_ASUS_U3100				0x173f
+#define USB_PID_ASUS_U3100MINI_PLUS			0x1779
 #define USB_PID_YUAN_EC372S				0x1edc
 #define USB_PID_YUAN_STK7700PH				0x1f08
 #define USB_PID_YUAN_PD378S				0x2edc

--------------060906070904040102080006--
