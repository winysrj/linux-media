Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:49405 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793Ab2GBNsN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Jul 2012 09:48:13 -0400
Received: by wibhr14 with SMTP id hr14so3202600wib.1
        for <linux-media@vger.kernel.org>; Mon, 02 Jul 2012 06:48:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACKLOr1shAodE9FDD9dZ1dgAKy4PyPRQAsyMOiNzqQ0uQFTYGA@mail.gmail.com>
References: <1340115094-859-1-git-send-email-javier.martin@vista-silicon.com>
	<20120619181717.GE28394@pengutronix.de>
	<CACKLOr1zCp2NfLjBrHjtXpmsFMHqhoHFPpghN=Tyf3YAcyRrYg@mail.gmail.com>
	<20120620090126.GO28394@pengutronix.de>
	<20120620100015.GA30243@sirena.org.uk>
	<20120620130941.GB2253@S2101-09.ap.freescale.net>
	<CACKLOr28vm9n08VSOim=riB54os665be1CHdUqFXk+3MqPqtWQ@mail.gmail.com>
	<20120620143336.GE2253@S2101-09.ap.freescale.net>
	<CACKLOr1oZZPZBNv+p9p3Vf5oY4K8K65_dJ5qkJO6NqeP2=2unw@mail.gmail.com>
	<20120702105427.GP2698@pengutronix.de>
	<CACKLOr1shAodE9FDD9dZ1dgAKy4PyPRQAsyMOiNzqQ0uQFTYGA@mail.gmail.com>
Date: Mon, 2 Jul 2012 15:48:11 +0200
Message-ID: <CACKLOr31Gp5N2FpEsyqLw2QvOg1BBhDCOMetmzUBZwLezjS=gQ@mail.gmail.com>
Subject: Re: [RFC] Support for 'Coda' video codec IP.
From: javier Martin <javier.martin@vista-silicon.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Shawn Guo <shawn.guo@linaro.org>, fabio.estevam@freescale.com,
	dirk.behme@googlemail.com, r.schwebel@pengutronix.de,
	kernel@pengutronix.de, linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2 July 2012 13:13, javier Martin <javier.martin@vista-silicon.com> wrote:
> On 2 July 2012 12:54, Sascha Hauer <s.hauer@pengutronix.de> wrote:
>> On Mon, Jul 02, 2012 at 12:36:46PM +0200, javier Martin wrote:
>>> Hi Sascha,
>>> I almost have a final version ready which includes multi-instance
>>> support (not tested though) [1]. As I stated, we assumed the extra
>>> effort of looking at your code in [2] in order to provide a mechanism
>>> that preserves compatibility between VPUs in i.MX21, i.MX51 and
>>> i.MX53. This is the only thing left in order to send the driver for
>>> mainline submission.
>>>
>>> While I was reading your code I found out that you keep the following
>>> formats for v1 (codadx6-i.MX27) codec:
>>>
>>> static int vpu_v1_codecs[VPU_CODEC_MAX] = {
>>>       [VPU_CODEC_AVC_DEC] = 2,
>>>       [VPU_CODEC_VC1_DEC] = -1,
>>>       [VPU_CODEC_MP2_DEC] = -1,
>>>       [VPU_CODEC_DV3_DEC] = -1,
>>>       [VPU_CODEC_RV_DEC] = -1,
>>>       [VPU_CODEC_MJPG_DEC] = 0x82,
>>>       [VPU_CODEC_AVC_ENC] = 3,
>>>       [VPU_CODEC_MP4_ENC] = 1,
>>>       [VPU_CODEC_MJPG_ENC] = 0x83,
>>> };
>>>
>>> As I understand, this means the following operations are supported:
>>>
>>> 1- H264 decoding.
>>> 2- H264 encoding
>>> 3- MP4 encoding.
>>> 4- MJPG  decoding.
>>> 5- MJPG encoding.
>>>
>>> I totally agree with MP4 and H264 formats but, are you sure about
>>> MJPG? I have a i.MX27 v1 codec (codadx6) but I didn't know that this
>>> codec supported MJPG. Have you tested this code with an i.MX27 and
>>> MJPG? Where did you find out that it supports this format?
>>
>> We haven't tested MJPG on the i.MX27. The table above is from the
>> original Freescale code, so I assume it's correct and I assume that
>> the coda dx6 can do MJPEG.
>
> Fabio, could you confirm that the VPU in the i.MX27 supports MJPG too?
>
>>> Are you
>>> using firmware version 2.2.4 for v1 codecs?
>>
>> No, 2.2.5
>
> Where did you get that firmware version? The only related download I
> can find in [1] is
> 'MX273DS_FULL_VPU_SW_AND_VPU_FIRMWARE_2.2.4_WINCE_TO2.X_ONLY' which
> includes firmware 2.2.4.
>
> [1] http://www.freescale.com/webapp/sps/site/prod_summary.jsp?code=i.MX27&nodeId=018rH3ZrDR66AF&fpsp=1&tab=Design_Tools_Tab

Hi, I was wrong regarding firmware version; we are dealing with 2.2.5
too. Sorry for the noise.

However, it would be great if Fabio could confirm that codadx6 in the
i.MX27 supports MJPG too.

Regards.

-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
