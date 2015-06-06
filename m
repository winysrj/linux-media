Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp53.i.mail.ru ([94.100.177.113]:55840 "EHLO smtp53.i.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752843AbbFFUCi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Jun 2015 16:02:38 -0400
Message-ID: <CFB6F14A3740441FB49C6FF2FC3CAD56@unknown>
From: "Unembossed Name" <severe.siberian.man@mail.ru>
To: <linux-media@vger.kernel.org>, "Antti Palosaari" <crope@iki.fi>
References: <0448C37B97FE43E6A8CD61968C10E73F@unknown> <55733133.6050502@iki.fi>
Subject: Re: Si2168 B40 frimware.
Date: Sun, 7 Jun 2015 03:02:25 +0700
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="utf-8";
	reply-type=response
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "Antti Palosaari"
To: "Unembossed Name"
Sent: Sunday, June 07, 2015 12:43 AM
Subject: Re: Si2168 B40 frimware.


>> Anybody want to test it? Unfortunately, I can not do it myself, because
>> I do not own hardware with B40 revision.
> 
> That does not even download. It looks like 17 byte chunk format, but it 
> does not divide by 17. Probably there is some bytes missing or too many 
> at the end of file.
> 
> That is how first 16 bytes of those firmwares looks:
> 4.0.4:  05 00 aa 4d 56 40 00 00  0c 6a 7e aa ef 51 da 89
> 4.0.11: 08 05 00 8d fc 56 40 00  00 00 00 00 00 00 00 00
> 4.0.19: 08 05 00 f0 9a 56 40 00  00 00 00 00 00 00 00 00
> 
> 4.0.4 is 8 byte chunks, 4.0.11 is 17 byte.

Hi Antti,

You're right. I've made a mistake with determining of the end of a patch. It seems I  blindly used an obsolete information about 
size it should be. And because of that, these version of a patch can be even more recent. Like 4.0.20.

Could you please check it again? And in case of success see which version it is?

file name:dvb-demod-si2168-b40-rom4_0_2-patch-build-probably4_0_19.fw.tar.gz
http://beholder.ru/bb/download/file.php?id=857 

Best regards.
