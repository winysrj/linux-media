Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:33305 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771Ab1JBNIh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Oct 2011 09:08:37 -0400
Received: by yxl31 with SMTP id 31so2737610yxl.19
        for <linux-media@vger.kernel.org>; Sun, 02 Oct 2011 06:08:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+2YH7vZvdt=nv4XWeA_4Hefy_us6nB0AxQbM9Ra68UcPz0a3A@mail.gmail.com>
References: <1317429231-11359-1-git-send-email-martinez.javier@gmail.com>
 <4E8716D1.9010104@mlbassoc.com> <CAAwP0s07U3wHR0LoSmvQzXG3KxUoARgjH7G2gxi911RBVe9HRw@mail.gmail.com>
 <CA+2YH7u=PzkTFUwWgJHuuHphrz8O7UZvOKDWfFoxGcouzzGo7Q@mail.gmail.com>
 <CAAwP0s3fXYcgKtEKT0h1H92kOZFyOd5s0zYv1wB6wiZEt+d5AA@mail.gmail.com> <CA+2YH7vZvdt=nv4XWeA_4Hefy_us6nB0AxQbM9Ra68UcPz0a3A@mail.gmail.com>
From: Javier Martinez Canillas <martinez.javier@gmail.com>
Date: Sun, 2 Oct 2011 15:08:17 +0200
Message-ID: <CAAwP0s2BGL4_iZ=eimpAZZUa_saa4uEd0BSMbrDJ8pPC3ZZZWg@mail.gmail.com>
Subject: Re: [PATCH 0/3] [media] tvp5150: Migrate to media-controller
 framework and add video format detection
To: Enrico <ebutera@users.berlios.de>
Cc: Gary Thomas <gary@mlbassoc.com>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Oct 1, 2011 at 7:46 PM, Enrico <ebutera@users.berlios.de> wrote:
> On Sat, Oct 1, 2011 at 7:27 PM, Javier Martinez Canillas
> <martinez.javier@gmail.com> wrote:
>> Yes, I saw it. That is why I didn't post our modifications to the ISP
>> CCDC driver. Our approach is very similar to the one followed by TI
>> (changing the CCDC output buffer every two VD0 interrupts) but we did
>> different a few things:
>>
>> - decouple next buffer obtaining from last buffer releasing
>> - maintain two buffers (struct isp_buffer), current and last
>> - move move most of the logic to the VD1 interrupt since the ISP is
>> already busy while execution VD0 handler.
>
> If you think it is a better approach you can submit it for review,
> right now there is no "clean" version supporting bt656 so yours can be
> the one.
>
>

Ok, I don't know if my approach is the "cleaner" version to support
bt656, but I will cleanup the code to be in a merge-able state and
send for review.

Something that I don't know if I got it right is configure the CCDC to
capture and odd numbers of lines (i.e: 625 lines from a PAL frame)
since the first and second sub-frames have different numbers of lines
(i.e: 313 and 312).

My solution was to reprogram the CCDC in the VD1 interrupt handler so
it can use the new configuration for the next sub-frame:

static void ispccdc_change_numlines(struct isp_device *isp, int numlines)
{
	isp_reg_writel(isp, ((numlines - 1) << ISPCCDC_VDINT_0_SHIFT) |
		       ((numlines * 2 / 3) << ISPCCDC_VDINT_1_SHIFT),
		       OMAP3_ISP_IOMEM_CCDC, ISPCCDC_VDINT);
	isp_reg_writel(isp, (numlines - 1)
		       << ISPCCDC_VERT_LINES_NLV_SHIFT,
		       OMAP3_ISP_IOMEM_CCDC, ISPCCDC_VERT_LINES);
}

Is this the right approach? because I didn't find in the TRM how to
configure the CCDC to generate the VD0 and VD1 interrupts with
variable frame vertical length.

>>>>> Even if it does detect the signal shape (NTSC, PAL), doesn't one still need
>>>>> to [externally] configure the pads for this shape?
>>>>>
>>>>
>>>> Yes, that is why I wanted to do the auto-detection for the tvp5151, so
>>>> we only have to manually configure the ISP components (or any other
>>>> hardware video processing pipeline entities, sorry for my
>>>> OMAP-specific comments).
>>>
>>> Laurent was not very happy [3] about changing video formats out of the
>>> driver control, so this should be discussed more.
>>>
>>> [3]: http://www.spinics.net/lists/linux-omap/msg56983.html
>>>
>>>
>>
>> Ok, I thought it was the right thing to do, my bad. Lets do it from
>> user-space then using the MCF.
>
> I see there is some ongoing discussion about a similar topic, so just
> follow it and see how it turns out.
>
> Enrico
>

Ok, I will. Thank you very much for your comments.

Best regards,

-- 
Javier Martínez Canillas
(+34) 682 39 81 69
Barcelona, Spain
