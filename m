Return-Path: <SRS0=gjtM=PQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0332BC43387
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 04:03:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CAADA2087F
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 04:03:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727368AbfAHEDm (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 7 Jan 2019 23:03:42 -0500
Received: from mga07.intel.com ([134.134.136.100]:43323 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727246AbfAHEDl (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 7 Jan 2019 23:03:41 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Jan 2019 20:03:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,452,1539673200"; 
   d="scan'208";a="125057437"
Received: from ipu5-build.bj.intel.com (HELO [10.238.232.171]) ([10.238.232.171])
  by orsmga001.jf.intel.com with ESMTP; 07 Jan 2019 20:03:40 -0800
Subject: Re: [PATCH 0/2] Ipu3-cio2 and dw9714 driver e-mail and reviewer
 update
To:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Cc:     yong.zhi@intel.com, bingbu.cao@intel.com
References: <20190107111053.5708-1-sakari.ailus@linux.intel.com>
From:   Bingbu Cao <bingbu.cao@linux.intel.com>
Message-ID: <94a55946-20ff-6555-f34c-fc9d530fb7da@linux.intel.com>
Date:   Tue, 8 Jan 2019 12:09:17 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190107111053.5708-1-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

I agree this change and wish no more changes like this. :)

On 01/07/2019 07:10 PM, Sakari Ailus wrote:
> Hi,
>
> This set removes Jian Xu from the driver's reviewers as well as removes
> his e-mail address from the module author.
>
> Sakari Ailus (2):
>    MAINTAINERS: Update reviewers for ipu3-cio2
>    ipu3-cio2, dw9714: Remove Jian Xu's e-mail
>
>   MAINTAINERS                              | 1 -
>   drivers/media/i2c/dw9714.c               | 2 +-
>   drivers/media/pci/intel/ipu3/ipu3-cio2.c | 2 +-
>   3 files changed, 2 insertions(+), 3 deletions(-)
>

