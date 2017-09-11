Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-by2nam03on0076.outbound.protection.outlook.com ([104.47.42.76]:47392
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751026AbdIKLGt (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Sep 2017 07:06:49 -0400
Subject: Re: [PATCH] dma-fence: fix dma_fence_get_rcu_safe
To: Chris Wilson <chris@chris-wilson.co.uk>, daniel.vetter@ffwll.ch,
        sumit.semwal@linaro.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org
References: <1504531653-13779-1-git-send-email-deathsimple@vodafone.de>
 <150453243791.23157.6907537389223890207@mail.alporthouse.com>
 <67fe7e05-7743-40c8-558b-41b08eb986e9@amd.com>
 <150512037119.16759.472484663447331384@mail.alporthouse.com>
 <3c412ee3-854a-292a-e036-7c5fd7888979@amd.com>
 <150512178199.16759.73667469529688@mail.alporthouse.com>
 <5ff4b100-b580-a93d-aa5e-c66173ac091d@amd.com>
 <150512410278.16759.10537429613477592631@mail.alporthouse.com>
From: =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
Message-ID: <79e447f8-f2e3-57e3-b5fe-503e5feb2f82@amd.com>
Date: Mon, 11 Sep 2017 13:06:32 +0200
MIME-Version: 1.0
In-Reply-To: <150512410278.16759.10537429613477592631@mail.alporthouse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 11.09.2017 um 12:01 schrieb Chris Wilson:
> [SNIP]
>> Yeah, but that is illegal with a fence objects.
>>
>> When anybody allocates fences this way it breaks at least
>> reservation_object_get_fences_rcu(),
>> reservation_object_wait_timeout_rcu() and
>> reservation_object_test_signaled_single().
> Many, many months ago I sent patches to fix them all.

Found those after a bit a searching. Yeah, those patches where proposed 
more than a year ago, but never pushed upstream.

Not sure if we really should go this way. dma_fence objects are shared 
between drivers and since we can't judge if it's the correct fence based 
on a criteria in the object (only the read counter which is outside) all 
drivers need to be correct for this.

I would rather go the way and change dma_fence_release() to wrap 
fence->ops->release into call_rcu() to keep the whole RCU handling 
outside of the individual drivers.

Regards,
Christian.
