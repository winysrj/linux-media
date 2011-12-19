Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:57548 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528Ab1LSMLz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Dec 2011 07:11:55 -0500
Received: by werm1 with SMTP id m1so1219178wer.19
        for <linux-media@vger.kernel.org>; Mon, 19 Dec 2011 04:11:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1112191301070.23694@axis700.grange>
References: <1324022443-5967-1-git-send-email-javier.martin@vista-silicon.com>
	<CACKLOr1=vFs8xDaDMSX146Y1h18q=+fPEBGHekgNq2xRVCOGsA@mail.gmail.com>
	<Pine.LNX.4.64.1112191237300.23694@axis700.grange>
	<201112191252.24101.laurent.pinchart@ideasonboard.com>
	<Pine.LNX.4.64.1112191301070.23694@axis700.grange>
Date: Mon, 19 Dec 2011 13:11:53 +0100
Message-ID: <CACKLOr0eCVfq+EFTgHQzNT=TuotOeDoMKN-CouJV+2CG7_pT3w@mail.gmail.com>
Subject: Re: [PATCH] V4L: soc-camera: provide support for S_INPUT.
From: javier Martin <javier.martin@vista-silicon.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	saaguirre@ti.com, Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> I agree that input enumeration is needed, but I really think this should be
>> handled through pads, no with a new subdev operation. I don't like the idea of
>> introducing a new operation that will already be deprecated from the very
>> beginning.
>>
>> Implementing this through pads isn't difficult. You don't need to implement
>> any pad operation in the tvp5150 driver. All you need to do is setup an array
>> of pads at probe time with information provided through platform data. soc-
>> camera should then just access the pads array and implement enum_input
>> internally.
>
> Ok, this might indeed be simple enough. Javier, could you give it a try?

All right,
as soon as I have some time I'll go for that approach.

Regards.
-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
