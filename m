Return-path: <linux-media-owner@vger.kernel.org>
Received: from fep28.mx.upcmail.net ([62.179.121.48]:38247 "EHLO
	fep28.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294AbbFGTAv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Jun 2015 15:00:51 -0400
Received: from edge01.upcmail.net ([192.168.13.236])
          by viefep28-int.chello.at
          (InterMail vM.8.01.05.21 201-2260-151-156-20141103) with ESMTP
          id <20150607190048.SPOM9154.viefep28-int.chello.at@edge01.upcmail.net>
          for <linux-media@vger.kernel.org>; Sun, 7 Jun 2015 21:00:48 +0200
Message-ID: <557494E1.3060403@chello.at>
Date: Sun, 07 Jun 2015 21:00:49 +0200
From: Hurda <hurda@chello.at>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: Si2168 B40 frimware.
References: <0448C37B97FE43E6A8CD61968C10E73F@unknown> <55733133.6050502@iki.fi> <CFB6F14A3740441FB49C6FF2FC3CAD56@unknown> <557354A2.7060900@iki.fi> <D91B54BF334446CEAB709731EE051752@unknown>
In-Reply-To: <D91B54BF334446CEAB709731EE051752@unknown>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

What's new with that firmware?
It's twice as big as 4.0.11, so there got to be a lot of changes and fixes.

I assume the info originates from 
http://beholder.ru/bb/viewtopic.php?f=11&t=14101 , but I don't understand 
Russian at all.

Am 06.06.2015 22:58, schrieb linux-media-owner@vger.kernel.org:
> From: "Antti Palosaari"
> To: "Unembossed Name" <severe.siberian.man@mail.ru>; 
> <linux-media@vger.kernel.org>
> Sent: Sunday, June 07, 2015 3:14 AM
> Subject: Re: Si2168 B40 frimware.
>
>>> Could you please check it again? And in case of success see which
>>> version it is?
>>>
>>> file name:dvb-demod-si2168-b40-rom4_0_2-patch-build-probably4_0_19.fw.tar.gz
>>> http://beholder.ru/bb/download/file.php?id=857
>>> Best regards.
>>
>> That one works, DVB-T/T2 scan tested.
>>
>> si2168 6-0064: found a 'Silicon Labs Si2168-B40'
>> si2168 6-0064: downloading firmware from file 'dvb-demod-si2168-b40-01.fw'
>> si2168 6-0064: firmware version: 4.0.19
>> si2157 7-0060: found a 'Silicon Labs Si2157-A30'
>> si2157 7-0060: firmware version: 3.0.5
>
> Hi Antti,
>
> Great! Thank you.
> Instructions, on how to extract 4.0.19 for Si2168 B40 demod:
> First, you have to download zipped file from 
> http://beholder.ru/files/drv_v5510.zip
> Unpack beholder.bin from it, and then use that command to extract firmware patch:
> dd if=beholder.bin  bs=1 skip=69520 count=13651 
> of=dvb-demod-si2168-b40-rom4_0_2-patch-build4_0_19.fw
>
> Best regards.
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

