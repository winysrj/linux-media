Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:52051 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbbBLRfM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Feb 2015 12:35:12 -0500
Received: by mail-lb0-f178.google.com with SMTP id w7so10952404lbi.9
        for <linux-media@vger.kernel.org>; Thu, 12 Feb 2015 09:35:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20150212095029.018f63df@recife.lan>
References: <CAEmZozMOenY096OwgMgdL27hizp8Z26PJ_ZZRsq0DyNpSZam-g@mail.gmail.com>
 <54D9E14A.5090200@iki.fi> <e65f6b905eae37f11e697ad20b97c37c@hardeman.nu>
 <CAEmZozPN2xDQMyao8GAYB1KqKxvgznn6CNc+LgPGhE=TJfDbFQ@mail.gmail.com>
 <32c10d8cd2303ed9476db1b68924170a@hardeman.nu> <CAEmZozP5jrJnWAF6ZbXtvkRveZE29BnSg+hO2x9KDSyPmjBBaQ@mail.gmail.com>
 <20150212095029.018f63df@recife.lan>
From: =?UTF-8?Q?David_Cimb=C5=AFrek?= <david.cimburek@gmail.com>
Date: Thu, 12 Feb 2015 18:34:40 +0100
Message-ID: <CAEmZozOTuigxavH_5M4mw5kDHS_mxgwLS53HipG2o4uvm_09OQ@mail.gmail.com>
Subject: Re: [PATCH] media: Pinnacle 73e infrared control stopped working
 since kernel 3.17
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: =?UTF-8?Q?David_H=C3=A4rdeman?= <david@hardeman.nu>,
	Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2015-02-12 12:50 GMT+01:00 Mauro Carvalho Chehab <mchehab@osg.samsung.com>:
> Em Wed, 11 Feb 2015 17:41:01 +0100
> David Cimbůrek <david.cimburek@gmail.com> escreveu:
>
> Please don't top post. I reordered the messages below in order to get some
> sanity.
>
>>
>> 2015-02-11 15:40 GMT+01:00 David Härdeman <david@hardeman.nu>:
>> > Can you generate some scancodes before and after commit
>> > af3a4a9bbeb00df3e42e77240b4cdac5479812f9?
>>
>> Let me know what exactly do you want me to do (which commands, which
>> traces etc.). I'm not very familiar with the Linux media stuff...
>
> As root, you should run:
>
>         # ir-keytable -r
>
> This will print the scancodes and their key associations.
>
> Also, on what architecture are you testing?
>
> Regards,
> Mauro

Output of the "ir-keytable -r" is available here:
http://pastebin.com/eEDu1Bmn. It is the same before and after the
patch.

Architecture is x86_64.
