Return-Path: <SRS0=ZIWa=RP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E6FDC43381
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 08:48:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA13D214AE
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 08:48:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727539AbfCLIsw (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 12 Mar 2019 04:48:52 -0400
Received: from mga09.intel.com ([134.134.136.24]:48446 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725832AbfCLIsv (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Mar 2019 04:48:51 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Mar 2019 01:48:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,470,1544515200"; 
   d="scan'208";a="121927134"
Received: from ipu5-build.bj.intel.com (HELO [10.238.232.171]) ([10.238.232.171])
  by orsmga007.jf.intel.com with ESMTP; 12 Mar 2019 01:48:48 -0700
Subject: Re: [PATCH] media:staging/intel-ipu3: parameter buffer refactoring
To:     Tomasz Figa <tfiga@chromium.org>
Cc:     Cao Bing Bu <bingbu.cao@intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Yeh, Andy" <andy.yeh@intel.com>,
        "Qiu, Tian Shu" <tian.shu.qiu@intel.com>
References: <1550221729-29240-1-git-send-email-bingbu.cao@intel.com>
 <CAAFQd5BOJmE51nrbK+3KGeQWN88iOt--xervThtxrRx3AohFPw@mail.gmail.com>
 <bc3117f8-fd74-2b61-07c0-926fba898d5d@linux.intel.com>
 <CAAFQd5DQwBZFOzH6oztHhPR1MLQaAWS0MXDOWt8p5E3vibLFBg@mail.gmail.com>
From:   Bingbu Cao <bingbu.cao@linux.intel.com>
Message-ID: <2b90b4b3-a844-b3fb-5158-6818cf84f43d@linux.intel.com>
Date:   Tue, 12 Mar 2019 16:55:26 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <CAAFQd5DQwBZFOzH6oztHhPR1MLQaAWS0MXDOWt8p5E3vibLFBg@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org



On 03/12/2019 03:43 PM, Tomasz Figa wrote:
> On Tue, Mar 12, 2019 at 3:48 PM Bingbu Cao <bingbu.cao@linux.intel.com> wrote:
>>
>>
>> On 03/12/2019 01:33 PM, Tomasz Figa wrote:
>>> Hi Bingbu,
>>>
>>> On Fri, Feb 15, 2019 at 6:02 PM <bingbu.cao@intel.com> wrote:
>>>> From: Bingbu Cao <bingbu.cao@intel.com>
>>>>
>>>> Current ImgU driver processes and releases the parameter buffer
>>>> immediately after queued from user. This does not align with other
>>>> image buffers which are grouped in sets and used for the same frame.
>>>> If user queues multiple parameter buffers continuously, only the last
>>>> one will take effect.
>>>> To make consistent buffers usage, this patch changes the parameter
>>>> buffer handling and group parameter buffer with other image buffers
>>>> for each frame.
>>> Thanks for the patch. Please see my comments inline.
>>>
>>>> Signed-off-by: Tianshu Qiu <tian.shu.qiu@intel.com>
>>>> Signed-off-by: Bingbu Cao <bingbu.cao@intel.com>
>>>> ---
>>>>    drivers/staging/media/ipu3/ipu3-css.c  |  5 -----
>>>>    drivers/staging/media/ipu3/ipu3-v4l2.c | 41 ++++++++--------------------------
>>>>    drivers/staging/media/ipu3/ipu3.c      | 24 ++++++++++++++++++++
>>>>    3 files changed, 33 insertions(+), 37 deletions(-)
>>>>
>>>> diff --git a/drivers/staging/media/ipu3/ipu3-css.c b/drivers/staging/media/ipu3/ipu3-css.c
>>>> index b9354d2bb692..bcb1d436bc98 100644
>>>> --- a/drivers/staging/media/ipu3/ipu3-css.c
>>>> +++ b/drivers/staging/media/ipu3/ipu3-css.c
>>>> @@ -2160,11 +2160,6 @@ int ipu3_css_set_parameters(struct ipu3_css *css, unsigned int pipe,
>>>>           obgrid_size = ipu3_css_fw_obgrid_size(bi);
>>>>           stripes = bi->info.isp.sp.iterator.num_stripes ? : 1;
>>>>
>>>> -       /*
>>>> -        * TODO(b/118782861): If userspace queues more than 4 buffers, the
>>>> -        * parameters from previous buffers will be overwritten. Fix the driver
>>>> -        * not to allow this.
>>>> -        */
>>> Wouldn't this still happen even with current patch?
>>> imgu_queue_buffers() supposedly queues "as many buffers to CSS as
>>> possible". This means that if the userspace queues more than 4
>>> complete frames, we still end up overwriting the parameter buffers in
>>> the pool. Please correct me if I'm wrong.
>> The parameter buffers are queued to CSS sequentially and queue one
>> parameter along with one input buffer once ready, all the data and
>> parameter buffers are tied together to queue to the CSS. If userspace
>> queue more parameter buffers then input buffer, they are pending on the
>> buffer list.
> It doesn't seem to be what the code does. I'm talking about the
> following example:
>
> Queue OUT buffer 1
> Queue PARAM buffer 1
> Queue IN buffer 1
> Queue OUT buffer 2
> Queue PARAM buffer 2
> Queue IN buffer 2
> Queue OUT buffer 3
> Queue PARAM buffer 3
> Queue IN buffer 3
> Queue OUT buffer 4
> Queue PARAM buffer 4
> Queue IN buffer 4
> Queue OUT buffer 5
> Queue PARAM buffer 5
> Queue IN buffer 5
>
> All the operations happening exactly one after each other. How would
> the code prevent the 5th PARAM buffer to be queued to the IMGU, after
> the 5th IN buffer is queued? As I said, imgu_queue_buffers() just
> queues as many buffers of each type as there are IN buffers available.
So the parameter pool now is only used as record last valid parameter not
used as a list or cached, all the parameters will be queued to CSS as soon as
possible(if queue for CSS is not full).
As the size of pool now is a bit confusing, I think we can shrink the its value
for each pipe to 2.

The buffer queue size is limited for CSS, if massive buffers from
user pass down and the css queue is full, driver will get -EBUSY
and return the buffers to user with error.

>
> Best regards,
> Tomasz
>

