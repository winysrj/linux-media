Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:34735 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755769AbcGFV1L (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jul 2016 17:27:11 -0400
Received: by mail-wm0-f68.google.com with SMTP id 187so1436323wmz.1
        for <linux-media@vger.kernel.org>; Wed, 06 Jul 2016 14:27:10 -0700 (PDT)
Subject: Re: Recent nuvoton-cir changes introduce a hang with nct6775
To: =?UTF-8?B?QW50dGkgU2VwcMOkbMOk?= <a.seppala@gmail.com>
References: <CAKv9HNaj76n4ccAJc6hGYm+B0acv3oyn1PHobUDCAafD2p9hgQ@mail.gmail.com>
Cc: linux-media@vger.kernel.org
From: Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <bbcc63f4-a256-e7a5-ec32-4bd134a161dd@gmail.com>
Date: Wed, 6 Jul 2016 23:25:59 +0200
MIME-Version: 1.0
In-Reply-To: <CAKv9HNaj76n4ccAJc6hGYm+B0acv3oyn1PHobUDCAafD2p9hgQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 06.07.2016 um 08:51 schrieb Antti Seppälä:
> Hello.
> 
> I recently updated my kernel to a newer version but couldn't boot it
> because it hangs.
> 
> It turns out that your patch[1] to nuvoton-cir has really bad
> side-effects when it interacts with nct6775 module. It could be that
> one of the devices never frees the request_muxed_region which causes
> the other module to wait indefinitely.
> 
> Reverting the patch or preventing nct6775 module from loading makes
> the issue go away.
> 
> Other people have run into this issue too[2].
> 
> This is a regression and should be fixed.
> Could you look into it and maybe submit a follow-up patch to fix this
> or shall I perhaps ask for a revert of the troublesome commit?
> 
> 
> [1]: https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/drivers/media/rc/nuvoton-cir.c?id=3def9ad6d3066e597d0ce86801a81eedb130b04a
> 
> [2]: https://bbs.archlinux.org/viewtopic.php?id=213647
> 
> 
> Regards,
> 
Thanks for reporting. Indeed there may be an issue with systems using
the alternative EFM IO address of the Nuvoton chip.
Therefore it doesn't occur on all systems with this chip and then
only if the nct6775 driver is loaded after the nuvoton-cir driver.
Could you please check whether the following patch fixes the issue for you?

diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index 99b303b..e8ceb0e 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -401,6 +401,7 @@ static int nvt_hw_detect(struct nvt_dev *nvt)
        /* Check if we're wired for the alternate EFER setup */
        nvt->chip_major = nvt_cr_read(nvt, CR_CHIP_ID_HI);
        if (nvt->chip_major == 0xff) {
+               nvt_efm_disable(nvt);
                nvt->cr_efir = CR_EFIR2;
                nvt->cr_efdr = CR_EFDR2;
                nvt_efm_enable(nvt);
--
2.9.0

Regards, Heiner

