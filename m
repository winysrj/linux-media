Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:58114 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726402AbeJGPd6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 7 Oct 2018 11:33:58 -0400
Subject: Re: [Outreachy kernel] [PATCH vicodec] media: pvrusb2: replace
 `printk` with `pr_*`
To: Sasha Levin <sashal@kernel.org>,
        Dafna Hirschfeld <dafna3@gmail.com>
Cc: isely@pobox.com, mchehab@kernel.org, helen.koike@collabora.com,
        outreachy-kernel@googlegroups.com,
        Linux Media Mailing List <linux-media@vger.kernel.org>
References: <20181006192138.11349-1-dafna3@gmail.com>
 <20181006230359.GB32006@sasha-vm>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <bdf81e02-cec3-501e-4cb9-0c2f2b0f12da@xs4all.nl>
Date: Sun, 7 Oct 2018 10:27:22 +0200
MIME-Version: 1.0
In-Reply-To: <20181006230359.GB32006@sasha-vm>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/07/2018 01:03 AM, Sasha Levin wrote:
> On Sat, Oct 06, 2018 at 10:21:38PM +0300, Dafna Hirschfeld wrote:
>> Replace calls to `printk` with the appropriate `pr_*`
>> macro.
> 
> Hi Dafna,
> 
> I'd encourage you to look into the dev_ family of print functions (such
> as dev_info() ). They can avoid having to repeat the driver name in
> every print call.

Not for this driver. The hdw->name is the right prefix to use and the code
already uses it.

For almost any other media driver Sasha would be right, just not this one
due to historical reasons.

Regards,

	Hans
