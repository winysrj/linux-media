Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp43.i.mail.ru ([94.100.177.103]:45199 "EHLO smtp43.i.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751488AbbFFU5u (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Jun 2015 16:57:50 -0400
Message-ID: <D91B54BF334446CEAB709731EE051752@unknown>
From: "Unembossed Name" <severe.siberian.man@mail.ru>
To: <linux-media@vger.kernel.org>, "Antti Palosaari" <crope@iki.fi>
References: <0448C37B97FE43E6A8CD61968C10E73F@unknown> <55733133.6050502@iki.fi> <CFB6F14A3740441FB49C6FF2FC3CAD56@unknown> <557354A2.7060900@iki.fi>
Subject: Re: Si2168 B40 frimware.
Date: Sun, 7 Jun 2015 03:57:38 +0700
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="utf-8";
	reply-type=response
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "Antti Palosaari"
To: "Unembossed Name" <severe.siberian.man@mail.ru>; <linux-media@vger.kernel.org>
Sent: Sunday, June 07, 2015 3:14 AM
Subject: Re: Si2168 B40 frimware.

>> Could you please check it again? And in case of success see which
>> version it is?
>>
>> file name:dvb-demod-si2168-b40-rom4_0_2-patch-build-probably4_0_19.fw.tar.gz
>> http://beholder.ru/bb/download/file.php?id=857
>> Best regards.
> 
> That one works, DVB-T/T2 scan tested.
> 
> si2168 6-0064: found a 'Silicon Labs Si2168-B40'
> si2168 6-0064: downloading firmware from file 'dvb-demod-si2168-b40-01.fw'
> si2168 6-0064: firmware version: 4.0.19
> si2157 7-0060: found a 'Silicon Labs Si2157-A30'
> si2157 7-0060: firmware version: 3.0.5

Hi Antti,

Great! Thank you.
Instructions, on how to extract 4.0.19 for Si2168 B40 demod:
First, you have to download zipped file from http://beholder.ru/files/drv_v5510.zip
Unpack beholder.bin from it, and then use that command to extract firmware patch:
dd if=beholder.bin  bs=1 skip=69520 count=13651 of=dvb-demod-si2168-b40-rom4_0_2-patch-build4_0_19.fw

Best regards.
