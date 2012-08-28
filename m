Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:49366 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876Ab2H1KcW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Aug 2012 06:32:22 -0400
Received: by wibhr14 with SMTP id hr14so4577291wib.1
        for <linux-media@vger.kernel.org>; Tue, 28 Aug 2012 03:32:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <503C9AD3.6010108@gmail.com>
References: <1345825078-3688-1-git-send-email-p.zabel@pengutronix.de>
	<CACKLOr2Jvaie-jDSQwhSB_DPRhspz+oFW=EowBir6DTdhvxJaw@mail.gmail.com>
	<503C9AD3.6010108@gmail.com>
Date: Tue, 28 Aug 2012 12:32:21 +0200
Message-ID: <CACKLOr0LgF2hND2JkrU-Wa8GcnOZJ9g5uhpqNSiE7EOUN5EHAw@mail.gmail.com>
Subject: Re: [PATCH 0/12] Initial i.MX5/CODA7 support for the CODA driver
From: javier Martin <javier.martin@vista-silicon.com>
To: =?ISO-8859-1?Q?Ga=EBtan_Carlier?= <gcembed@gmail.com>
Cc: linux-media@vger.kernel.org,
	Fabio Estevam <fabio.estevam@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

You have to apply the following operation to the binary fw file
provided by Freescale.
We agreed with Fabio that they were going to submit that file with the
modification below to the linux-firmware repository soon.

#include <stdio.h>
#include <stdint.h>
#include <assert.h>
#include "vpu_codetable_mx27.h"

int main() {
  FILE *f;
  uint32_t data;
  int i;

  f = fopen("v4l-codadx6-imx27.bin", "wb");

  assert(f != NULL);

  /* Copy full Microcode to Code Buffer allocated on SDRAM */
  for (i = 0; i < sizeof(bit_code2) / sizeof(bit_code2[0]); i += 2) {
    data = (uint32_t)((bit_code2[i] << 16) | bit_code2[i + 1]);
    fwrite(&data, sizeof(data), 1, f);
  }
  fclose(f);

}


On 28 August 2012 12:17, Gaëtan Carlier <gcembed@gmail.com> wrote:
> Hi Javier,
>
> On 08/28/2012 10:10 AM, javier Martin wrote:
>>
>> Hi Philipp,
>> in order to give you my ACK I need that patch 3 gets fixed and patches
>> 3-10 are resent so that they can apply cleanly.
>> After that, we'll make some intensive testing for a week in i.MX27, if
>> everything works as expected I'll ACK the patches.
>>
> I am also doing some test with new Coda6 driver (I previously used kernel
> 2.6.22 with VPU driver) but when the FW is sent, Coda does not respond and
> timeout occurs. I have tried built-in and module version with built-in
> firmware or via rootfs but each time the FW is found, sent to Coda then
> timeout occurs.
> Have you any advise for me or a working patch set for the current
> linux-next.
> Thanks a lot for your help.
> Regards,
> Gaëtan Carlier.
>
>
>> Regards.
>>
>> On 24 August 2012 18:17, Philipp Zabel <p.zabel@pengutronix.de> wrote:
>>>
>>> These patches contain initial firmware loading and encoding support for
>>> the
>>> CODA7 series VPU contained in i.MX51 and i.MX53 SoCs, and fix some
>>> multi-instance
>>> issues.
>>>
>>> regards
>>> Philipp
>>>
>>> ---
>>>   arch/arm/boot/dts/imx51.dtsi        |    6 +++++
>>>   arch/arm/boot/dts/imx53.dtsi        |    7 ++++++
>>>   arch/arm/mach-imx/clk-imx51-imx53.c |    4 +--
>>>   drivers/media/video/Kconfig         |    3 ++-
>>>   drivers/media/video/coda.c          |  367
>>> ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++------------------------------------------------------------------------
>>>   drivers/media/video/coda.h          |   21 +++++++++++++---
>>>   6 files changed, 305 insertions(+), 103 deletions(-)
>>>
>>
>>
>>
>



-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
