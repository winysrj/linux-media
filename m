Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:63220 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750849AbcLENcZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Dec 2016 08:32:25 -0500
From: Hugues FRUCHET <hugues.fruchet@st.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Jean Christophe TROTIN <jean-christophe.trotin@st.com>
Date: Mon, 5 Dec 2016 14:22:29 +0100
Subject: Re: [PATCH v3 07/10] [media] st-delta: rpmsg ipc support
Message-ID: <5a588e95-4086-8cdb-9383-33bbcec3ddfe@st.com>
References: <1479830007-29767-1-git-send-email-hugues.fruchet@st.com>
 <1479830007-29767-8-git-send-email-hugues.fruchet@st.com>
 <70e1c120-4b7b-bde9-0f82-38e89452c2ea@xs4all.nl>
In-Reply-To: <70e1c120-4b7b-bde9-0f82-38e89452c2ea@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks Hans, I will change depends to select.
BR,
Hugues.

On 12/05/2016 11:47 AM, Hans Verkuil wrote:
> On 11/22/2016 04:53 PM, Hugues Fruchet wrote:
>> IPC (Inter Process Communication) support for communication with
>> DELTA coprocessor firmware using rpmsg kernel framework.
>> Based on 4 services open/set_stream/decode/close and their associated
>> rpmsg messages.
>> The messages structures are duplicated on both host and firmware
>> side and are packed (use only of 32 bits size fields in messages
>> structures to ensure packing).
>> Each service is synchronous; service returns only when firmware
>> acknowledges the associated command message.
>> Due to significant parameters size exchanged from host to copro,
>> parameters are not inserted in rpmsg messages. Instead, parameters are
>> stored in physical memory shared between host and coprocessor.
>> Memory is non-cacheable, so no special operation is required
>> to ensure memory coherency on host and on coprocessor side.
>> Multi-instance support and re-entrance are ensured using host_hdl and
>> copro_hdl in message header exchanged between both host and coprocessor.
>> This avoids to manage tables on both sides to get back the running context
>> of each instance.
>>
>> Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
>> ---
>>  drivers/media/platform/Kconfig                |   1 +
>>  drivers/media/platform/sti/delta/Makefile     |   2 +-
>>  drivers/media/platform/sti/delta/delta-ipc.c  | 590 ++++++++++++++++++++++++++
>>  drivers/media/platform/sti/delta/delta-ipc.h  |  76 ++++
>>  drivers/media/platform/sti/delta/delta-v4l2.c |  11 +
>>  drivers/media/platform/sti/delta/delta.h      |  21 +
>>  6 files changed, 700 insertions(+), 1 deletion(-)
>>  create mode 100644 drivers/media/platform/sti/delta/delta-ipc.c
>>  create mode 100644 drivers/media/platform/sti/delta/delta-ipc.h
>>
>> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
>> index f494f01..5519442 100644
>> --- a/drivers/media/platform/Kconfig
>> +++ b/drivers/media/platform/Kconfig
>> @@ -303,6 +303,7 @@ config VIDEO_STI_DELTA
>>  	depends on VIDEO_DEV && VIDEO_V4L2
>>  	depends on ARCH_STI || COMPILE_TEST
>>  	depends on HAS_DMA
>> +	depends on RPMSG
>
> This should be 'select', not 'depends on'.
>
>>  	select VIDEOBUF2_DMA_CONTIG
>>  	select V4L2_MEM2MEM_DEV
>>  	help
>
> Can you make a v3.1 of this patch correcting this?
>
> Regards,
>
> 	Hans
>