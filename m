Return-Path: <SRS0=l98e=O4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65134C43387
	for <linux-media@archiver.kernel.org>; Wed, 19 Dec 2018 17:09:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 29209218A6
	for <linux-media@archiver.kernel.org>; Wed, 19 Dec 2018 17:09:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nextdimension.cc header.i=@nextdimension.cc header.b="YsqACULc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729383AbeLSRJx (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 19 Dec 2018 12:09:53 -0500
Received: from goldenrod.birch.relay.mailchannels.net ([23.83.209.74]:56796
        "EHLO goldenrod.birch.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726555AbeLSRJx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Dec 2018 12:09:53 -0500
X-Sender-Id: dreamhost|x-authsender|brad@b-rad.cc
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 0ABF5683C4F;
        Wed, 19 Dec 2018 17:09:51 +0000 (UTC)
Received: from pdx1-sub0-mail-a53.g.dreamhost.com (unknown [100.96.19.78])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id 7660C683ABA;
        Wed, 19 Dec 2018 17:09:50 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|brad@b-rad.cc
Received: from pdx1-sub0-mail-a53.g.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384)
        by 0.0.0.0:2500 (trex/5.16.2);
        Wed, 19 Dec 2018 17:09:50 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|brad@b-rad.cc
X-MailChannels-Auth-Id: dreamhost
X-Tank-Name: 65174c9e6f8728e8_1545239390721_3470601801
X-MC-Loop-Signature: 1545239390721:123902661
X-MC-Ingress-Time: 1545239390720
Received: from pdx1-sub0-mail-a53.g.dreamhost.com (localhost [127.0.0.1])
        by pdx1-sub0-mail-a53.g.dreamhost.com (Postfix) with ESMTP id 29F308042B;
        Wed, 19 Dec 2018 09:09:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=nextdimension.cc; h=
        subject:to:references:from:message-id:date:mime-version
        :in-reply-to:content-type:content-transfer-encoding; s=
        nextdimension.cc; bh=SksRnFpz8FkADdKPbRayCZqM778=; b=YsqACULc6MC
        o3hCBNAL2JEiTsJi8FZ7ZF0qIK0AAK/bbQEAWPFbySwpTt79nWQiqOpjk2t9s7hp
        ppsuGM/CKcHEswivrzHI4cbKplPTSOW1A6AEuhqgNch/9EISEXrAnNeCq6+FguU6
        AfErAErtiR4BmEbMc7Q/snEc5C9ADdpU=
