Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf1-f194.google.com ([209.85.210.194]:44231 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388574AbeGWRrE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Jul 2018 13:47:04 -0400
Subject: Re: [PATCH v6 16/17] media: v4l2: async: Remove notifier subdevs
 array
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        =?UTF-8?Q?Niklas_S=c3=b6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Sebastian Reichel <sre@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        open list <linux-kernel@vger.kernel.org>
References: <1531175957-1973-1-git-send-email-steve_longerbeam@mentor.com>
 <1531175957-1973-17-git-send-email-steve_longerbeam@mentor.com>
 <20180723123557.bfxxsqqhlaj3ccwc@valkosipuli.retiisi.org.uk>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <a040c77f-2bee-5d0d-57ec-852ff30448e9@gmail.com>
Date: Mon, 23 Jul 2018 09:44:57 -0700
MIME-Version: 1.0
In-Reply-To: <20180723123557.bfxxsqqhlaj3ccwc@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 07/23/2018 05:35 AM, Sakari Ailus wrote:
> Hi Steve,
>
> Thanks for the update.
>
> On Mon, Jul 09, 2018 at 03:39:16PM -0700, Steve Longerbeam wrote:
>> All platform drivers have been converted to use
>> v4l2_async_notifier_add_subdev(), in place of adding
>> asd's to the notifier subdevs array. So the subdevs
>> array can now be removed from struct v4l2_async_notifier,
>> and remove the backward compatibility support for that
>> array in v4l2-async.c.
>>
>> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
> This set removes the subdevs and num_subdevs fieldsfrom the notifier (as
> discussed previously) but it doesn't include the corresponding
> driver changes. Is there a patch missing from the set?

Hi Sakari, yes somehow patch 15/17 (the large patch to all drivers)
got dropped by the ML, maybe because the cc-list was too big?

I will resend with only linux-media and cc: you.

Steve
