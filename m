Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:46235 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbaI3Hyf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Sep 2014 03:54:35 -0400
Received: by mail-we0-f178.google.com with SMTP id t60so14522699wes.37
        for <linux-media@vger.kernel.org>; Tue, 30 Sep 2014 00:54:34 -0700 (PDT)
Message-ID: <542A61A8.3030504@gmail.com>
Date: Tue, 30 Sep 2014 09:54:16 +0200
From: =?UTF-8?B?R2HDq3RhbiBDYXJsaWVy?= <gcembed@gmail.com>
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>, linux-media@vger.kernel.org
CC: javier Martin <javier.martin@vista-silicon.com>,
	Fabio Estevam <festevam@gmail.com>,
	Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [coda6] Error while decoding second h.264 chunk
References: <54228C77.7040004@gmail.com> <1411998818.3050.4.camel@pengutronix.de> <542A46E1.3010107@gmail.com>
In-Reply-To: <542A46E1.3010107@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
The problem can also come from register address or bit offset because 
depending source used (GStreamer for 2.6.22 or new coda kernel driver 
3.6 or datasheet), registers do not have same addresses or do not even 
exists !

On 09/30/2014 08:00 AM, Gaëtan Carlier wrote:
> Hi Philipp and Fabio,
> First of all, thanks a lot for your reply.
>
> On 09/29/2014 03:53 PM, Philipp Zabel wrote:
>> Hi Gaëtan,
>>
>> Am Mittwoch, den 24.09.2014, 11:18 +0200 schrieb Gaëtan Carlier:
>>> Hello Dears,
>>> I am back with my Coda6 (i.MX27). I have ported decoding from libvpu
>>> code to kernel 3.6 but I have a little problem. DEC_SEQ_INIT runs fine,
>>> the internal RdPtr increases by 512 bytes but when I run the DEC_PIC_RUN
>>> (PRESCAN disabled), the RdPTr has increased to 1024 (0x400), but
>>> macroblock error are reported and next DEC_PIC_RUN does not increase
>>> anymore the internal RdPtr.
>>> If I enable PRESCAN, the first DEC_PIC_RUN does not event finish
>>> (timeout).
>>
>> where is the PC pointer at when it times out? Maybe do a complete
>> register dump before DEC_PIC_RUN and after the timeout to see if
>> something stands out.
> I will do that and post reply today (I really don't know what to do with
> Program Counter of the FW. I hope you do :)).
Here is the dump reg when PRESCAN is enable (and leads to timeout):
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
coda coda-imx27.0: Int occurs : 00000002
CODA_REG_DEC_FUNC_CTRL (0x0114): 00000000
CODA_RET_DEC_SEQ_SRC_SIZE (0x01C4): 000A01E0
CODA_RET_DEC_SEQ_SRC_F_RATE (0x01C8): 00000000
CODA_RET_DEC_SEQ_FRAME_NEED (0x01CC): 00000003
CODA_RET_DEC_SEQ_FRAME_DELAY (0x01D0): 00000000
CODA_RET_DEC_SEQ_INFO (0x01D4): 00000000
CODA_RET_DEC_SEQ_CROP_LEFT_RIGHT (0x01D8): 00000000
CODA_RET_DEC_SEQ_CROP_TOP_BOTTOM (0x01DC): 00000000
CODA_RET_DEC_SEQ_NEXT_FRAME_NUM (0x01E0): 00000001
CODA_REG_BIT_RUN_INDEX (0x0168): 00000000
CODA_REG_BIT_RD_PTR0 (0x0120): A73C0200
CODA_REG_BIT_WR_PTR0 (0x0124): A73C187D
Framebuffers allocated 10
coda coda-imx27.0: Int occurs : 00000010
coda_device_run_decoder

coda_fill_decoder_bitstreambuf - c8d80000 - 1154 bytes added - 7423 
bytes bufferd
	WrPtr @ a73c1cff - RdPtr @ a73c0200
		00000001419AFFBF

