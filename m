Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog123.obsmtp.com ([74.125.149.149]:37431 "EHLO
	na3sys009aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754154Ab2JEN4Z convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Oct 2012 09:56:25 -0400
From: Albert Wang <twang13@marvell.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: "corbet@lwn.net" <corbet@lwn.net>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Libin Yang <lbyang@marvell.com>
Date: Fri, 5 Oct 2012 06:14:19 -0700
Subject: RE: [PATCH 1/4] [media] mmp: add register definition for marvell
 ccic
Message-ID: <477F20668A386D41ADCC57781B1F7043083B6575C0@SC-VEXCH1.marvell.com>
References: <1348840031-21357-1-git-send-email-twang13@marvell.com>
 <Pine.LNX.4.64.1209291922550.20390@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1209291922550.20390@axis700.grange>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>From: Guennadi Liakhovetski [mailto:g.liakhovetski@gmx.de]
>Sent: Sunday, 30 September, 2012 01:26
>To: Albert Wang
>Cc: corbet@lwn.net; linux-media@vger.kernel.org; Libin Yang
>Subject: Re: [PATCH 1/4] [media] mmp: add register definition for marvell ccic
>
>On Fri, 28 Sep 2012, Albert Wang wrote:
>
>> From: Libin Yang <lbyang@marvell.com>
>>
>> This patch adds the definition of CCIC1/2 Clock Reset register address
>>
>> Signed-off-by: Albert Wang <twang13@marvell.com>
>> Signed-off-by: Libin Yang <lbyang@marvell.com>
>> ---
>>  arch/arm/mach-mmp/include/mach/regs-apmu.h |    3 ++-
>>  1 files changed, 2 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/arm/mach-mmp/include/mach/regs-apmu.h
>> b/arch/arm/mach-mmp/include/mach/regs-apmu.h
>> index 7af8deb..f2cf231 100755
>> --- a/arch/arm/mach-mmp/include/mach/regs-apmu.h
>> +++ b/arch/arm/mach-mmp/include/mach/regs-apmu.h
>> @@ -16,7 +16,8 @@
>>  /* Clock Reset Control */
>>  #define APMU_IRE	APMU_REG(0x048)
>>  #define APMU_LCD	APMU_REG(0x04c)
>> -#define APMU_CCIC	APMU_REG(0x050)
>> +#define APMU_CCIC_RST	APMU_REG(0x050)
>> +#define APMU_CCIC2_RST	APMU_REG(0x0f4)
>
>Assuming APMU_CCIC hasn't been used until now, changing its name is ok, but I think,
>registers in this list are ordered by their addresses, so, your addition should go between
>
>#define APMU_SDH3	APMU_REG(0x0ec)
>#define APMU_ETH	APMU_REG(0x0fc)
>

Sorry for late response.
Sure, you are right, we will change it in Version 2

>Thanks
>Guennadi
>
>>  #define APMU_SDH0	APMU_REG(0x054)
>>  #define APMU_SDH1	APMU_REG(0x058)
>>  #define APMU_USB	APMU_REG(0x05c)
>> --
>> 1.7.0.4
>>
>
>---
>Guennadi Liakhovetski, Ph.D.
>Freelance Open-Source Software Developer
>http://www.open-technology.de/

Thanks
Albert Wang
86-21-61092656
