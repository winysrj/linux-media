Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11941 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141Ab2HNNbp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Aug 2012 09:31:45 -0400
Message-ID: <502A533A.7030606@redhat.com>
Date: Tue, 14 Aug 2012 10:31:38 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Manu Abraham <abraham.manu@gmail.com>
CC: "Igor M. Liplianin" <liplianin@me.by>, linux-media@vger.kernel.org,
	linuxtv-commits@linuxtv.org
Subject: Re: [git:v4l-dvb/for_v3.7] [media] mantis: Terratec Cinergy C PCI
 HD (CI)
References: <E1SzvhW-0005hd-1S@www.linuxtv.org> <CAHFNz9Ju7dB-iz0mcGuNMLDwibFXZqGe73jpBk7RPqG_w+MmXg@mail.gmail.com> <5029548E.90901@redhat.com> <CAHFNz9+qWXYkvJXeZfSu2DgAQ3BrsX591TS5x+XeEOVji3Hx2g@mail.gmail.com> <502A5139.8080402@redhat.com>
In-Reply-To: <502A5139.8080402@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 14-08-2012 10:23, Mauro Carvalho Chehab escreveu:
> Em 14-08-2012 04:45, Manu Abraham escreveu:
>> On Tue, Aug 14, 2012 at 12:55 AM, Mauro Carvalho Chehab
>> <mchehab@redhat.com> wrote:
>>> Em 10-08-2012 20:55, Manu Abraham escreveu:
>>>> Mauro,
>>>>
>>>> Please revert this patch. Patch is incorrect. There is the VP-20300,
>>>> VP-20330, VP-2040, with differences in tuner types TDA10021, TDA10023,
>>>> MK-I, MK-II and MK-III. I have detailed this issue in an earlier mail.
>>>> Terratec Cinregy C is VP-2033 and not VP-2040.
>>>
>>> Well, as I don't have this board, you think that it is a VP-2033 while
>>> Igor thinks it is a VP-2040, I can't tell who is right on that.
>>
>> You don't need all the cards to apply changes, that's how the Linux
>> patchland works.
>>
>> I have "all" Mantis based devices here. So I can say with clarity that
>> Terratec Cinergy C is VP-2033. I authored the whole driver for the
>> chipset manufacturer and the card manufacturer and still in touch with
>> all of them and pretty sure what is what.
>>
>> Any idiot can send any patch, that's why you need to ask the persons
>> who added particular changes in that area.
> 
> Yes, you authored the driver, but that doesn't necessarily means that
> you'll have all clones of VP-2033/VP-2040.
> 
>> Do you want me to add
>> myself to MAINTAINERS to make it a bit more clearer, if that's what
>> you prefer ?
> 
> If you're wiling to maintain it, not holding patches for more than the
> few days required for their review, then YES!!! 
> 
> Please add yourself to the MAINTAINERS for the drivers you're willing
> to maintain and submit me such patch for upstream merging.
> 
>> Please revert this change.
> 
> I'll do.


Hmm... there's something wrong: this would be the revert patch, as produced
by git revert:

diff --git a/drivers/media/pci/mantis/mantis_cards.c b/drivers/media/pci/mantis/mantis_cards.c
index 0207d1f..095cf3a 100644
--- a/drivers/media/pci/mantis/mantis_cards.c
+++ b/drivers/media/pci/mantis/mantis_cards.c
@@ -275,7 +275,7 @@ static struct pci_device_id mantis_pci_table[] = {
 	MAKE_ENTRY(TWINHAN_TECHNOLOGIES, MANTIS_VP_2033_DVB_C, &vp2033_config),
 	MAKE_ENTRY(TWINHAN_TECHNOLOGIES, MANTIS_VP_2040_DVB_C, &vp2040_config),
 	MAKE_ENTRY(TECHNISAT, CABLESTAR_HD2, &vp2040_config),
-	MAKE_ENTRY(TERRATEC, CINERGY_C, &vp2040_config),
+	MAKE_ENTRY(TERRATEC, CINERGY_C, &vp2033_config),
 	MAKE_ENTRY(TWINHAN_TECHNOLOGIES, MANTIS_VP_3030_DVB_T, &vp3030_config),
 	{ }
 };
diff --git a/drivers/media/pci/mantis/mantis_core.c b/drivers/media/pci/mantis/mantis_core.c
index 684d906..22524a8 100644
--- a/drivers/media/pci/mantis/mantis_core.c
+++ b/drivers/media/pci/mantis/mantis_core.c
@@ -121,7 +121,7 @@ static void mantis_load_config(struct mantis_pci *mantis)
 		mantis->hwconfig = &vp2033_mantis_config;
 		break;
 	case MANTIS_VP_2040_DVB_C:	/* VP-2040 */
-	case CINERGY_C:	/* VP-2040 clone */
+	case TERRATEC_CINERGY_C_PCI:	/* VP-2040 clone */
 	case TECHNISAT_CABLESTAR_HD2:
 		mantis->hwconfig = &vp2040_mantis_config;
 		break;

There's something wrong there: the comments at "mantis_core", before this
patch, is saying that TERRATEC_CINERGY_C_PCI is a VP-2040 clone.

That doesn't look right: this card is either a VP-2033 clone (as stated on
mantis_cards), or a VP-2040 (as stated on mantis_core).

So, please write me a patch syncing both places with the correct information.

Thanks!
Mauro
