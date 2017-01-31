Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:34975 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750891AbdAaPQQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Jan 2017 10:16:16 -0500
From: Hugues FRUCHET <hugues.fruchet@st.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Jean Christophe TROTIN <jean-christophe.trotin@st.com>
Subject: Re: [GIT PULL FOR v4.11] New st-delta driver
Date: Tue, 31 Jan 2017 15:16:10 +0000
Message-ID: <b316166d-b183-0c65-ca9f-d23f6ad4eea6@st.com>
References: <b5f8fb46-6507-417c-8f1e-3b3f1410a64d@xs4all.nl>
 <20170130171536.07f4996d@vento.lan> <20170130171821.1ff63f52@vento.lan>
In-Reply-To: <20170130171821.1ff63f52@vento.lan>
Content-Language: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <089CA5820B90AB4FA3977751BE2D1694@st.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/30/2017 08:18 PM, Mauro Carvalho Chehab wrote:
> Em Mon, 30 Jan 2017 17:15:36 -0200
> Mauro Carvalho Chehab <mchehab@s-opensource.com> escreveu:
>
>> Em Mon, 9 Jan 2017 14:23:33 +0100
>> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
>>
>>> See the v4 series for details:
>>>
>>> https://www.spinics.net/lists/linux-media/msg108737.html
>>>
>>> Regards,
>>>
>>> 	Hans
>>>
>>> The following changes since commit 40eca140c404505c09773d1c6685d818cb55ab1a:
>>>
>>>   [media] mn88473: add DVB-T2 PLP support (2016-12-27 14:00:15 -0200)
>>>
>>> are available in the git repository at:
>>>
>>>   git://linuxtv.org/hverkuil/media_tree.git delta
>>>
>>> for you to fetch changes up to e6f199d01e7b8bc4436738b6c666fda31b9f3340:
>>>
>>>   st-delta: debug: trace stream/frame information & summary (2017-01-09 14:16:45 +0100)
>>>
>>> ----------------------------------------------------------------
>>> Hugues Fruchet (10):
>>>       Documentation: DT: add bindings for ST DELTA
>>>       ARM: dts: STiH410: add DELTA dt node
>>>       ARM: multi_v7_defconfig: enable STMicroelectronics DELTA Support
>>>       MAINTAINERS: add st-delta driver
>>>       st-delta: STiH4xx multi-format video decoder v4l2 driver
>>>       st-delta: add memory allocator helper functions
>>>       st-delta: rpmsg ipc support
>>>       st-delta: EOS (End Of Stream) support
>>>       st-delta: add mjpeg support
>>>       st-delta: debug: trace stream/frame information & summary
>>
>> There is something wrong on this driver... even after applying all
>> patches, it complains that there's a for there that does nothing:
>>
>> drivers/media/platform/sti/delta/delta-v4l2.c:322 register_decoders() warn: we never enter this loop
>> drivers/media/platform/sti/delta/delta-v4l2.c: In function 'register_decoders':
>> drivers/media/platform/sti/delta/delta-v4l2.c:322:16: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
>>   for (i = 0; i < ARRAY_SIZE(delta_decoders); i++) {
>>                 ^

Hi Mauro,

It's strange that you face this warning, code is like that:
/* registry of available decoders */
static const struct delta_dec *delta_decoders[] = {
#ifdef CONFIG_VIDEO_STI_DELTA_MJPEG
	&mjpegdec,
#endif
};

and MJPEG config is enabled by default:
config VIDEO_STI_DELTA_MJPEG
	bool "STMicroelectronics DELTA MJPEG support"
	default y

so you should not encounter this warning.

On the other hand, you face issue on line 322 of delta-v4l2.c but in my 
codebase, and also in Hans' git tree 
(git://linuxtv.org/hverkuil/media_tree.git delta), this code is at line 323.

Anyway, in order to prevent such warning even if no decoder are selected 
in config, I have reworked the code in v5 adding a "NULL"
element at the end of decoder array out of any config switch:
static const struct delta_dec *delta_decoders[] = {
#ifdef CONFIG_VIDEO_STI_DELTA_MJPEG
	&mjpegdec,
#endif
	NULL,
};

>>
>> On a first glance, it seems that the register_decoders() function is
>> reponsible to register the format decoders that the hardware
>> recognizes. If so, I suspect that this driver is deadly broken.
>>
>> Please be sure that the upstream driver works properly before
>> submitting it upstream.
>>
>> Also, please fix the comments to match the Kernel standard. E. g.
>> instead of:
>>
>> /* guard output frame count:
>>  * - at least 1 frame needed for display
>>  * - at worst 21
>>  *   ( max h264 dpb (16) +
>>  *     decoding peak smoothing (2) +
>>  *     user display pipeline (3) )
>>  */
>>
>> It should be:
>>
>> /*
>>  * guard output frame count:
>>  * - at least 1 frame needed for display
>>  * - at worst 21
>>  *   ( max h264 dpb (16) +
>>  *     decoding peak smoothing (2) +
>>  *     user display pipeline (3) )
>>  */
>>
>> There are several similar occurrences among this patch series.

I apologize for this -unfortunately not raised by checkpatch, I will 
have a look to fix it-
Multiple lines comments are now fixed in v5.

>
> Ah, forgot to comment, but it mentions a firmware. Does such firmware
> reside on some RAM memory? If so, how such firmware is loaded?

Firmware is loaded in coprocessor at system startup by remoteproc framework:
 From "[GIT PULL] STi DT update for v4.11 round 1" 
https://lkml.org/lkml/2017/1/12/525:
https://kernel.googlesource.com/pub/scm/linux/kernel/git/pchotard/sti/+/sti-dt-for-v4.11/arch/arm/boot/dts/stih407-family.dtsi
		st231_delta: remote-processor {
			compatible	= "st,st231-rproc";
			memory-region	= <&delta_reserved>;
			resets		= <&softreset STIH407_ST231_DMU_SOFTRESET>;
			reset-names	= "sw_reset";
			clocks		= <&clk_s_c0_flexgen CLK_ST231_DMU>;
			clock-frequency	= <600000000>;
			st,syscfg	= <&syscfg_core 0x224>;
			#mbox-cells = <1>;
			mbox-names = "vq0_rx", "vq0_tx", "vq1_rx", "vq1_tx";
			mboxes = <&mailbox0 0 0>, <&mailbox3 0 1>, <&mailbox0 0 1>, 
<&mailbox3 0 0>;
		};

>
>>
>> Thanks,
>> Mauro
>>
>> Thanks,
>> Mauro
>
>
>
> Thanks,
> Mauro
>

Thanks for all,
Hugues.