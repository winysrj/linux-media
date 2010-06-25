Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:41152 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755221Ab0FYMP5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Jun 2010 08:15:57 -0400
Received: by ewy20 with SMTP id 20so581029ewy.19
        for <linux-media@vger.kernel.org>; Fri, 25 Jun 2010 05:15:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87r5jw4nmg.fsf@nemi.mork.no>
References: <AANLkTinz5Wvd7XuFIxsMMOV2XUTEXAafRUgXiBMLpEQn@mail.gmail.com>
	<87r5jw4nmg.fsf@nemi.mork.no>
From: Pascal Hahn <derpassi@gmail.com>
Date: Fri, 25 Jun 2010 14:15:35 +0200
Message-ID: <AANLkTinY4jzSBe5mp0MskB-bLNTtc54L29ApgxtGskOK@mail.gmail.com>
Subject: Re: CI-Module not working on Technisat Cablestar HD2
To: =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks for the feedback already. Do you know which kernel version this
driver is functional in out of the top of your head?

I tried multiple kernels and had no luck getting it to work so far.

On Thu, Jun 24, 2010 at 2:32 PM, Bjørn Mork <bjorn@mork.no> wrote:
> Pascal Hahn <derpassi@gmail.com> writes:
>
>> I can't see any of the expected mantis_ca_init but couldn't figure out
>> in the code where that gets called.
>
> I don't think it is.  It was at some point, but it seems to be removed.
> Most likely because it wasn't considered ready at the time this driver
> was merged(?)
>
> BTW, there is a potentional null dereference in mantis_irq_handler(),
> which will do
>
>        ca = mantis->mantis_ca;
> ..
>        if (stat & MANTIS_INT_IRQ0) {
>                dprintk(MANTIS_DEBUG, 0, "<%s>", label[1]);
>                mantis->gpif_status = rst_stat;
>                wake_up(&ca->hif_write_wq);
>                schedule_work(&ca->hif_evm_work);
>        }
>
> This will blow up if (stat & MANTIS_INT_IRQ0) is true, since
> mantis->mantis_ca never is allocated.  But then I guess that the
> hardware should normally prevent (stat & MANTIS_INT_IRQ0) from being
> true as long as the ca system isn't initiated, so this does not pose a
> problem in practice.
>
> Still doesn't look good.
>
>
>
> Bjørn
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
