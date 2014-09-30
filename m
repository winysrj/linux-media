Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:64495 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988AbaI3GAT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Sep 2014 02:00:19 -0400
Received: by mail-wi0-f172.google.com with SMTP id ex7so3089945wid.17
        for <linux-media@vger.kernel.org>; Mon, 29 Sep 2014 23:00:17 -0700 (PDT)
Message-ID: <542A46E1.3010107@gmail.com>
Date: Tue, 30 Sep 2014 08:00:01 +0200
From: =?UTF-8?B?R2HDq3RhbiBDYXJsaWVy?= <gcembed@gmail.com>
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>, linux-media@vger.kernel.org
CC: javier Martin <javier.martin@vista-silicon.com>,
	Fabio Estevam <festevam@gmail.com>,
	Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [coda6] Error while decoding second h.264 chunk
References: <54228C77.7040004@gmail.com> <1411998818.3050.4.camel@pengutronix.de>
In-Reply-To: <1411998818.3050.4.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp and Fabio,
First of all, thanks a lot for your reply.

On 09/29/2014 03:53 PM, Philipp Zabel wrote:
> Hi Gaëtan,
>
> Am Mittwoch, den 24.09.2014, 11:18 +0200 schrieb Gaëtan Carlier:
>> Hello Dears,
>> I am back with my Coda6 (i.MX27). I have ported decoding from libvpu
>> code to kernel 3.6 but I have a little problem. DEC_SEQ_INIT runs fine,
>> the internal RdPtr increases by 512 bytes but when I run the DEC_PIC_RUN
>> (PRESCAN disabled), the RdPTr has increased to 1024 (0x400), but
>> macroblock error are reported and next DEC_PIC_RUN does not increase
>> anymore the internal RdPtr.
>> If I enable PRESCAN, the first DEC_PIC_RUN does not event finish (timeout).
>
> where is the PC pointer at when it times out? Maybe do a complete
> register dump before DEC_PIC_RUN and after the timeout to see if
> something stands out.
I will do that and post reply today (I really don't know what to do with 
Program Counter of the FW. I hope you do :)).
>
>> I attach the kernel driver (+fw), the h264 raw file (encoded using this
>> coda6 driver and played without error using ffplay), the userspace test
>> program and the log file.
>>
>> Can you give me some advise to know where to search. I have tried to
>> reset WrPtr and RdPtr before first DEC_PIC_RUN and reload h264 raw file
>> from the beginning, let RdPtr and WrPtr unchanged and h264 raw file from
>> the beginning but this is even worst...
>
> I don't think you are supposed to write RdPtr.
That is what I think too but I have tried many things before asking help :)
> It is under firmware
> control, at least between SEQ_INIT and SEQ_END. There is a DEC_BUF_FLUSH
> command, maybe that does what you need.
I supposed that DEC_BUF_FLUSH command is needed after DEC_PIC_RUN 
command in case of last chunk or one frame decoding. As my problem 
occurs while this first DEC_PIC_RUN, I don't even try to implement this 
command.
> What happens if you queue a third ~1200 byte frame before calling the
> first DEC_PIC_RUN?
>
I already try to increase v4l2buffer from userspace and queue upto 10 
h.264 chunk in bitstreambuffer but same behaviour.
>> The firmware is version 2.2.5.
>>
>> Thanks a lot for your help.
>> Best regards,
>> Gaëtan Carlier.
>>
>> ps: I do not post this on mailing list due to attachments that may not work
>
> You could extract the relevant parts of the log.
I send this reply on mailing list, as people will already see your 
advise and avoid duplication. Here is the log:

...
coda coda-imx27.0: Initialized CodaDx6.
coda coda-imx27.0: Firmware version: 2.2.5
coda coda-imx27.0: codec registered as /dev/video2
...
Chunk 0[6269] : key frame 67 (00000001674218D4)
Chunk 1[1154] :     frame 41 (00000001419AFFBF)
Chunk 2[1293] :     frame 41 (00000001419A8110)
Chunk 3[1256] :     frame 41 (00000001419A7590)
Chunk 4[1887] :     frame 41 (00000001419A0989)
Chunk 5[2609] :     frame 41 (00000001419A6E54)
Chunk 6[2463] :     frame 41 (00000001419A0865)
Chunk 7[2087] :     frame 41 (00000001419AB42D)
Chunk 8[2394] :     frame 41 (00000001419AB52F)
Chunk 9[2210] :     frame 41 (00000001419A2CC2)

