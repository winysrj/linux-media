Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f180.google.com ([209.85.214.180]:53917 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372AbaJTItz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Oct 2014 04:49:55 -0400
Received: by mail-ob0-f180.google.com with SMTP id va2so3410577obc.39
        for <linux-media@vger.kernel.org>; Mon, 20 Oct 2014 01:49:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1406723567.9111.4.camel@paszta.hi.pengutronix.de>
References: <1405071403-1859-1-git-send-email-p.zabel@pengutronix.de>
 <1405071403-1859-7-git-send-email-p.zabel@pengutronix.de> <20140721160128.27eb7428.m.chehab@samsung.com>
 <20140721191944.GK13730@pengutronix.de> <1406033433.4496.16.camel@paszta.hi.pengutronix.de>
 <20140729153050.GE6827@dragon> <CA+gwMccgFGxpDZFqZR=pEgnnc1z5rit4T+LsVKvp1KrWw7_aJA@mail.gmail.com>
 <20140730121628.GA22243@dragon> <1406723567.9111.4.camel@paszta.hi.pengutronix.de>
From: Jean-Michel Hautbois <jhautbois@gmail.com>
Date: Mon, 20 Oct 2014 10:49:39 +0200
Message-ID: <CAL8zT=jOL1eJo0qTHDOkJeeVUOQqFef00N+mcnCoRwBNuszR1A@mail.gmail.com>
Subject: Re: [PATCH v3 06/32] [media] coda: Add encoder/decoder support for CODA960
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Shawn Guo <shawn.guo@linaro.org>,
	Philipp Zabel <philipp.zabel@gmail.com>,
	Robert Schwebel <r.schwebel@pengutronix.de>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Kamil Debski <k.debski@samsung.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Sascha Hauer <kernel@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

2014-07-30 14:32 GMT+02:00 Philipp Zabel <p.zabel@pengutronix.de>:
> Am Mittwoch, den 30.07.2014, 20:16 +0800 schrieb Shawn Guo:
>> On Tue, Jul 29, 2014 at 07:06:25PM +0200, Philipp Zabel wrote:
>> > > I followed the step to generate the firmware v4l-coda960-imx6q, and
>> > > tested it on next-20140725 with patch 'ARM: dts: imx6qdl: Enable CODA960
>> > > VPU' applied on top of it.  But I got the error of 'Wrong firmwarel' as
>> > > below.
>> > >
>> > > [    2.582837] coda 2040000.vpu: requesting firmware 'v4l-coda960-imx6q.bin' for CODA960
>> > > [    2.593344] coda 2040000.vpu: Firmware code revision: 0
>> > > [    2.598649] coda 2040000.vpu: Wrong firmware. Hw: CODA960, Fw: (0x0000), Version: 0.0.0
>> >
>> > I just tried with the same kernel, and the above download, converted
>> > with the program in the referenced mail, and I get this:
>> >
>> >     coda 2040000.vpu: Firmware code revision: 36350
>> >     coda 2040000.vpu: Initialized CODA960.
>> >     coda 2040000.vpu: Unsupported firmware version: 2.1.9
>> >     coda 2040000.vpu: codec registered as /dev/video0
>>
>> Okay, the reason I'm running into the issue is that I'm using the FSL
>> U-Boot which turns off VDDPU at initialization.
>
> In that case you need to also apply the "Generic Device Tree based power
> domain look-up" and "i.MX6 PU power domain support series". I'll have to
> check the current state of that.

I am having the same issue with firmware 3.1.1 and can't find version 2.1.5.
Is there a way to make it work ? Does anybody has news from Freescale
and official support for firmwares in mainline ?
This is (as Robert Schwebel said) unusable with a recent kernel, and
that's a shame...

Thx,
JM
