Return-Path: <SRS0=OvUS=QF=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95251C169C4
	for <linux-media@archiver.kernel.org>; Tue, 29 Jan 2019 11:26:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6DFA120880
	for <linux-media@archiver.kernel.org>; Tue, 29 Jan 2019 11:26:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728444AbfA2L0R (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 29 Jan 2019 06:26:17 -0500
Received: from mga02.intel.com ([134.134.136.20]:59692 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725772AbfA2L0R (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 Jan 2019 06:26:17 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Jan 2019 03:26:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,537,1539673200"; 
   d="scan'208";a="134064325"
Received: from ipu5-build.bj.intel.com (HELO [10.238.232.171]) ([10.238.232.171])
  by orsmga001.jf.intel.com with ESMTP; 29 Jan 2019 03:26:14 -0800
Subject: Re: ipu3-imgu 0000:00:05.0: required queues are disabled
To:     Kai Heng Feng <kai.heng.feng@canonical.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc:     sakari.ailus@linux.intel.com, bingbu.cao@intel.com,
        yong.zhi@intel.com, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        LibCamera Devel <libcamera-devel@lists.libcamera.org>
References: <7F8ED1B6-5070-437A-A745-AE017D8CE0DF@canonical.com>
 <ac9cd5cd-82af-48c7-5b12-adacb540480c@ideasonboard.com>
 <76CB59A0-D8F2-4C01-A600-60138ED5E785@canonical.com>
From:   Bingbu Cao <bingbu.cao@linux.intel.com>
Message-ID: <9311dd48-2169-5615-4368-1053a0d47e07@linux.intel.com>
Date:   Tue, 29 Jan 2019 19:32:12 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <76CB59A0-D8F2-4C01-A600-60138ED5E785@canonical.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org



On 01/28/2019 11:45 PM, Kai Heng Feng wrote:
> Hi Kieran,
>
>> On Jan 28, 2019, at 4:48 PM, Kieran Bingham <kieran.bingham@ideasonboard.com> wrote:
>>
>> Hi Kai-Heng,
>>
>> On 27/01/2019 05:56, Kai-Heng Feng wrote:
>>> Hi,
>>>
>>> We have a bug report [1] that the ipu3 doesn’t work.
>>> Does ipu3 need special userspace to work?
>> Yes, it will need further userspace support to configure the pipeline,
>> and to provide 3A algorithms for white balance, focus, and exposure
>> times to the sensor.
>>
>> We are developing a stack called libcamera [0] to support this, but it's
>> still in active development and not yet ready for use. Fortunately
>> however, IPU3 is one of our primary initial targets.
> Thanks for the info.
Hi, Kai-Heng,

Like Bingham said, for IPU3 some heavy control from the userspace is needed.
libcamera is a very good start.
If you just want to verify the driver firstly, you can use script to take a try.
>> [0] https://www.libcamera.org/
>>
>>> [1] https://bugs.launchpad.net/bugs/1812114
>> I have reported similar information to the launchpad bug entry.
>>
>> It might help if we can get hold of a Dell 7275 sometime although I
>> think Mauro at least has one ?
>>
>> If this is a priority for Canonical, please contact us directly.
> Not really, just raise issues from Launchpad to appropriate mailing list.
>
> Kai-Heng
>
>>> Kai-Heng
>> --
>> Regards
>>
>> Kieran
>

