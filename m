Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:4151 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753705AbdBHPlA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 8 Feb 2017 10:41:00 -0500
From: Hugues FRUCHET <hugues.fruchet@st.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        "kernel@stlinux.com" <kernel@stlinux.com>,
        "Benjamin Gaignard" <benjamin.gaignard@linaro.org>,
        Jean Christophe TROTIN <jean-christophe.trotin@st.com>
Subject: Re: [PATCH v7 09/10] [media] st-delta: add mjpeg support
Date: Wed, 8 Feb 2017 15:40:20 +0000
Message-ID: <02053bbd-a6bc-c8f9-7ec5-2efcbb5730a7@st.com>
References: <1486047593-18581-1-git-send-email-hugues.fruchet@st.com>
 <1486047593-18581-10-git-send-email-hugues.fruchet@st.com>
 <20170208101928.4638291e@vento.lan>
In-Reply-To: <20170208101928.4638291e@vento.lan>
Content-Language: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <D769BE0879F193429DF58509ADF245EC@st.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 02/08/2017 01:19 PM, Mauro Carvalho Chehab wrote:
> Em Thu, 2 Feb 2017 15:59:52 +0100
> Hugues Fruchet <hugues.fruchet@st.com> escreveu:
>
> I applied today this series. There's just a nitpick, that you can change
> when you submit a version 2 of the MPEG2 driver. See below:
>
>> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
>> index 2e82ec6..20b26ea 100644
>> --- a/drivers/media/platform/Kconfig
>> +++ b/drivers/media/platform/Kconfig
>> @@ -317,10 +317,20 @@ config VIDEO_STI_DELTA
>>
>>  if VIDEO_STI_DELTA
>>
>> +config VIDEO_STI_DELTA_MJPEG
>> +	bool "STMicroelectronics DELTA MJPEG support"
>> +	default y
>> +	help
>> +		Enables DELTA MJPEG hardware support.
>> +
>> +		To compile this driver as a module, choose M here:
>> +		the module will be called st-delta.
>> +
>>  config VIDEO_STI_DELTA_DRIVER
>>  	tristate
>>  	depends on VIDEO_STI_DELTA
>> -	default n
>> +	depends on VIDEO_STI_DELTA_MJPEG
>> +	default VIDEO_STI_DELTA_MJPEG
>
> Just do:
> 	default y
>
> The build system will do the right thing, as it will evaluate
> the dependencies, disabling it if no decoder is selected. That
> will avoid needing to change the default line for every new decoder
> you add.
>

Thanks Mauro,

this is done in v2 of MPEG-2 patchset.

Best regards,
Hugues.

>>  	select VIDEOBUF2_DMA_CONTIG
>>  	select V4L2_MEM2MEM_DEV
>>  	select RPMSG
>
>
> Thanks,
> Mauro
>