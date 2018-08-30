Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:54488 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726878AbeH3TnV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Aug 2018 15:43:21 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w7UFdXBv012989
        for <linux-media@vger.kernel.org>; Thu, 30 Aug 2018 11:40:36 -0400
Received: from e36.co.us.ibm.com (e36.co.us.ibm.com [32.97.110.154])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2m6gjarqrw-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-media@vger.kernel.org>; Thu, 30 Aug 2018 11:40:36 -0400
Received: from localhost
        by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-media@vger.kernel.org> from <eajames@linux.vnet.ibm.com>;
        Thu, 30 Aug 2018 09:40:35 -0600
Subject: Re: [PATCH 4/4] media: platform: Add Aspeed Video Engine driver
To: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-media <linux-media@vger.kernel.org>,
        linux-aspeed@lists.ozlabs.org, openbmc@lists.ozlabs.org,
        andrew@aj.id.au, Mauro Carvalho Chehab <mchehab@kernel.org>,
        joel@jms.id.au, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, linux-clk@vger.kernel.org,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
References: <1535576973-8067-1-git-send-email-eajames@linux.vnet.ibm.com>
 <1535576973-8067-5-git-send-email-eajames@linux.vnet.ibm.com>
 <CAAEAJfBpmFPLTMAr+Azc-53JXHPkCU4bjtwqE6nDWUvm=J_x-A@mail.gmail.com>
From: Eddie James <eajames@linux.vnet.ibm.com>
Date: Thu, 30 Aug 2018 10:40:21 -0500
MIME-Version: 1.0
In-Reply-To: <CAAEAJfBpmFPLTMAr+Azc-53JXHPkCU4bjtwqE6nDWUvm=J_x-A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Message-Id: <7cb0c2f0-cc12-81a6-a858-40776ec5904c@linux.vnet.ibm.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 08/29/2018 07:52 PM, Ezequiel Garcia wrote:
> Hi Eddie,
>
> On 29 August 2018 at 18:09, Eddie James <eajames@linux.vnet.ibm.com> wrote:
>> The Video Engine (VE) embedded in the Aspeed AST2400 and AST2500 SOCs
>> can capture and compress video data from digital or analog sources. With
>> the Aspeed chip acting a service processor, the Video Engine can capture
>> the host processor graphics output.
>>
>> Add a V4L2 driver to capture video data and compress it to JPEG images,
>> making the data available through a standard read interface.
>>
>> Signed-off-by: Eddie James <eajames@linux.vnet.ibm.com>
>> ---
>>   drivers/media/platform/Kconfig        |    8 +
>>   drivers/media/platform/Makefile       |    1 +
>>   drivers/media/platform/aspeed-video.c | 1307 +++++++++++++++++++++++++++++++++
>>   3 files changed, 1316 insertions(+)
>>   create mode 100644 drivers/media/platform/aspeed-video.c
>>
>> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
>> index 94c1fe0..e599245 100644
>> --- a/drivers/media/platform/Kconfig
>> +++ b/drivers/media/platform/Kconfig
>> @@ -32,6 +32,14 @@ source "drivers/media/platform/davinci/Kconfig"
>>
>>   source "drivers/media/platform/omap/Kconfig"
>>
>> +config VIDEO_ASPEED
>> +       tristate "Aspeed AST2400 and AST2500 Video Engine driver"
>> +       depends on VIDEO_V4L2
> It seems you are not using videobuf2. I think it should simplify the read
> I/O part and at the same time expose the other capture methods.

Hi,

Well I'm not sure it would simplify the read interface; it's quite 
simple as it is, both in the driver and to set up in user-space.

I did get streaming I/O working but found the performance significantly 
worse than simple read calls, and therefore not worth the additional 
complexity.

Is it required that I support streaming?

Thanks,
Eddie

>
> There are plenty of examples to follow.
>
> Regards,
> Eze
>
