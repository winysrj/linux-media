Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:35209 "EHLO
	mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932105AbcAYMDO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jan 2016 07:03:14 -0500
Received: by mail-wm0-f47.google.com with SMTP id r129so61080737wmr.0
        for <linux-media@vger.kernel.org>; Mon, 25 Jan 2016 04:03:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <m31t96j8u4.fsf@t19.piap.pl>
References: <1451183213-2733-1-git-send-email-ezequiel@vanguardiasur.com.ar>
	<569CE27F.6090702@xs4all.nl>
	<CAAEAJfCs1fipSadLj8WyxiJd9g7MCJj1KX5UdAPx1hPt16t0VA@mail.gmail.com>
	<m31t96j8u4.fsf@t19.piap.pl>
Date: Mon, 25 Jan 2016 09:03:12 -0300
Message-ID: <CAAEAJfBM_vVBVRd3P0kJ1QLzk-M==L=x6CS0ggXgRX=7K_aK_A@mail.gmail.com>
Subject: Re: [PATCH] media: Support Intersil/Techwell TW686x-based video
 capture cards
From: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
To: =?UTF-8?Q?Krzysztof_Ha=C5=82asa?= <khalasa@piap.pl>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 25 January 2016 at 06:40, Krzysztof Hałasa <khalasa@piap.pl> wrote:
> Ezequiel Garcia <ezequiel@vanguardiasur.com.ar> writes:
>
>> A previous version of the driver didn't have that. However, under certain
>> stress testing it was observed that the PCIe link goes down. I still have the
>> traces for that:
>>
>> [..]
>> [21833.389031] pciehp 0000:13:01.0:pcie24: pcie_isr: intr_loc 100
>> [21833.389035] pciehp 0000:13:01.0:pcie24: Data Link Layer State change
>> [21833.389038] pciehp 0000:13:01.0:pcie24: slot(1-5): Link Down event
>> [21833.389076] pciehp 0000:13:01.0:pcie24: Disabling
>> domain:bus:device=0000:14:00
>> [21833.389078] pciehp 0000:13:01.0:pcie24: pciehp_unconfigure_device:
>> domain:bus:dev = 0000:14:00
>> [21833.389103] TW686x 0000:14:00.0: removing
>> [21833.416557] TW686x 0000:14:00.0: removed
>> [..]
>>
>> I have no idea why the link goes down (hardware issue?),
>> but it's better to handle it gracefully :)
>
> Could be hw issue indeed, FWIW I have never observed this problem on my
> hw (which is ARM-based and includes TW6869).
>
>> I understand that on some platforms this implementation could be too
>> costly (it's
>> completely cheap on any modern x86), and I intend to provide some option
>> to provide "frame DMA-to-buffer" and "scatter-gather DMA".
>
> Though I'm using the driver that I posted several months ago, with
> SG DMA field-only mode (SG DMA engine doesn't support frame mode and
> while non-SG DMA (field or frame) mode is certainly possible with CMA,
> copying the buffers is out of the question here).
>
> I wonder if that driver works for you (which would suggest a sw bug)
> or if the problems are the same (hw issue - system, power, or the chip
> itself).
>

No, it didn't. Using SG mode suffers from the same issues here.

>
> BTW adding incremental patches on top of the driver I posted would seem
> preferable to me. It would enable us to pinpoint (and not include)
> changes which tend to break something. For now, it seems I'll be stuck
> with my version, since I have to do DMA to buffers (though I could use
> the frame mode).
>
> Incremental patches are generally how it is done in Linux.
> Perhaps we should merge my driver first and you'd add your changes on
> top of it (preserving the existing functionality)?
>
> This is very easy with git.

Well, I plan to add SG mode as soon as this driver is merged, so hopefully you
won't have to use an out of tree driver anymore.
-- 
Ezequiel García, VanguardiaSur
www.vanguardiasur.com.ar