coda_fill_decoder_bitstreambuf - c8c7f000 - 6269 bytes added - 6269 
bytes bufferd
	WrPtr @ a73c187d - RdPtr @ a73c0000
		00000001674218D4
coda coda-imx27.0: Int occurs : 00000002 (SEQ_INIT)
coda coda-imx27.0: CODA_REG_DEC_FUNC_CTRL : 00000000
coda coda-imx27.0: CODA_RET_DEC_SEQ_SRC_SIZE : 000A01E0
coda coda-imx27.0: CODA_RET_DEC_SEQ_SRC_F_RATE : 00000000
coda coda-imx27.0: CODA_RET_DEC_SEQ_FRAME_NEED : 00000003
coda coda-imx27.0: CODA_RET_DEC_SEQ_FRAME_DELAY : 00000000
coda coda-imx27.0: CODA_RET_DEC_SEQ_INFO : 00000000
coda coda-imx27.0: CODA_RET_DEC_SEQ_CROP_LEFT_RIGHT : 00000000
coda coda-imx27.0: CODA_RET_DEC_SEQ_CROP_TOP_BOTTOM : 00000000
coda coda-imx27.0: CODA_RET_DEC_SEQ_NEXT_FRAME_NUM : 00000001
coda coda-imx27.0: CODA_REG_BIT_RUN_INDEX : 00000000
coda coda-imx27.0: CODA_REG_BIT_RD_PTR0 : A73C0200
coda coda-imx27.0: CODA_REG_BIT_WR_PTR0 : A73C187D
Framebuffers allocated 10
coda coda-imx27.0: Int occurs : 00000010 (SET_FRAME_BUF)
coda_device_run_decoder

coda_fill_decoder_bitstreambuf - c8d80000 - 1154 bytes added - 7423 
bytes bufferd
	WrPtr @ a73c1cff - RdPtr @ a73c0200
		00000001419AFFBF
coda coda-imx27.0: Int occurs : 00000008 (PIC_RUN)
CODA_RET_DEC_PIC_FRAME_NUM : 00000001 size 460800
CODA_RET_DEC_PIC_IDX : 00000000
CODA_RET_DEC_PIC_ERR_MB_NUM : 00000442
CODA_RET_DEC_PIC_TYPE : 00000000
CODA_RET_DEC_PIC_SUCCESS : 00000001
CODA_RET_DEC_PIC_OPTION : 00000002
CODA_RET_DEC_PIC_CUR_IDX : 00000001
CODA_RET_DEC_PIC_NEXT_IDX : 00000001
coda_device_run_decoder

coda_fill_decoder_bitstreambuf - c8e81000 - 1293 bytes added - 8716 
bytes bufferd
	WrPtr @ a73c220c - RdPtr @ a73c0400
		00000001419A8110
Image 1 decoded : 0
Chunk 10[2841] :     frame 41 (00000001419A09A2)
Chunk 11 loaded
coda coda-imx27.0: Int occurs : 00000008
CODA_RET_DEC_PIC_FRAME_NUM : 00000002 size 460800
CODA_RET_DEC_PIC_IDX : 00000001
CODA_RET_DEC_PIC_ERR_MB_NUM : 000000EA
CODA_RET_DEC_PIC_TYPE : 00000001
CODA_RET_DEC_PIC_SUCCESS : 00000001
CODA_RET_DEC_PIC_OPTION : 00000002
CODA_RET_DEC_PIC_CUR_IDX : 00000002
CODA_RET_DEC_PIC_NEXT_IDX : 00000001
coda_device_run_decoder
...

A log with PRESCAN enabled and register dump before/after the timeout 
will be posted later.
>
> regards
> Philipp
>

Best regards,
Gaëtan.
