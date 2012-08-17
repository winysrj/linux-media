Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f53.google.com ([209.85.216.53]:63749 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754886Ab2HQPWI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Aug 2012 11:22:08 -0400
Received: by qaas11 with SMTP id s11so1666648qaa.19
        for <linux-media@vger.kernel.org>; Fri, 17 Aug 2012 08:22:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120817134443.GB32720@valkosipuli.retiisi.org.uk>
References: <1345178942-6771-1-git-send-email-sachin.kamat@linaro.org>
	<20120817134443.GB32720@valkosipuli.retiisi.org.uk>
Date: Fri, 17 Aug 2012 20:52:06 +0530
Message-ID: <CAK9yfHx=ueQreq-XLjLB4MvHibuh-b3JYz-F7JzdFqvRJaVM=w@mail.gmail.com>
Subject: Re: [PATCH v2] smiapp: Use devm_* functions in smiapp-core.c file
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 17 August 2012 19:14, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> Hi Sachin,
>
> On Fri, Aug 17, 2012 at 10:19:02AM +0530, Sachin Kamat wrote:
>> devm_* functions are device managed functions and make code a bit
>> smaller and cleaner.
>>
>> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
>> ---
>> Changes since v1:
>> Used devm_kzalloc for sensor->nvm.
>> Used devm_clk_get and devm_regulator_get functions.
>>
>> This patch is based on Mauro's re-organized tree
>> (media_tree staging/for_v3.7) and is compile tested.
>
> Thanks for the updated patch!
>
> I've applied this and the other patch you sent ("[media] smiapp: Remove
> unused function") to my tree.

Thanks Sakari.

>
> Cheers,
>
> --
> Sakari Ailus
> e-mail: sakari.ailus@iki.fi     jabber/XMPP/Gmail: sailus@retiisi.org.uk



-- 
With warm regards,
Sachin
