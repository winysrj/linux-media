Return-path: <linux-media-owner@vger.kernel.org>
Received: from imr-ma02.mx.aol.com ([64.12.206.40]:42077 "EHLO
	imr-ma02.mx.aol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753371Ab2IUOc2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Sep 2012 10:32:28 -0400
Message-ID: <505C7ACF.9050006@netscape.net>
Date: Fri, 21 Sep 2012 11:33:51 -0300
From: =?ISO-8859-1?Q?Alfredo_Jes=FAs_Delaiti?=
	<alfredodelaiti@netscape.net>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] Mygica X8507 audio for YPbPr, AV and S-Video
References: <50450FB5.3090503@netscape.net> <50589E52.5050602@redhat.com> <5059C949.6010808@netscape.net> <5059F2C1.7050302@redhat.com>
In-Reply-To: <5059F2C1.7050302@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi 

El 19/09/12 13:28, Mauro Carvalho Chehab escribió:
> Em 19-09-2012 10:31, Alfredo Jesús Delaiti escreveu:
>> El 18/09/12 13:16, Mauro Carvalho Chehab escribió:
>>> Em 03-09-2012 17:14, Alfredo Jesús Delaiti escreveu:
>>>> Hi
>>>>
>>>> This patch add audio support for input YPbPr, AV and S-Video for Mygica X8507 card.
>>>> I tried it with the 3.4 and 3.5 kernel
>>>>
>>>> Remains to be done: IR, FM and ISDBT
>>>>
>>>> Sorry if I sent the patch improperly.
>>>>
>>>> Signed-off-by: Alfredo J. Delaiti <alfredodelaiti@netscape.net>
>>>>
....
>>
>> I resubmit the patch with the advice given.
>> I apologize, but git and diff, still " aren't my friends"
>>
>> Thanks
>>
>>
>> Signed-off-by: Alfredo J. Delaiti <alfredodelaiti@netscape.net>
>>
>> diff --git a/drivers/media/pci/cx23885/cx23885-cards.c b/drivers/media/pci/cx23885/cx23885-cards.c
>> index d889bd2..cb5f847 100644
>> --- a/drivers/media/pci/cx23885/cx23885-cards.c
>> +++ b/drivers/media/pci/cx23885/cx23885-cards.c
>> @@ -530,42 +530,45 @@ struct cx23885_board cx23885_boards[] = {
>>         [CX23885_BOARD_MYGICA_X8507] = {
>>                 .name           = "Mygica X8507",
>>                 .tuner_type = TUNER_XC5000,
>>                 .tuner_addr = 0x61,
>>                 .tuner_bus      = 1,
>>                 .porta          = CX23885_ANALOG_VIDEO,
>>                 .input          = {
>>                         {
>>                                 .type   = CX23885_VMUX_TELEVISION,
>>                                 .vmux   = CX25840_COMPOSITE2,
>>                                 .amux   = CX25840_AUDIO8,
>>                         },
>>                         {
>>                                 .type   = CX23885_VMUX_COMPOSITE1,
>>                                 .vmux   = CX25840_COMPOSITE8,
>> +                               .amux   = CX25840_AUDIO7,
>>                         },
>>                         {
>>                                 .type   = CX23885_VMUX_SVIDEO,
>>                                 .vmux   = CX25840_SVIDEO_LUMA3 |
>> CX25840_SVIDEO_CHROMA4,
> 
> It seems that your emailer is not your friend too - it broke your patch ;)

Grrr. You are right, mail setup is wron
I applied this change:/usr/src/linux/Documentation/email-clients.txt., again
I proved before send email and is ok.

> 
> Please, be sure to not let your email break long lines like that, or the
> patch won't apply.
> 
> IMO, the better is to submit patches with git send-email. There are some examples
> at git-send-email manpage on how to use it with an smart host, if your sendmail
> is not configured for that.
> 
> Regards,
> Mauro.
> 

diff --git a/drivers/media/pci/cx23885/cx23885-cards.c b/drivers/media/pci/cx23885/cx23885-cards.c
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
 
diff --git a/drivers/media/pci/cx23885/cx23885-video.c b/drivers/media/pci/cx23885/cx23885-video.c
index 22f8e7f..fcb3f22 100644
--- a/drivers/media/pci/cx23885/cx23885-video.c
+++ b/drivers/media/pci/cx23885/cx23885-video.c
@@ -496,31 +496,32 @@ static int cx23885_video_mux(struct cx23885_dev *dev, unsigned int input)
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
