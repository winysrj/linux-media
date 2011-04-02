Return-path: <mchehab@pedra>
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:44534 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756402Ab1DBTBW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 2 Apr 2011 15:01:22 -0400
Received: by qwh5 with SMTP id 5so3646261qwh.34
        for <linux-media@vger.kernel.org>; Sat, 02 Apr 2011 12:01:19 -0700 (PDT)
MIME-Version: 1.0
From: Sami Haahtinen <sami@haahtinen.name>
Date: Sat, 2 Apr 2011 21:52:59 +0300
Message-ID: <BANLkTikXBUFjU-BjHv9LO2eTVn31rvdivQ@mail.gmail.com>
Subject: Anysee E30 Combo Plus failing to tune
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hey,
I have a Anysee E30 Combo Plus and i'm having trouble getting it to
detect properly. According to various sources it should be supported,
but yet it fails for me. I've tried with the stock driver and the
backports one (one instructed in wiki) and neither work.

the device is as follows:

-------8<------
Bus 001 Device 007: ID 1c73:861f AMT Anysee E30 USB 2.0 DVB-T Receiver
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  idVendor           0x1c73 AMT
  idProduct          0x861f Anysee E30 USB 2.0 DVB-T Receiver
  bcdDevice            1.00
  iManufacturer           1
  iProduct                2
  iSerial                 0
  bNumConfigurations      1
-------8<------

Manufacturer has packaged it as Anysee E30 Combo Plus, which is listed
as supported. It could be that there have been changes in revision,
the device doesn't list it clearly anywhere and i've yet to take it
apart.

So far i've tried with both DVB-C and DVB-T. Out of the two, DVB-C
doesn't produce any errors, but fails to tune in to any known
frequency, even if the same device is able to tune in under windows.
As for DVB-T, i'm getting a bunch of nasty errors

-------8<------
[  463.200473] zl10353: write to reg 62 failed (err = -110)!
[  465.200492] dvb-usb: bulk message failed: -110 (64/0)
[  465.200509] samsung_dtos403ih102a_set: i2c_transfer failed:-110
[  467.200446] dvb-usb: bulk message failed: -110 (64/0)
[  467.200465] zl10353: write to reg 67 failed (err = -110)!
[  469.200454] dvb-usb: bulk message failed: -110 (64/0)
[  469.200471] zl10353: write to reg 5f failed (err = -110)!
[  471.200452] dvb-usb: bulk message failed: -110 (64/0)
[  471.200470] zl10353: write to reg 70 failed (err = -110)!
[  473.200452] dvb-usb: bulk message failed: -110 (64/0)
[  473.200469] dvb-usb: error -110 while querying for an remote control event.
-------8<------

these are the starting points, what info do you need to debug this? I
can also provide access to a host with this device installed if
required.

Regards,
--
Sami Haahtinen
Bad Wolf Oy
+358443302775
