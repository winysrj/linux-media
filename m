Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f174.google.com ([209.85.218.174]:57747 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279AbZEVQuY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 May 2009 12:50:24 -0400
Received: by bwz22 with SMTP id 22so1744042bwz.37
        for <linux-media@vger.kernel.org>; Fri, 22 May 2009 09:50:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A164E9F.1070302@bsc-bvba.be>
References: <965444.24352.qm@web26902.mail.ukl.yahoo.com>
	 <20090515231650.56d6c4f4@bk.ru> <4A164E9F.1070302@bsc-bvba.be>
Date: Fri, 22 May 2009 18:50:23 +0200
Message-ID: <18d12a680905220950w5ac161f4gd2c716b84bc71cf5@mail.gmail.com>
Subject: Re: [linux-dvb] Hauppauge WinTV-CI
From: =?UTF-8?Q?BRUNETON_B=C3=A9ranger?= <bruneton@gmail.com>
To: linux-media@vger.kernel.org, dvb3@bsc-bvba.be
Cc: linux-dvb@linuxtv.org, tarik.chougua@yahoo.fr
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> I have been struggling for ages with this device, trying get the firmware to load.
>
> The program I wrote to extract the firmware from the driver now outputs the Intel Hex format too, used by fxload.
> No luck : the A3 part does not get loaded, not even using fxloads' A3-loader
>
> Details and downloads of code, logs etc at http://www.bsc-bvba.be/linux/dvb
>
> I could use some help, like :
>> > traces of the firmware being loaded on XP/Vista (I am using USBspy myself), preferably using a hardware protocol analyser
>> > recommendations for an affordable hardware USB2 protocol analyser (I'd try to compare the XP-log with the non-working Linux log)
>> > suggestions on how to proceed ...


Do you know why it doesn't support S2 channels ?
Hardware or software limitation ?


Regards
