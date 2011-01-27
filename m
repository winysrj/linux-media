Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54156 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501Ab1A0PUh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Jan 2011 10:20:37 -0500
Received: by bwz15 with SMTP id 15so2315244bwz.19
        for <linux-media@vger.kernel.org>; Thu, 27 Jan 2011 07:20:19 -0800 (PST)
From: Richard Riley <rileyrg@googlemail.com>
To: "linux-media\@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Avermedia Volar Green HD idVendor=07ca, idProduct=a835
Date: Thu, 27 Jan 2011 16:19:57 +0100
Message-ID: <shbp325q76.fsf@news.eternal-september.org>
MIME-Version: 1.0
Content-Type: text/plain
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


Hi folks,

My first post to the list : I have done a fair bit of googling around
but thought I would ask here. Here in germany a popular dvb usb stick is
the Avermedia Volar Green HD  - the major Electronics chain Saturn are
shifting these quite cheaply.

Here is the output of dmesg when I plug it in

[ 3070.995100] usb 1-1: new high speed USB device using ehci_hcd and address 4
[ 3071.114806] usb 1-1: New USB device found, idVendor=07ca, idProduct=a835
[ 3071.114822] usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[ 3071.114833] usb 1-1: Product: A835
[ 3071.114840] usb 1-1: Manufacturer: AVerMedia TECHNOLOGIES, Inc
[ 3071.114849] usb 1-1: SerialNumber: 3031271017470

Is this/will this be supported?

It is discussed here https://bbs.archlinux.org/viewtopic.php?id=111487 ,
but neither patch compiles on my debian squeeze system.

As an aside, I tried to build the sources as described at the LinuxTV web page but it
fails with:-

,----
|   CC [M]  /home/shamrock/builds/src/media_build/v4l/pvrusb2-debugifc.o
| /home/shamrock/builds/src/media_build/v4l/pvrusb2-debugifc.c: In function 'debugifc_parse_unsigned_number':
| /home/shamrock/builds/src/media_build/v4l/pvrusb2-debugifc.c:108: error: implicit declaration of function 'hex_to_bin'
| make[5]: *** [/home/shamrock/builds/src/media_build/v4l/pvrusb2-debugifc.o] Error 1
| make[4]: *** [_module_/home/shamrock/builds/src/media_build/v4l] Error 2
| make[3]: *** [sub-make] Error 2
| make[2]: *** [all] Error 2
| make[2]: Leaving directory `/usr/src/linux-headers-2.6.32-5-686'
| make[1]: *** [default] Fehler 2
| make[1]: Leaving directory `/home/shamrock/builds/src/media_build/v4l'
`----

Thanks for any info

regards

r.



