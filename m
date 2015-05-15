Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:38596 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932529AbbEOPSK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 May 2015 11:18:10 -0400
Received: by wicnf17 with SMTP id nf17so141068894wic.1
        for <linux-media@vger.kernel.org>; Fri, 15 May 2015 08:18:09 -0700 (PDT)
Message-ID: <55560E2F.40502@gmail.com>
Date: Fri, 15 May 2015 16:18:07 +0100
From: Jemma Denson <jdenson@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Patrick Boettcher <patrick.boettcher@posteo.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PULL] For 4.2 (or even 4.1?) add support for cx24120/Technisat
 SkyStar S2
References: <20150420092720.3cb092ba@dibcom294.coe.adi.dibcom.com>	<20150427171628.5ba22752@recife.lan>	<20150427232523.08c1c8f1@lappi3.parrot.biz>	<20150427214022.1ff9f61f@recife.lan>	<20150429133501.38eacfa0@dibcom294.coe.adi.dibcom.com>	<20150429085526.655677d8@recife.lan>	<20150514184040.094c8a95@recife.lan>	<20150515102433.15ec0b3d@dibcom294.coe.adi.dibcom.com> <20150515112449.4f460aab@recife.lan>
In-Reply-To: <20150515112449.4f460aab@recife.lan>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On 15/05/15 15:24, Mauro Carvalho Chehab wrote:
>> Of course. Jemma and me (mainly Jemma) are progressing and might be
>> able to resubmit everything this weekend.
> Good! Thanks for the good work!
>
> Mauro


The only thing left now is moving UCB & BER over to DVBv5 stats - we 
haven't got anything close to any specs for this demod so I'm struggling 
to work out how to handle the counter increment.
It's not helped by my signal not being marginal enough to see any errors 
anyway!

What's the best course of action here - either leave those two out 
entirely or fudge something to get the numbers to about the right 
magnitude and worry about making it more accurate at a later date?


Jemma.