CODA_REG_BIT_INT_STATUS (0x0010): 00000000
CODA_REG_BIT_CUR_PC (0x0018): 00000069
CODA_REG_BIT_CODE_BUF_ADDR (0x0100): A7130000
CODA_REG_BIT_WORK_BUF_ADDR (0x0104): A7200000
CODA_REG_BIT_PARA_BUF_ADDR (0x0108): A7300000
CODA_REG_BIT_STREAM_CTRL (0x010C): 00000006
CODA_REG_BIT_FRAME_MEM_CTRL (0x0110): 00000000
CODA_REG_DEC_FUNC_CTRL (0x0114): 00000000
CODADX6_REG_BIT_SEARCH_RAM_BASE_ADDR (0x0140): FFFF4C00

coda coda-imx27.0: CODA PIC_RUN timeout, stopping all streams

CODA_RET_DEC_PIC_FRAME_NUM (0x01C0): 00000001 size 460800
CODA_RET_DEC_PIC_IDX (0x01C4): 000A01E0
CODA_RET_DEC_PIC_ERR_MB_NUM (0x01C8): 00000000
CODA_RET_DEC_PIC_TYPE (0x01CC): 00000003
CODA_RET_DEC_PIC_SUCCESS (0x01D4): 00000003
CODA_RET_DEC_PIC_OPTION (0x01D0): 00000000
CODA_RET_DEC_PIC_CUR_IDX (0x01DC): FFFFFFFF
CODA_RET_DEC_PIC_NEXT_IDX (0x01E0): 00000001

CODA_REG_BIT_INT_STATUS (0x0010): 00000000
CODA_REG_BIT_CUR_PC (0x0018): 00000DC6
CODA_REG_BIT_CODE_BUF_ADDR (0x0100): A7130000
CODA_REG_BIT_WORK_BUF_ADDR (0x0104): A7200000
CODA_REG_BIT_PARA_BUF_ADDR (0x0108): A7300000
CODA_REG_BIT_STREAM_CTRL (0x010C): 00000006
CODA_REG_BIT_FRAME_MEM_CTRL (0x0110): 00000000
CODA_REG_DEC_FUNC_CTRL (0x0114): 00000000
CODADX6_REG_BIT_SEARCH_RAM_BASE_ADDR (0x0140): FFFF4C00

