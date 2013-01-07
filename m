Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:46034 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754580Ab3AGMe5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Jan 2013 07:34:57 -0500
Received: by mail-wg0-f51.google.com with SMTP id gg4so9398854wgb.6
        for <linux-media@vger.kernel.org>; Mon, 07 Jan 2013 04:34:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1875055.ndRnj5NEuO@avalon>
References: <20130106113455.329ad868@redhat.com> <CA+V-a8tD5AEV4EseDky=sdWXKqsCyASk96wwxF=-ZmNQOUcJaA@mail.gmail.com>
 <1875055.ndRnj5NEuO@avalon>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Mon, 7 Jan 2013 18:04:35 +0530
Message-ID: <CA+V-a8snNjNo2q=BKUrFxJ49iCmDN+TKAtiJr6wqwC6X9w9Wsg@mail.gmail.com>
Subject: Re: Status of the patches under review at LMML (35 patches)
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Murali Karicheri <m-karicheri2@ti.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>, tomi.valkeinen@ti.com,
	LMML <linux-media@vger.kernel.org>,
	Manu Abraham <abraham.manu@gmail.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Prabhakar Lad <prabhakar.lad@ti.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Mon, Jan 7, 2013 at 5:43 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Prabhakar,
>
> On Monday 07 January 2013 11:26:01 Prabhakar Lad wrote:
>> On Sun, Jan 6, 2013 at 7:04 PM, Mauro Carvalho Chehab wrote:
>> > This is the summary of the patches that are currently under review at
>> > Linux Media Mailing List <linux-media@vger.kernel.org>.
>> > Each patch is represented by its submission date, the subject (up to 70
>> > chars) and the patchwork link (if submitted via email).
>>
>> <Snip>
>>
>> >                 == Prabhakar Lad <prabhakar.lad@ti.com> ==
>> >
>> > Aug,24 2012: Corrected Oops on omap_vout when no manager is connected
>> >          http://patchwork.linuxtv.org/patch/14033  Federico Fuga
>> > <fuga@studiofuga.com>
>> Tomi can you take care of this patch ?
>
> Tomi is on parental leave until beginning of February. Beside, he doesn't have
> much experience with the omap_vout driver. We need an Acked-by on this patch
> before he can take it in his tree.
>
Thanks for the info, I did contact Vaibhav  even he is on leave till Jan-20.

Murali can you Ack/Review this patch so that Tomi can pick it up when
hes back from
vacation (this patch doesnt apply on 3.8)

Regards,
--Prabhakar

> --
> Regards,
>
> Laurent Pinchart
>
