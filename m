Return-Path: <SRS0=AYlV=OX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B63BC43387
	for <linux-media@archiver.kernel.org>; Fri, 14 Dec 2018 15:41:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 505C8206C0
	for <linux-media@archiver.kernel.org>; Fri, 14 Dec 2018 15:41:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727227AbeLNPly (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 14 Dec 2018 10:41:54 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:35634 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726813AbeLNPly (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Dec 2018 10:41:54 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id wBEFYHov056645
        for <linux-media@vger.kernel.org>; Fri, 14 Dec 2018 10:41:53 -0500
Received: from e11.ny.us.ibm.com (e11.ny.us.ibm.com [129.33.205.201])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2pcf4f0pxh-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-media@vger.kernel.org>; Fri, 14 Dec 2018 10:41:53 -0500
Received: from localhost
        by e11.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-media@vger.kernel.org> from <eajames@linux.ibm.com>;
        Fri, 14 Dec 2018 15:41:52 -0000
Received: from b01cxnp22035.gho.pok.ibm.com (9.57.198.25)
        by e11.ny.us.ibm.com (146.89.104.198) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 14 Dec 2018 15:41:49 -0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id wBEFfmwl5570590
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 14 Dec 2018 15:41:48 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 968C1B206B;
        Fri, 14 Dec 2018 15:41:48 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B8755B206A;
        Fri, 14 Dec 2018 15:41:47 +0000 (GMT)
Received: from oc6728276242.ibm.com (unknown [9.85.180.238])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 14 Dec 2018 15:41:47 +0000 (GMT)
Subject: Re: [PATCH v8 2/2] media: platform: Add Aspeed Video Engine driver
To:     Joel Stanley <joel@jms.id.au>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree <devicetree@vger.kernel.org>,
        linux-aspeed@lists.ozlabs.org, hverkuil@xs4all.nl,
        Rob Herring <robh+dt@kernel.org>, mchehab@kernel.org,
        linux-media@vger.kernel.org
References: <1544547421-25724-1-git-send-email-eajames@linux.ibm.com>
 <1544547421-25724-3-git-send-email-eajames@linux.ibm.com>
 <CACPK8XdQbq-9MbP7uMemyp0=Q+t1qnWNREdZRiyEcrART9vRig@mail.gmail.com>
From:   Eddie James <eajames@linux.ibm.com>
Date:   Fri, 14 Dec 2018 09:41:47 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <CACPK8XdQbq-9MbP7uMemyp0=Q+t1qnWNREdZRiyEcrART9vRig@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
x-cbid: 18121415-2213-0000-0000-0000032B0C75
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00010224; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000271; SDB=6.01131701; UDB=6.00588163; IPR=6.00911833;
 MB=3.00024690; MTD=3.00000008; XFM=3.00000015; UTC=2018-12-14 15:41:51
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 18121415-2214-0000-0000-00005C9A90F4
Message-Id: <34bb2594-b0ab-f3a0-4d46-ba9a870c958b@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2018-12-14_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1812140137
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org



On 12/13/2018 07:09 PM, Joel Stanley wrote:
> On Wed, 12 Dec 2018 at 04:09, Eddie James <eajames@linux.ibm.com> wrote:
>> The Video Engine (VE) embedded in the Aspeed AST2400 and AST2500 SOCs
>> can capture and compress video data from digital or analog sources. With
>> the Aspeed chip acting a service processor, the Video Engine can capture
>> the host processor graphics output.
>> +ASPEED VIDEO ENGINE DRIVER
>> +M:     Eddie James <eajames@linux.ibm.com>
>> +L:     linux-media@vger.kernel.org
>> +L:     openbmc@lists.ozlabs.org (moderated for non-subscribers)
> We tend to use the linux-aspeed list for upstream kernel discussions.
> Up to you if you want to use the openbmc list though.
>
>>   source "drivers/media/platform/omap/Kconfig"
>>
>> +config VIDEO_ASPEED
>> +       tristate "Aspeed AST2400 and AST2500 Video Engine driver"
>> +       depends on VIDEO_V4L2
>> +       select VIDEOBUF2_DMA_CONTIG
>> +       help
>> +         Support for the Aspeed Video Engine (VE) embedded in the Aspeed
>> +         AST2400 and AST2500 SOCs. The VE can capture and compress video data
>> +         from digital or analog sources.
> This might need updating in response to my questions below about
> ast2400 testing.
>
>> +++ b/drivers/media/platform/aspeed-video.c
>> @@ -0,0 +1,1729 @@
>> +// SPDX-License-Identifier: GPL-2.0+
> You need to put this there as well:
>
> // Copyright 2018 IBM Corp
>
>
>> +static int aspeed_video_init(struct aspeed_video *video)
>> +{
>> +       int irq;
>> +       int rc;
>> +       struct device *dev = video->dev;
>> +
>> +       irq = irq_of_parse_and_map(dev->of_node, 0);
>> +       if (!irq) {
>> +               dev_err(dev, "Unable to find IRQ\n");
>> +               return -ENODEV;
>> +       }
>> +
>> +       rc = devm_request_irq(dev, irq, aspeed_video_irq, IRQF_SHARED,
> The datasheet indicates this IRQ is for the video engline only, so I
> don't think you want IRQF_SHARED.
>
>> +                             DEVICE_NAME, video);
>> +       if (rc < 0) {
>> +               dev_err(dev, "Unable to request IRQ %d\n", irq);
>> +               return rc;
>> +       }
>> +
>> +       video->eclk = devm_clk_get(dev, "eclk");
>> +       if (IS_ERR(video->eclk)) {
>> +               dev_err(dev, "Unable to get ECLK\n");
>> +               return PTR_ERR(video->eclk);
>> +       }
>> +
>> +       video->vclk = devm_clk_get(dev, "vclk");
>> +       if (IS_ERR(video->vclk)) {
>> +               dev_err(dev, "Unable to get VCLK\n");
>> +               return PTR_ERR(video->vclk);
>> +       }
>> +
>> +       video->rst = devm_reset_control_get_exclusive(dev, NULL);
>> +       if (IS_ERR(video->rst)) {
>> +               dev_err(dev, "Unable to get VE reset\n");
>> +               return PTR_ERR(video->rst);
>> +       }
> As discussed in the clock driver, this can go as you've already
> released the reset when enabling the eclk.

I use the reset control by itself during a resolution change, so I would 
like to have it available.

>
> However, you're requesting the clock without enabling it. You need to
> do a clk_prepare_enable().

That's because the clock is only enabled when the device is opened. No 
reason to turn it on at boot time.

>
>> +
>> +       rc = of_reserved_mem_device_init(dev);
>> +       if (rc) {
>> +               dev_err(dev, "Unable to reserve memory\n");
>> +               return rc;
>> +       }
>> +
>> +       rc = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(32));
>> +       if (rc) {
>> +               dev_err(dev, "Failed to set DMA mask\n");
>> +               of_reserved_mem_device_release(dev);
>> +               return rc;
>> +       }
>> +
>> +       if (!aspeed_video_alloc_buf(video, &video->jpeg,
>> +                                   VE_JPEG_HEADER_SIZE)) {
>> +               dev_err(dev, "Failed to allocate DMA for JPEG header\n");
>> +               of_reserved_mem_device_release(dev);
>> +               return rc;
>> +       }
>> +
>> +       aspeed_video_init_jpeg_table(video->jpeg.virt, video->yuv420);
>> +
>> +       return 0;
>> +}
>> +
>> +static const struct of_device_id aspeed_video_of_match[] = {
>> +       { .compatible = "aspeed,ast2400-video-engine" },
> I noticed the clock driver did not have the changed required for the
> 2400. Have you tested this on the ast2400?

The clocking setup is different on the ast2400. Xiuzhi on the openbmc 
list has been testing on the ast2400 successfully.

Thanks,
Eddie

>
>
>> +       { .compatible = "aspeed,ast2500-video-engine" },
>> +       {}
>> +};
>> +MODULE_DEVICE_TABLE(of, aspeed_video_of_match);
>> +
>> +static struct platform_driver aspeed_video_driver = {
>> +       .driver = {
>> +               .name = DEVICE_NAME,
>> +               .of_match_table = aspeed_video_of_match,
>> +       },
>> +       .probe = aspeed_video_probe,
>> +       .remove = aspeed_video_remove,
>> +};

