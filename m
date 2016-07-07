Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f49.google.com ([209.85.215.49]:35248 "EHLO
	mail-lf0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784AbcGGFuW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Jul 2016 01:50:22 -0400
Received: by mail-lf0-f49.google.com with SMTP id l188so4436000lfe.2
        for <linux-media@vger.kernel.org>; Wed, 06 Jul 2016 22:50:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <bbcc63f4-a256-e7a5-ec32-4bd134a161dd@gmail.com>
References: <CAKv9HNaj76n4ccAJc6hGYm+B0acv3oyn1PHobUDCAafD2p9hgQ@mail.gmail.com>
 <bbcc63f4-a256-e7a5-ec32-4bd134a161dd@gmail.com>
From: =?UTF-8?B?QW50dGkgU2VwcMOkbMOk?= <a.seppala@gmail.com>
Date: Thu, 7 Jul 2016 08:50:20 +0300
Message-ID: <CAKv9HNZx-2JFpMxFZr6Ua3OnSVL_ZeYUo7QL6ZgWKeruY9doZg@mail.gmail.com>
Subject: Re: Recent nuvoton-cir changes introduce a hang with nct6775
To: Heiner Kallweit <hkallweit1@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 7 July 2016 at 00:25, Heiner Kallweit <hkallweit1@gmail.com> wrote:
> Am 06.07.2016 um 08:51 schrieb Antti Seppälä:
>> Hello.
>>
>> I recently updated my kernel to a newer version but couldn't boot it
>> because it hangs.
>>
>> It turns out that your patch[1] to nuvoton-cir has really bad
>> side-effects when it interacts with nct6775 module. It could be that
>> one of the devices never frees the request_muxed_region which causes
>> the other module to wait indefinitely.
>>
>> Reverting the patch or preventing nct6775 module from loading makes
>> the issue go away.
>>
>> Other people have run into this issue too[2].
>>
>> This is a regression and should be fixed.
>> Could you look into it and maybe submit a follow-up patch to fix this
>> or shall I perhaps ask for a revert of the troublesome commit?
>>
>>
>> [1]: https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/drivers/media/rc/nuvoton-cir.c?id=3def9ad6d3066e597d0ce86801a81eedb130b04a
>>
>> [2]: https://bbs.archlinux.org/viewtopic.php?id=213647
>>
>>
>> Regards,
>>
> Thanks for reporting. Indeed there may be an issue with systems using
> the alternative EFM IO address of the Nuvoton chip.
> Therefore it doesn't occur on all systems with this chip and then
> only if the nct6775 driver is loaded after the nuvoton-cir driver.
> Could you please check whether the following patch fixes the issue for you?
>
> diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
> index 99b303b..e8ceb0e 100644
> --- a/drivers/media/rc/nuvoton-cir.c
> +++ b/drivers/media/rc/nuvoton-cir.c
> @@ -401,6 +401,7 @@ static int nvt_hw_detect(struct nvt_dev *nvt)
>         /* Check if we're wired for the alternate EFER setup */
>         nvt->chip_major = nvt_cr_read(nvt, CR_CHIP_ID_HI);
>         if (nvt->chip_major == 0xff) {
> +               nvt_efm_disable(nvt);
>                 nvt->cr_efir = CR_EFIR2;
>                 nvt->cr_efdr = CR_EFDR2;
>                 nvt_efm_enable(nvt);
> --
> 2.9.0
>

Yes, I can confirm that with this patch the hang doesn't occur
anymore. Thank you!

Please submit a patch with proper commit message. I think it's best to
Cc it to stable@vger.kernel.org as well.

Best regards,
-- 
Antti