Received: from [192.168.0.21] (66-90-189-166.dyn.grandenetworks.net [66.90.189.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: brad@b-rad.cc)
        by pdx1-sub0-mail-a53.g.dreamhost.com (Postfix) with ESMTPSA id 8EE8880429;
        Wed, 19 Dec 2018 09:09:48 -0800 (PST)
Subject: Re: [PATCH v2] cx23885: only reset DMA on problematic CPUs
To:     Matthias Schwarzott <zzam@gentoo.org>,
        Brad Love <brad@nextdimension.cc>, linux-media@vger.kernel.org,
        mchehab@kernel.org, markus.dobel@gmx.de, alexdeucher@gmail.com
References: <20181206173204.21b9366e@coco.lan>
 <1545173976-16992-1-git-send-email-brad@nextdimension.cc>
 <adfe3a56-7a20-6935-1118-ff73f275bd6a@gentoo.org>
X-DH-BACKEND: pdx1-sub0-mail-a53
From:   Brad Love <brad@nextdimension.cc>
Openpgp: preference=signencrypt
Autocrypt: addr=brad@nextdimension.cc; prefer-encrypt=mutual; keydata=
 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
Message-ID: <3385c254-46cb-db75-ebea-bb0fca875a19@nextdimension.cc>
Date:   Wed, 19 Dec 2018 11:09:47 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <adfe3a56-7a20-6935-1118-ff73f275bd6a@gentoo.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
X-VR-OUT-STATUS: OK
X-VR-OUT-SCORE: 15
X-VR-OUT-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedtkedrudejtddgleejucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuggftfghnshhusghstghrihgsvgdpffftgfetoffjqffuvfenuceurghilhhouhhtmecufedttdenucgfrhhlucfvnfffucdludehmdenucfjughrpefuvfhfhffkffgfgggjtgfgsehtjeertddtfeejnecuhfhrohhmpeeurhgrugcunfhovhgvuceosghrrggusehnvgigthguihhmvghnshhiohhnrdgttgeqnecuffhomhgrihhnpehophgvnhgsvghntghhmhgrrhhkihhnghdrohhrghenucfkphepieeirdeltddrudekledrudeiieenucfrrghrrghmpehmohguvgepshhmthhppdhhvghloheplgduledvrdduieekrddtrddvudgnpdhinhgvthepieeirdeltddrudekledrudeiiedprhgvthhurhhnqdhprghthhepuehrrgguucfnohhvvgcuoegsrhgrugesnhgvgihtughimhgvnhhsihhonhdrtggtqedpmhgrihhlfhhrohhmpegsrhgrugesnhgvgihtughimhgvnhhsihhonhdrtggtpdhnrhgtphhtthhopeiiiigrmhesghgvnhhtohhordhorhhgnecuvehluhhsthgvrhfuihiivgeptd
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


On 19/12/2018 05.08, Matthias Schwarzott wrote:
> Am 18.12.18 um 23:59 schrieb Brad Love:
>> It is reported that commit 95f408bbc4e4 ("media: cx23885: Ryzen DMA
>> related RiSC engine stall fixes") caused regresssions with other CPUs.
>>
>> Ensure that the quirk will be applied only for the CPUs that
>> are known to cause problems.
>>
>> A module option is added for explicit control of the behaviour.
>>
>> Fixes: 95f408bbc4e4 ("media: cx23885: Ryzen DMA related RiSC engine stall fixes")
>>
>> Signed-off-by: Brad Love <brad@nextdimension.cc>
> Hi Brad,
> I found one issue. See below.
>
> Regards
> Matthias


Thanks for the catch Matthias, v3 submitted.

Cheers,

Brad



>
>> ---
>> Changes since v1:
>> - Added module option for three way control
>> - Removed '7' from pci id description, Ryzen 3 is the same id
>>
>>  drivers/media/pci/cx23885/cx23885-core.c | 54 ++++++++++++++++++++++++++++++--
>>  drivers/media/pci/cx23885/cx23885.h      |  2 ++
>>  2 files changed, 54 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/media/pci/cx23885/cx23885-core.c b/drivers/media/pci/cx23885/cx23885-core.c
>> index 39804d8..fb721c7 100644
>> --- a/drivers/media/pci/cx23885/cx23885-core.c
>> +++ b/drivers/media/pci/cx23885/cx23885-core.c
> ...
>> @@ -2058,6 +2076,36 @@ void cx23885_gpio_enable(struct cx23885_dev *dev, u32 mask, int asoutput)
>>  	/* TODO: 23-19 */
>>  }
>>  
>> +static struct {
>> +	int vendor, dev;
>> +} const broken_dev_id[] = {
>> +	/* According with
>> +	 * https://openbenchmarking.org/system/1703021-RI-AMDZEN08075/Ryzen%207%201800X/lspci,
>> +	 * 0x1451 is PCI ID for the IOMMU found on Ryzen
>> +	 */
>> +	{ PCI_VENDOR_ID_AMD, 0x1451 },
>> +};
>> +
>> +static bool cx23885_does_need_dma_reset(void)
>> +{
>> +	int i;
>> +	struct pci_dev *pdev = NULL;
>> +
>> +	if (dma_reset_workaround == 0)
>> +		return false;
>> +	else if (dma_reset_workaround == 2)
>> +		return true;
>> +
>> +	for (i = 0; i < sizeof(broken_dev_id); i++) {
> This is broken. sizeof delivers the size in bytes, not in number of
> array elements. ARRAY_SIZE is what you want.
>
>> +		pdev = pci_get_device(broken_dev_id[i].vendor, broken_dev_id[i].dev, NULL);
>> +		if (pdev) {
>> +			pci_dev_put(pdev);
>> +			return true;
>> +		}
>> +	}
>> +	return false;
>> +}
>> +
>>  static int cx23885_initdev(struct pci_dev *pci_dev,
>>  			   const struct pci_device_id *pci_id)
>>  {
>> @@ -2069,6 +2117,8 @@ static int cx23885_initdev(struct pci_dev *pci_dev,
>>  	if (NULL == dev)
>>  		return -ENOMEM;
>>  
>> +	dev->need_dma_reset = cx23885_does_need_dma_reset();
>> +
>>  	err = v4l2_device_register(&pci_dev->dev, &dev->v4l2_dev);
>>  	if (err < 0)
>>  		goto fail_free;
>> diff --git a/drivers/media/pci/cx23885/cx23885.h b/drivers/media/pci/cx23885/cx23885.h
>> index d54c7ee..cf965ef 100644
>> --- a/drivers/media/pci/cx23885/cx23885.h
>> +++ b/drivers/media/pci/cx23885/cx23885.h
>> @@ -451,6 +451,8 @@ struct cx23885_dev {
>>  	/* Analog raw audio */
>>  	struct cx23885_audio_dev   *audio_dev;
>>  
>> +	/* Does the system require periodic DMA resets? */
>> +	unsigned int		need_dma_reset:1;
>>  };
>>  
>>  static inline struct cx23885_dev *to_cx23885(struct v4l2_device *v4l2_dev)
>>