>>
>>> I attach the kernel driver (+fw), the h264 raw file (encoded using this
>>> coda6 driver and played without error using ffplay), the userspace test
>>> program and the log file.
>>>
>>> Can you give me some advise to know where to search. I have tried to
>>> reset WrPtr and RdPtr before first DEC_PIC_RUN and reload h264 raw file
>>> from the beginning, let RdPtr and WrPtr unchanged and h264 raw file from
>>> the beginning but this is even worst...
>>
>> I don't think you are supposed to write RdPtr.
> That is what I think too but I have tried many things before asking help :)
>> It is under firmware
>> control, at least between SEQ_INIT and SEQ_END. There is a DEC_BUF_FLUSH
>> command, maybe that does what you need.
> I supposed that DEC_BUF_FLUSH command is needed after DEC_PIC_RUN
> command in case of last chunk or one frame decoding. As my problem
> occurs while this first DEC_PIC_RUN, I don't even try to implement this
> command.
>> What happens if you queue a third ~1200 byte frame before calling the
>> first DEC_PIC_RUN?
>>
> I already try to increase v4l2buffer from userspace and queue upto 10
> h.264 chunk in bitstreambuffer but same behaviour.
>>> The firmware is version 2.2.5.
>>>
>>> Thanks a lot for your help.
>>> Best regards,
>>> Gaëtan Carlier.
>>>
>>> ps: I do not post this on mailing list due to attachments that may
>>> not work
>>
>> You could extract the relevant parts of the log.
> I send this reply on mailing list, as people will already see your
> advise and avoid duplication. Here is the log:
>
> ...
> coda coda-imx27.0: Initialized CodaDx6.
> coda coda-imx27.0: Firmware version: 2.2.5
> coda coda-imx27.0: codec registered as /dev/video2
> ...
> Chunk 0[6269] : key frame 67 (00000001674218D4)
> Chunk 1[1154] :     frame 41 (00000001419AFFBF)
> Chunk 2[1293] :     frame 41 (00000001419A8110)
> Chunk 3[1256] :     frame 41 (00000001419A7590)
> Chunk 4[1887] :     frame 41 (00000001419A0989)
> Chunk 5[2609] :     frame 41 (00000001419A6E54)
> Chunk 6[2463] :     frame 41 (00000001419A0865)
> Chunk 7[2087] :     frame 41 (00000001419AB42D)
> Chunk 8[2394] :     frame 41 (00000001419AB52F)
> Chunk 9[2210] :     frame 41 (00000001419A2CC2)
>
> coda_fill_decoder_bitstreambuf - c8c7f000 - 6269 bytes added - 6269
> bytes bufferd
>      WrPtr @ a73c187d - RdPtr @ a73c0000
>          00000001674218D4
> coda coda-imx27.0: Int occurs : 00000002 (SEQ_INIT)
> coda coda-imx27.0: CODA_REG_DEC_FUNC_CTRL : 00000000
> coda coda-imx27.0: CODA_RET_DEC_SEQ_SRC_SIZE : 000A01E0
> coda coda-imx27.0: CODA_RET_DEC_SEQ_SRC_F_RATE : 00000000
> coda coda-imx27.0: CODA_RET_DEC_SEQ_FRAME_NEED : 00000003
> coda coda-imx27.0: CODA_RET_DEC_SEQ_FRAME_DELAY : 00000000
> coda coda-imx27.0: CODA_RET_DEC_SEQ_INFO : 00000000
> coda coda-imx27.0: CODA_RET_DEC_SEQ_CROP_LEFT_RIGHT : 00000000
> coda coda-imx27.0: CODA_RET_DEC_SEQ_CROP_TOP_BOTTOM : 00000000
> coda coda-imx27.0: CODA_RET_DEC_SEQ_NEXT_FRAME_NUM : 00000001
> coda coda-imx27.0: CODA_REG_BIT_RUN_INDEX : 00000000
> coda coda-imx27.0: CODA_REG_BIT_RD_PTR0 : A73C0200
> coda coda-imx27.0: CODA_REG_BIT_WR_PTR0 : A73C187D
> Framebuffers allocated 10
> coda coda-imx27.0: Int occurs : 00000010 (SET_FRAME_BUF)
> coda_device_run_decoder
>
> coda_fill_decoder_bitstreambuf - c8d80000 - 1154 bytes added - 7423
> bytes bufferd
>      WrPtr @ a73c1cff - RdPtr @ a73c0200
>          00000001419AFFBF
> coda coda-imx27.0: Int occurs : 00000008 (PIC_RUN)
> CODA_RET_DEC_PIC_FRAME_NUM : 00000001 size 460800
> CODA_RET_DEC_PIC_IDX : 00000000
> CODA_RET_DEC_PIC_ERR_MB_NUM : 00000442
> CODA_RET_DEC_PIC_TYPE : 00000000
> CODA_RET_DEC_PIC_SUCCESS : 00000001
> CODA_RET_DEC_PIC_OPTION : 00000002
> CODA_RET_DEC_PIC_CUR_IDX : 00000001
> CODA_RET_DEC_PIC_NEXT_IDX : 00000001
> coda_device_run_decoder
>
> coda_fill_decoder_bitstreambuf - c8e81000 - 1293 bytes added - 8716
> bytes bufferd
>      WrPtr @ a73c220c - RdPtr @ a73c0400
>          00000001419A8110
> Image 1 decoded : 0
> Chunk 10[2841] :     frame 41 (00000001419A09A2)
> Chunk 11 loaded
> coda coda-imx27.0: Int occurs : 00000008
> CODA_RET_DEC_PIC_FRAME_NUM : 00000002 size 460800
> CODA_RET_DEC_PIC_IDX : 00000001
> CODA_RET_DEC_PIC_ERR_MB_NUM : 000000EA
> CODA_RET_DEC_PIC_TYPE : 00000001
> CODA_RET_DEC_PIC_SUCCESS : 00000001
> CODA_RET_DEC_PIC_OPTION : 00000002
> CODA_RET_DEC_PIC_CUR_IDX : 00000002
> CODA_RET_DEC_PIC_NEXT_IDX : 00000001
> coda_device_run_decoder
> ...
>
> A log with PRESCAN enabled and register dump before/after the timeout
> will be posted later.
>>
>> regards
>> Philipp
>>
>
> Best regards,
> Gaëtan.
Regards,
Gaëtan.

