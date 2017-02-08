Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:52879 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S933129AbdBHPlU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 8 Feb 2017 10:41:20 -0500
From: Hugues FRUCHET <hugues.fruchet@st.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        "kernel@stlinux.com" <kernel@stlinux.com>,
        "Benjamin Gaignard" <benjamin.gaignard@linaro.org>,
        Jean Christophe TROTIN <jean-christophe.trotin@st.com>
Subject: Re: [PATCH v1 3/3] [media] st-delta: add mpeg2 support
Date: Wed, 8 Feb 2017 15:41:15 +0000
Message-ID: <752a636d-2563-e2a4-0cec-1e283238c558@st.com>
References: <1485773849-23945-1-git-send-email-hugues.fruchet@st.com>
 <1485773849-23945-4-git-send-email-hugues.fruchet@st.com>
 <20170208102259.1d5dcb8b@vento.lan>
In-Reply-To: <20170208102259.1d5dcb8b@vento.lan>
Content-Language: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <E8953D0E66B8144EACE617DCBA5A5C4A@st.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 02/08/2017 01:22 PM, Mauro Carvalho Chehab wrote:
> Em Mon, 30 Jan 2017 11:57:29 +0100
> Hugues Fruchet <hugues.fruchet@st.com> escreveu:
>
>> Adds support of DELTA MPEG-2 video decoder back-end,
>> implemented by calling MPEG2_TRANSFORMER0 firmware
>> using RPMSG IPC communication layer.
>> MPEG-2 decoder back-end is a stateless decoder which
>> require specific parsing metadata in access unit
>> in order to complete decoding.
>>
>> Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
>> ---
>>  drivers/media/platform/Kconfig                     |    6 +
>>  drivers/media/platform/sti/delta/Makefile          |    3 +
>>  drivers/media/platform/sti/delta/delta-cfg.h       |    5 +
>>  drivers/media/platform/sti/delta/delta-mpeg2-dec.c | 1392 ++++++++++++++++++++
>>  drivers/media/platform/sti/delta/delta-mpeg2-fw.h  |  415 ++++++
>>  drivers/media/platform/sti/delta/delta-v4l2.c      |    4 +
>>  6 files changed, 1825 insertions(+)
>>  create mode 100644 drivers/media/platform/sti/delta/delta-mpeg2-dec.c
>>  create mode 100644 drivers/media/platform/sti/delta/delta-mpeg2-fw.h
>>
>> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
>> index 9e71a7b..0472939 100644
>> --- a/drivers/media/platform/Kconfig
>> +++ b/drivers/media/platform/Kconfig
>> @@ -323,6 +323,12 @@ config VIDEO_STI_DELTA_MJPEG
>>  	help
>>  		Enables DELTA MJPEG hardware support.
>>
>> +config VIDEO_STI_DELTA_MPEG2
>> +	bool "STMicroelectronics DELTA MPEG2/MPEG1 support"
>> +	default y
>> +	help
>> +		Enables DELTA MPEG2 hardware support.
>> +
>>  endif # VIDEO_STI_DELTA
>
> This patch needs to be rebased, as you need to adjust the dependencies
> on VIDEO_STI_DELTA_DRIVER for it to depend also on this driver.
>
> Regards,
> Mauro
>
>
> Thanks,
> Mauro
>

Thanks Mauro,

v2 has been pushed accordingly.

Best regards,
Hugues.