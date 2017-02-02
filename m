Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:35377 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751147AbdBBKhH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 2 Feb 2017 05:37:07 -0500
From: Patrice CHOTARD <patrice.chotard@st.com>
To: Peter Griffin <peter.griffin@linaro.org>,
        Hugues FRUCHET <hugues.fruchet@st.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
        "kernel@stlinux.com" <kernel@stlinux.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [STLinux Kernel] [PATCH v6 04/10] [media] MAINTAINERS: add
 st-delta driver
Date: Thu, 2 Feb 2017 10:36:56 +0000
Message-ID: <05e502ef-b4fc-2233-1a65-b361bcd49d82@st.com>
References: <1485965011-17388-1-git-send-email-hugues.fruchet@st.com>
 <1485965011-17388-5-git-send-email-hugues.fruchet@st.com>
 <20170201182238.GF31988@griffinp-ThinkPad-X1-Carbon-2nd>
In-Reply-To: <20170201182238.GF31988@griffinp-ThinkPad-X1-Carbon-2nd>
Content-Language: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <F512A3743B727B4B9EF6499857673FF4@st.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Peter

On 02/01/2017 07:22 PM, Peter Griffin wrote:
> Hi Hugues,
>
> On Wed, 01 Feb 2017, Hugues Fruchet wrote:
>
>> Add entry for the STMicroelectronics DELTA driver.
>>
>> Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
>> ---
>>  MAINTAINERS | 8 ++++++++
>>  1 file changed, 8 insertions(+)
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index cfff2c9..38cc652 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -2429,6 +2429,14 @@ W:	https://linuxtv.org
>>  S:	Supported
>>  F:	drivers/media/platform/sti/bdisp
>>
>> +DELTA ST MEDIA DRIVER
>> +M:	Hugues Fruchet <hugues.fruchet@st.com>
>> +L:	linux-media@vger.kernel.org
>
> Would be useful to also include kernel@stlinux.com mailing list.

This mailing list was expected to be disabled on 31th December as 
STMicroelectronics stopped the contract with the service provider but 
..... the mailing list is still alive.

We are looking for a replacement solution and then we will update the 
maintainers files

Patrice

>
> Apart from that:
>
> Acked-by: Peter Griffin <peter.griffin@linaro.org>
>
>> +T:	git git://linuxtv.org/media_tree.git
>> +W:	https://linuxtv.org
>> +S:	Supported
>> +F:	drivers/media/platform/sti/delta
>> +
>>  BEFS FILE SYSTEM
>>  M:	Luis de Bethencourt <luisbg@osg.samsung.com>
>>  M:	Salah Triki <salah.triki@gmail.com>
>
> _______________________________________________
> Kernel mailing list
> Kernel@stlinux.com
> http://www.stlinux.com/mailman/listinfo/kernel
>