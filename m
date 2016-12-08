Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:4708 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751130AbcLHKay (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Dec 2016 05:30:54 -0500
From: Jean Christophe TROTIN <jean-christophe.trotin@st.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Yannick FERTRE <yannick.fertre@st.com>,
        Hugues FRUCHET <hugues.fruchet@st.com>
Date: Thu, 8 Dec 2016 11:30:02 +0100
Subject: Re: [PATCH v3 3/3] ARM: multi_v7_defconfig: enable
 STMicroelectronics HVA debugfs
Message-ID: <a099984f-55b1-62bf-48a2-7b265e0a8f2e@st.com>
References: <1480329054-30403-1-git-send-email-jean-christophe.trotin@st.com>
 <1480329054-30403-4-git-send-email-jean-christophe.trotin@st.com>
 <4cd00e98-5198-2c0e-4779-336f1cd32f8c@xs4all.nl>
In-Reply-To: <4cd00e98-5198-2c0e-4779-336f1cd32f8c@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

You're right: the HVA DEBUGFS config option shouldn't be enabled by default.
So, "[PATCH v3 3/3] ARM: multi_v7_defconfig: enable STMicroelectronics HVA 
debugfs" must be ignored. It will be taken into account in our configuration 
fragment.
Do you have any other remark about the patches [PATCH v3 1/3] and [PATCH v3 2/3]?
If you need a new version (v4) without the "[PATCH v3 3/3]", please let me know?

Regards,

Jean-Christophe.


On 12/05/2016 01:32 PM, Hans Verkuil wrote:
> Please provide a commit message, it shouldn't be empty.
>
> But are you sure you want to enable it in the defconfig? I think in general
> DEBUGFS config options aren't enabled by default.
>
> Regards,
>
> 	Hans
>
> On 11/28/2016 11:30 AM, Jean-Christophe Trotin wrote:
>> Signed-off-by: Jean-Christophe Trotin <jean-christophe.trotin@st.com>
>> ---
>>  arch/arm/configs/multi_v7_defconfig | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/arch/arm/configs/multi_v7_defconfig b/arch/arm/configs/multi_v7_defconfig
>> index eb14ab6..7a15107 100644
>> --- a/arch/arm/configs/multi_v7_defconfig
>> +++ b/arch/arm/configs/multi_v7_defconfig
>> @@ -563,6 +563,7 @@ CONFIG_VIDEO_SAMSUNG_S5P_JPEG=m
>>  CONFIG_VIDEO_SAMSUNG_S5P_MFC=m
>>  CONFIG_VIDEO_STI_BDISP=m
>>  CONFIG_VIDEO_STI_HVA=m
>> +CONFIG_VIDEO_STI_HVA_DEBUGFS=y
>>  CONFIG_DYNAMIC_DEBUG=y
>>  CONFIG_VIDEO_RENESAS_JPU=m
>>  CONFIG_VIDEO_RENESAS_VSP1=m
>>
>