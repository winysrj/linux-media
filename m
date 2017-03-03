Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f174.google.com ([209.85.220.174]:32768 "EHLO
        mail-qk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752380AbdCCSlf (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 3 Mar 2017 13:41:35 -0500
Received: by mail-qk0-f174.google.com with SMTP id n127so190428846qkf.0
        for <linux-media@vger.kernel.org>; Fri, 03 Mar 2017 10:41:29 -0800 (PST)
Subject: Re: [RFC PATCH 03/12] staging: android: ion: Duplicate sg_table
To: Hillf Danton <hillf.zj@alibaba-inc.com>,
        'Sumit Semwal' <sumit.semwal@linaro.org>,
        'Riley Andrews' <riandrews@android.com>, arve@android.com
References: <1488491084-17252-1-git-send-email-labbott@redhat.com>
 <1488491084-17252-4-git-send-email-labbott@redhat.com>
 <07df01d293f6$bcfb4f30$36f1ed90$@alibaba-inc.com>
Cc: romlem@google.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
        'Greg Kroah-Hartman' <gregkh@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        'Brian Starkey' <brian.starkey@arm.com>,
        'Daniel Vetter' <daniel.vetter@intel.com>,
        'Mark Brown' <broonie@kernel.org>,
        'Benjamin Gaignard' <benjamin.gaignard@linaro.org>,
        linux-mm@kvack.org
From: Laura Abbott <labbott@redhat.com>
Message-ID: <59f69b1b-0a10-01e9-3e64-387d8f123674@redhat.com>
Date: Fri, 3 Mar 2017 10:41:25 -0800
MIME-Version: 1.0
In-Reply-To: <07df01d293f6$bcfb4f30$36f1ed90$@alibaba-inc.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/03/2017 12:18 AM, Hillf Danton wrote:
> 
> On March 03, 2017 5:45 AM Laura Abbott wrote: 
>>
>> +static struct sg_table *dup_sg_table(struct sg_table *table)
>> +{
>> +	struct sg_table *new_table;
>> +	int ret, i;
>> +	struct scatterlist *sg, *new_sg;
>> +
>> +	new_table = kzalloc(sizeof(*new_table), GFP_KERNEL);
>> +	if (!new_table)
>> +		return ERR_PTR(-ENOMEM);
>> +
>> +	ret = sg_alloc_table(new_table, table->nents, GFP_KERNEL);
>> +	if (ret) {
>> +		kfree(table);
> 
> Free new table?
> 
>> +		return ERR_PTR(-ENOMEM);
>> +	}
>> +
>> +	new_sg = new_table->sgl;
>> +	for_each_sg(table->sgl, sg, table->nents, i) {
>> +		memcpy(new_sg, sg, sizeof(*sg));
>> +		sg->dma_address = 0;
>> +		new_sg = sg_next(new_sg);
>> +	}
>> +
> 
> Do we need a helper, sg_copy_table(dst_table, src_table)?
> 
>> +	return new_table;
>> +}
>> +

Yes, that would probably be good since I've seen this
code elsewhere.

Thanks,
Laura
