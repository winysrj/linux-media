Return-path: <linux-media-owner@vger.kernel.org>
Received: from imr-da02.mx.aol.com ([205.188.105.144]:44107 "EHLO
	imr-da02.mx.aol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754872Ab2ISNd2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Sep 2012 09:33:28 -0400
Message-ID: <5059C949.6010808@netscape.net>
Date: Wed, 19 Sep 2012 10:31:53 -0300
From: =?ISO-8859-1?Q?Alfredo_Jes=FAs_Delaiti?=
	<alfredodelaiti@netscape.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH] Mygica X8507 audio for YPbPr, AV and S-Video
References: <50450FB5.3090503@netscape.net> <50589E52.5050602@redhat.com>
In-Reply-To: <50589E52.5050602@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

El 18/09/12 13:16, Mauro Carvalho Chehab escribió:
> Em 03-09-2012 17:14, Alfredo Jesús Delaiti escreveu:
>> Hi
>>
>> This patch add audio support for input YPbPr, AV and S-Video for Mygica X8507 card.
>> I tried it with the 3.4 and 3.5 kernel
>>
>> Remains to be done: IR, FM and ISDBT
>>
>> Sorry if I sent the patch improperly.
>>
>> Signed-off-by: Alfredo J. Delaiti <alfredodelaiti@netscape.net>
>>
>>
>>
>> diff --git a/media/video/cx23885/cx23885-cards.c b/media/video/cx23885/cx23885-cards.c
>> index 080e111..17e2576 100644
>> --- a/media/video/cx23885/cx23885-cards.c
>> +++ b/media/video/cx23885/cx23885-cards.c
> Wrong format... the "drivers/" is missing.
>
> Well, the location also changed to drivers/media/pci, but my scripts can
> fix it.
>
>> @@ -541,11 +541,13 @@ struct cx23885_board cx23885_boards[] = {
>>                          {
>>                                  .type   = CX23885_VMUX_COMPOSITE1,
>>                                  .vmux   = CX25840_COMPOSITE8,
>> +                               .amux   = CX25840_AUDIO7,
> Didn't apply well. It seems it conflicted with some other patch.
>
> Please, re-generate it against the very latest tree.
>
> Also, when doing diffs for the boards entries, it is wise to have
> more context lines, in order that a patch made for one driver would
> be badly applied at some other board entry.
>
> The easiest way to do that is to do:
>
> 	$ git diff -U10
> 		or
> 	$ git show -U10
> 		(if you've merged the patch at your local copy)
>
> (if you're generating the patch against the main media-tree.git)
>
> Where "10" is just an arbitrary large number that will allow to
> see the board name that will be modified, like:
>
> --- a/drivers/media/pci/cx23885/cx23885-cards.c
> +++ b/drivers/media/pci/cx23885/cx23885-cards.c
> @@ -531,20 +531,21 @@ struct cx23885_board cx23885_boards[] = {
>                  .name           = "Mygica X8507",
>                  .tuner_type = TUNER_XC5000,
>                  .tuner_addr = 0x61,
>                  .tuner_bus      = 1,
>                  .porta          = CX23885_ANALOG_VIDEO,
>                  .input          = {
>                          {
>                                  .type   = CX23885_VMUX_TELEVISION,
>                                  .vmux   = CX25840_COMPOSITE2,
>                                  .amux   = CX25840_AUDIO8,
> + /* Some foo addition - just for testing */
>                          },
>                          {
>                                  .type   = CX23885_VMUX_COMPOSITE1,
>                                  .vmux   = CX25840_COMPOSITE8,
>                          },
>                          {
>                                  .type   = CX23885_VMUX_SVIDEO,
>                                  .vmux   = CX25840_SVIDEO_LUMA3 |
>                                                  CX25840_SVIDEO_CHROMA4,
>                          },
>
>
> Thanks,
> Mauro
Hi

Thanks for the advice.

I resubmit the patch with the advice given.
I apologize, but git and diff, still " aren't my friends"

Thanks


Signed-off-by: Alfredo J. Delaiti <alfredodelaiti@netscape.net>

diff --git a/drivers/media/pci/cx23885/cx23885-cards.c 
b/drivers/media/pci/cx23885/cx23885-cards.c
index d889bd2..cb5f847 100644
--- a/drivers/media/pci/cx23885/cx23885-cards.c
+++ b/drivers/media/pci/cx23885/cx23885-cards.c
@@ -530,42 +530,45 @@ struct cx23885_board cx23885_boards[] = {
         [CX23885_BOARD_MYGICA_X8507] = {
                 .name           = "Mygica X8507",
                 .tuner_type = TUNER_XC5000,
                 .tuner_addr = 0x61,
                 .tuner_bus      = 1,
                 .porta          = CX23885_ANALOG_VIDEO,
                 .input          = {
                         {
                                 .type   = CX23885_VMUX_TELEVISION,
                                 .vmux   = CX25840_COMPOSITE2,
                                 .amux   = CX25840_AUDIO8,
                         },
                         {
                                 .type   = CX23885_VMUX_COMPOSITE1,
                                 .vmux   = CX25840_COMPOSITE8,
+                               .amux   = CX25840_AUDIO7,
                         },
                         {
                                 .type   = CX23885_VMUX_SVIDEO,
                                 .vmux   = CX25840_SVIDEO_LUMA3 |
CX25840_SVIDEO_CHROMA4,
+                               .amux   = CX25840_AUDIO7,
                         },
                         {
                                 .type   = CX23885_VMUX_COMPONENT,
                                 .vmux   = CX25840_COMPONENT_ON |
                                         CX25840_VIN1_CH1 |
                                         CX25840_VIN6_CH2 |
                                         CX25840_VIN7_CH3,
+                               .amux   = CX25840_AUDIO7,
                         },
                 },
         },
         [CX23885_BOARD_TERRATEC_CINERGY_T_PCIE_DUAL] = {
                 .name           = "TerraTec Cinergy T PCIe Dual",
                 .portb          = CX23885_MPEG_DVB,
                 .portc          = CX23885_MPEG_DVB,
         },
         [CX23885_BOARD_TEVII_S471] = {
                 .name           = "TeVii S471",
                 .portb          = CX23885_MPEG_DVB,
         }
  };
  const unsigned int cx23885_bcount = ARRAY_SIZE(cx23885_boards);

diff --git a/drivers/media/pci/cx23885/cx23885-video.c 
b/drivers/media/pci/cx23885/cx23885-video.c
index 22f8e7f..fcb3f22 100644
--- a/drivers/media/pci/cx23885/cx23885-video.c
+++ b/drivers/media/pci/cx23885/cx23885-video.c
@@ -496,31 +496,32 @@ static int cx23885_video_mux(struct cx23885_dev 
*dev, unsigned int input)
                 dev->board == CX23885_BOARD_MYGICA_X8507) {
                 /* Select Analog TV */
                 if (INPUT(input)->type == CX23885_VMUX_TELEVISION)
                         cx23885_gpio_clear(dev, GPIO_0);
         }

         /* Tell the internal A/V decoder */
         v4l2_subdev_call(dev->sd_cx25840, video, s_routing,
                         INPUT(input)->vmux, 0, 0);

         if ((dev->board == CX23885_BOARD_HAUPPAUGE_HVR1800) ||
                 (dev->board == CX23885_BOARD_MPX885) ||
                 (dev->board == CX23885_BOARD_HAUPPAUGE_HVR1250) ||
                 (dev->board == CX23885_BOARD_HAUPPAUGE_HVR1255) ||
                 (dev->board == CX23885_BOARD_HAUPPAUGE_HVR1255_22111) ||
-               (dev->board == CX23885_BOARD_HAUPPAUGE_HVR1850)) {
+               (dev->board == CX23885_BOARD_HAUPPAUGE_HVR1850) ||
+               (dev->board == CX23885_BOARD_MYGICA_X8507)) {
                 /* Configure audio routing */
                 v4l2_subdev_call(dev->sd_cx25840, audio, s_routing,
                         INPUT(input)->amux, 0, 0);

                 if (INPUT(input)->amux == CX25840_AUDIO7)
                         cx23885_flatiron_mux(dev, 1);
                 else if (INPUT(input)->amux == CX25840_AUDIO6)
                         cx23885_flatiron_mux(dev, 2);
         }

         return 0;
  }

  static int cx23885_audio_mux(struct cx23885_dev *dev, unsigned int input)
  {

-- 
Dona tu voz
http://www.voxforge.org/es

