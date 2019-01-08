Return-Path: <SRS0=gjtM=PQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66CE6C43387
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 04:05:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B4C02087F
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 04:05:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727381AbfAHEFA (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 7 Jan 2019 23:05:00 -0500
Received: from mga03.intel.com ([134.134.136.65]:59342 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727246AbfAHEFA (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 7 Jan 2019 23:05:00 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Jan 2019 20:04:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,452,1539673200"; 
   d="scan'208";a="125057652"
Received: from ipu5-build.bj.intel.com (HELO [10.238.232.171]) ([10.238.232.171])
  by orsmga001.jf.intel.com with ESMTP; 07 Jan 2019 20:04:55 -0800
Subject: Re: [PATCH -next] media: staging/intel-ipu3: Fix err handle of
 ipu3_css_find_binary
To:     Sakari Ailus <sakari.ailus@linux.intel.com>
Cc:     YueHaibing <yuehaibing@huawei.com>, mchehab@kernel.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-media@vger.kernel.org
References: <20181229024528.6016-1-yuehaibing@huawei.com>
 <83af4b2d-a638-70a4-fd61-9720116c3e8f@linux.intel.com>
 <20190107105959.n3pkvo5nbzsikt4m@kekkonen.localdomain>
From:   Bingbu Cao <bingbu.cao@linux.intel.com>
Message-ID: <cf39d1c6-00f4-bd70-1a6a-b01e660f6d5d@linux.intel.com>
Date:   Tue, 8 Jan 2019 12:10:32 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190107105959.n3pkvo5nbzsikt4m@kekkonen.localdomain>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


On 01/07/2019 07:00 PM, Sakari Ailus wrote:
> Hi Bingbu,
>
> On Mon, Jan 07, 2019 at 10:38:19AM +0800, Bingbu Cao wrote:
>> Hi, Haibing
>>
>> Thanks for your patch, it looks fine for me.
>> Reviewed-by: Bingbu Cao <bingbu.cao@intel.com>
>>
>> On 12/29/2018 10:45 AM, YueHaibing wrote:
>>> css->pipes[pipe].bindex = binary;
> I'm taking Colin's patch with equivalent content; it was there first.
Sakari, good to know that, thanks!
>
> Thanks!
>

