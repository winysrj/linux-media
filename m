Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:50812 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752109Ab3J3PvW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Oct 2013 11:51:22 -0400
Message-ID: <52712AF4.5020503@iki.fi>
Date: Wed, 30 Oct 2013 17:51:16 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>
CC: linux-media@vger.kernel.org, Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH] rtl2830: add parent for I2C adapter
References: <1382386335-3879-1-git-send-email-crope@iki.fi> <52658CA7.5080104@iki.fi> <20131030151620.GB3663@katana> <52712787.3010408@iki.fi> <20131030154553.GC3663@katana>
In-Reply-To: <20131030154553.GC3663@katana>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 30.10.2013 17:45, Wolfram Sang wrote:
>
>>>> commit 3923172b3d700486c1ca24df9c4c5405a83e2309
>>>> i2c: reduce parent checking to a NOOP in non-I2C_MUX case
>>>
>>> Did you try reverting it? I am not sure this is the one.
>>
>> Nope, not to mentio bisect. I have done bisect few times and I am
>> not going to waste whole day of compiling and booting new kernels.
>
> Well, I intentionally asked for revert not bisect. Removing the #ifdef
> can easily be done by hand if needed and will just need one recompile to
> make sure.

Yes, but compiling whole Kernel is always pain. I dont certainly want to 
do that just for testing some patches.

>> Crash disappeared whit that little patch.
>
> Yes, still I'd like to understand where the BUG came from. There are
> probably other driver in need of a fix, too.
>
>> Anyway, I am going to ask Mauro to merge that I2C parent patch and
>> maybe try to sent it stable too as it is likely a bit too late for
>> 3.12 RC.
>
> If it fixes a crash, I wouldn't consider it too late. Yet only given we
> have understood this is a proper fix.
>
> Was there a change in using CONFIG_I2C_COMPAT? Is it currently used?

Jean jsut pointed out on IRC that this patch likely fixes the issue:
http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=47b6e477ed4ecacddd1f82d04d686026e08dc3db

As that patch is already applied to 3.12 it should be fine. I was 
running media master which is based 3.12-rc2.

So I am sending that patch to Kernel 3.13.

regards
Antti


-- 
http://palosaari.fi/
