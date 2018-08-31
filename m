Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:34778 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727428AbeHaXjI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 31 Aug 2018 19:39:08 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w7VJT9nO008714
        for <linux-media@vger.kernel.org>; Fri, 31 Aug 2018 15:30:12 -0400
Received: from e11.ny.us.ibm.com (e11.ny.us.ibm.com [129.33.205.201])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2m78w9y90u-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-media@vger.kernel.org>; Fri, 31 Aug 2018 15:30:12 -0400
Received: from localhost
        by e11.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-media@vger.kernel.org> from <eajames@linux.vnet.ibm.com>;
        Fri, 31 Aug 2018 15:30:11 -0400
Subject: Re: [PATCH 0/4] media: platform: Add Aspeed Video Engine driver
To: Stephen Boyd <sboyd@kernel.org>, linux-kernel@vger.kernel.org
Cc: linux-media@vger.kernel.org, linux-aspeed@lists.ozlabs.org,
        openbmc@lists.ozlabs.org, andrew@aj.id.au, mchehab@kernel.org,
        joel@jms.id.au, robh+dt@kernel.org, mark.rutland@arm.com,
        devicetree@vger.kernel.org, linux-clk@vger.kernel.org,
        mturquette@baylibre.com, linux-arm-kernel@lists.infradead.org
References: <1535576973-8067-1-git-send-email-eajames@linux.vnet.ibm.com>
 <153573819126.93865.1884182656081956202@swboyd.mtv.corp.google.com>
From: Eddie James <eajames@linux.vnet.ibm.com>
Date: Fri, 31 Aug 2018 14:30:02 -0500
MIME-Version: 1.0
In-Reply-To: <153573819126.93865.1884182656081956202@swboyd.mtv.corp.google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Message-Id: <a959a032-6817-dcb4-2c5f-b4bd17fc1c8b@linux.vnet.ibm.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 08/31/2018 12:56 PM, Stephen Boyd wrote:
> Quoting Eddie James (2018-08-29 14:09:29)
>> The Video Engine (VE) embedded in the Aspeed AST2400 and AST2500 SOCs
>> can capture and compress video data from digital or analog sources. With
>> the Aspeed chip acting as a service processor, the Video Engine can
>> capture the host processor graphics output.
>>
>> This series adds a V4L2 driver for the VE, providing a read() interface
>> only. The driver triggers the hardware to capture the host graphics output
>> and compress it to JPEG format.
>>
>> Testing on an AST2500 determined that the videobuf/streaming/mmap interface
>> was significantly slower than the simple read() interface, so I have not
>> included the streaming part.
>>
>> It's also possible to use an automatic mode for the VE such that
>> re-triggering the HW every frame isn't necessary. However this wasn't
>> reliable on the AST2400, and probably used more CPU anyway due to excessive
>> interrupts. It was approximately 15% faster.
>>
>> The series also adds the necessary parent clock definitions to the Aspeed
>> clock driver, with both a mux and clock divider.
> Please let me know your merge strategy here. I can ack the clk patches
> because they look fine from high-level clk driver perspective (maybe
> Joel can take a closer look) or I can merge the patches into clk-next
> and get them into next release while the video driver gets reviewed.

Thanks for taking a look! Probably preferable to get the clk patches 
into clk-next first (though Joel reviewing would be great). I just put 
everything in the same set for the sake of explaining the necessity of 
the clk changes.

Thanks,
Eddie

>
