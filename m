Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:58638 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750763Ab3J3Q3w (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Oct 2013 12:29:52 -0400
Message-ID: <527133FB.2030404@iki.fi>
Date: Wed, 30 Oct 2013 18:29:47 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>
CC: linux-media@vger.kernel.org, Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH] rtl2830: add parent for I2C adapter
References: <1382386335-3879-1-git-send-email-crope@iki.fi> <52658CA7.5080104@iki.fi> <20131030151620.GB3663@katana> <52712787.3010408@iki.fi> <20131030154553.GC3663@katana> <52712AF4.5020503@iki.fi> <20131030160234.GE3663@katana>
In-Reply-To: <20131030160234.GE3663@katana>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 30.10.2013 18:02, Wolfram Sang wrote:
>
>>> Well, I intentionally asked for revert not bisect. Removing the #ifdef
>>> can easily be done by hand if needed and will just need one recompile to
>>> make sure.
>>
>> Yes, but compiling whole Kernel is always pain. I dont certainly
>> want to do that just for testing some patches.
>
> Well, if you ask for support for debugging, you should be prepared to do
> exactly that.
>
>> Jean jsut pointed out on IRC that this patch likely fixes the issue:
>> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=47b6e477ed4ecacddd1f82d04d686026e08dc3db
>
> Yup, he is right. You have ACPI enabled.
>
>> As that patch is already applied to 3.12 it should be fine. I was
>> running media master which is based 3.12-rc2.
>
> Asking you to build the latest kernel might have been another thing I'd
> ask you to do.

I installed that single patch top of media master tree and it fixes the 
problem. Maybe this is enough If there is still good reason to latest 
Linus tree I can do that too.
RTL2830 adapter parent patch will go to the 3.13.

Thanks Jean and Wolfram

regards
Antti

-- 
http://palosaari.fi/
