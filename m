Return-Path: <SRS0=8vfi=PP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDD7CC43387
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 02:32:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 968772085A
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 02:32:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbfAGCcp (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 6 Jan 2019 21:32:45 -0500
Received: from mga12.intel.com ([192.55.52.136]:33997 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726160AbfAGCcp (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 6 Jan 2019 21:32:45 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Jan 2019 18:32:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,449,1539673200"; 
   d="scan'208";a="124674170"
Received: from ipu5-build.bj.intel.com (HELO [10.238.232.171]) ([10.238.232.171])
  by orsmga001.jf.intel.com with ESMTP; 06 Jan 2019 18:32:43 -0800
Subject: Re: [PATCH -next] media: staging/intel-ipu3: Fix err handle of
 ipu3_css_find_binary
To:     YueHaibing <yuehaibing@huawei.com>, sakari.ailus@linux.intel.com,
        mchehab@kernel.org, gregkh@linuxfoundation.org
Cc:     linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-media@vger.kernel.org
References: <20181229024528.6016-1-yuehaibing@huawei.com>
From:   Bingbu Cao <bingbu.cao@linux.intel.com>
Message-ID: <83af4b2d-a638-70a4-fd61-9720116c3e8f@linux.intel.com>
Date:   Mon, 7 Jan 2019 10:38:19 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20181229024528.6016-1-yuehaibing@huawei.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi, Haibing

Thanks for your patch, it looks fine for me.
Reviewed-by: Bingbu Cao <bingbu.cao@intel.com>

On 12/29/2018 10:45 AM, YueHaibing wrote:
> css->pipes[pipe].bindex = binary;

