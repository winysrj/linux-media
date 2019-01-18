Return-Path: <SRS0=Cp5C=P2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04A09C43387
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 10:08:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CCFFA2087E
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 10:08:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727091AbfARKH7 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 18 Jan 2019 05:07:59 -0500
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:47431 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726309AbfARKH7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Jan 2019 05:07:59 -0500
Received: from [IPv6:2001:983:e9a7:1:3849:86c5:b8c2:266c] ([IPv6:2001:983:e9a7:1:3849:86c5:b8c2:266c])
        by smtp-cloud9.xs4all.net with ESMTPA
        id kR42gcVMZaxzfkR43gp1Th; Fri, 18 Jan 2019 11:07:57 +0100
Subject: Re: [PATCH] media: fsl-viu: Use proper check for presence of
 {out,in}_be32()
To:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, linuxppc-dev@lists.ozlabs.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1528451328-21316-1-git-send-email-geert@linux-m68k.org>
 <5948eb0d-410d-5bc6-a0f3-ffcaa4b3f975@xs4all.nl>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <d30d5bcd-8719-ac59-adf5-08c9576be759@xs4all.nl>
Date:   Fri, 18 Jan 2019 11:07:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <5948eb0d-410d-5bc6-a0f3-ffcaa4b3f975@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfJBvqnim0n3FiepnZVYwwrxC+M3BQzdtCudOApnWUjDDxJHXRO6ocF531m8WbV7oAY+a9B3lvJc1eh03fcE/X2Oid16NbmqAM/zASprMRO71/5FUA0At
 jrVePY8qwNTe19vrznBTOCWa5R1Jscq/lNsTrkBL7nDfdJ+brQ7gbpmhn5yqqOLtoU8TKyPdQTSAvB54HT8D4unFXaZMlUg4DelmxUMbD5kRWRAmAPbcPxqo
 bJh5FomLJdagmQu7y+R9SWw7IDPyumNMnX8sFPrWRA4AZFF2CyizL3zGSU4mFOrPubimBIa/KAgS6pseyquHvrFsNQGtG695JF00Z8NCE8ZkZAORAEXcQnPY
 PJGtGiY52ejVRUJQN9JkFPNLcK1oaNt/x37fZP9otTTCl7q6kRkfgE37sVtGX8x8f2rFqF9rUcLXCCoJtzUHH9j7txzxq6oyKxF2gKAFBAwwOFY30/YY9WAl
 EtuRMmTqwv2CimFlpCxy6Nc409fs8IwdxaBSo4G2PZBTDO60F8Ko8p4+aTLRGKUJA/hLkHpc9IiOr65I
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Geert,

This patch is still in my patchwork todo list, and I wonder who will pick this up,
especially the change to arch/powerpc/include/asm/io.h.

Wouldn't it be easier to just fix this in fsl-viu.c only by doing this:

#ifndef CONFIG_PPC
#ifndef out_be32
#define out_be32(v, a)  iowrite32be(a, (void __iomem *)v)
#endif
#ifndef in_be32
#define in_be32(a)      ioread32be((void __iomem *)a)
#endif
#endif

Basically just your patch, but without removing #ifndef CONFIG_PPC.

That way there is no need to touch arch/powerpc/include/asm/io.h.

Regards,

	Hans

On 6/15/18 10:10 AM, Hans Verkuil wrote:
> On 08/06/18 11:48, Geert Uytterhoeven wrote:
>> When compile-testing on m68k or microblaze:
>>
>>     drivers/media/platform/fsl-viu.c:41:1: warning: "out_be32" redefined
>>     drivers/media/platform/fsl-viu.c:42:1: warning: "in_be32" redefined
>>
>> Fix this by replacing the check for PowerPC by checks for the presence
>> of {out,in}_be32().
>>
>> As PowerPC implements the be32 accessors using inline functions instead
>> of macros, identity definions are added for all accessors to make the
>> above checks work.
>>
>> Fixes: 29d750686331a1a9 ("media: fsl-viu: allow building it with COMPILE_TEST")
>> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> 
> Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Should this go through the media tree or powerpc tree? Either way works for me.
> 
> Regards,
> 
> 	Hans
> 
>> ---
>> Compile-tested on m68k, microblaze, and powerpc.
>> Assembler output before/after compared for powerpc.
>> ---
>>  arch/powerpc/include/asm/io.h    | 14 ++++++++++++++
>>  drivers/media/platform/fsl-viu.c |  4 +++-
>>  2 files changed, 17 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/powerpc/include/asm/io.h b/arch/powerpc/include/asm/io.h
>> index e0331e7545685c5f..3741183ae09349f1 100644
>> --- a/arch/powerpc/include/asm/io.h
>> +++ b/arch/powerpc/include/asm/io.h
>> @@ -222,6 +222,20 @@ static inline void out_be64(volatile u64 __iomem *addr, u64 val)
>>  #endif
>>  #endif /* __powerpc64__ */
>>  
>> +#define in_be16 in_be16
>> +#define in_be32 in_be32
>> +#define in_be64 in_be64
>> +#define in_le16 in_le16
>> +#define in_le32 in_le32
>> +#define in_le64 in_le64
>> +
>> +#define out_be16 out_be16
>> +#define out_be32 out_be32
>> +#define out_be64 out_be64
>> +#define out_le16 out_le16
>> +#define out_le32 out_le32
>> +#define out_le64 out_le64
>> +
>>  /*
>>   * Low level IO stream instructions are defined out of line for now
>>   */
>> diff --git a/drivers/media/platform/fsl-viu.c b/drivers/media/platform/fsl-viu.c
>> index e41510ce69a40815..5d5e030c9c980647 100644
>> --- a/drivers/media/platform/fsl-viu.c
>> +++ b/drivers/media/platform/fsl-viu.c
>> @@ -37,8 +37,10 @@
>>  #define VIU_VERSION		"0.5.1"
>>  
>>  /* Allow building this driver with COMPILE_TEST */
>> -#ifndef CONFIG_PPC
>> +#ifndef out_be32
>>  #define out_be32(v, a)	iowrite32be(a, (void __iomem *)v)
>> +#endif
>> +#ifndef in_be32
>>  #define in_be32(a)	ioread32be((void __iomem *)a)
>>  #endif
>>  
>>
> 
> 

