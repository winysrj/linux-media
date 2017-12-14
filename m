Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:37924 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753680AbdLNRhe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Dec 2017 12:37:34 -0500
Received: by mail-wm0-f68.google.com with SMTP id 64so12927398wme.3
        for <linux-media@vger.kernel.org>; Thu, 14 Dec 2017 09:37:33 -0800 (PST)
Subject: Re: [RESEND PATCH] partial revert of "[media] tvp5150: add HW input
 connectors support"
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org
References: <20171206003305.22895-1-javierm@redhat.com>
 <20171214150235.1d3abc8f@vento.lan>
From: Javier Martinez Canillas <javierm@redhat.com>
Message-ID: <2af3e534-bacc-eedb-0c02-276d501427ac@redhat.com>
Date: Thu, 14 Dec 2017 18:37:30 +0100
MIME-Version: 1.0
In-Reply-To: <20171214150235.1d3abc8f@vento.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mauro,

On 12/14/2017 06:02 PM, Mauro Carvalho Chehab wrote:
> Em Wed,  6 Dec 2017 01:33:05 +0100
> Javier Martinez Canillas <javierm@redhat.com> escreveu:
> 
>> Commit f7b4b54e6364 ("[media] tvp5150: add HW input connectors support")
>> added input signals support for the tvp5150, but the approach was found
>> to be incorrect so the corresponding DT binding commit 82c2ffeb217a
>> ("[media] tvp5150: document input connectors DT bindings") was reverted.
>>
>> This left the driver with an undocumented (and wrong) DT parsing logic,
>> so lets get rid of this code as well until the input connectors support
>> is implemented properly.
>>
>> It's a partial revert due other patches added on top of mentioned commit
>> not allowing the commit to be reverted cleanly anymore. But all the code
>> related to the DT parsing logic and input entities creation are removed.
>>
>> Suggested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>> Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>
>> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
>>
>> ---
>>
>> This patch was posted about a year ago but was never merged:
>>
>> https://patchwork.kernel.org/patch/9472623/
> 
> It was a RFT, on that time.
> 

Yes, sorry if it sounded as if I was complaining. I was just mentioning and
part of the patch falling through the cracks is that I also forgot about it.

> I guess I told that before. Maybe not. Anyway, reverting it doesn't seem 
> to be the proper fix, as it will break support for existing devices, by
> removing functionality from tvp5150 driver. You should remind that, since
> the code was added, someone could be already using it, as all it is

I'm not sure about this. What I'm removing is basically dead code (unless
someone is using an undocumented Device Tree binding), since the DT binding
got already removed by commit 31e717dba1e1 ("[media] Revert "[media] tvp5150:
document input connectors DT bindings").

> needed is to have some dtb. Also, it gets rid of a lot of good work for
> no good reason. Reinserting them later while preserving the code
> copyrights could be painful.
>

I would normally agree with you, although I think that in this particular case
is better to just revert this (unused) code for the reasons I mentioned above.

But don't really have a strong opinion on this, so I'm OK with either approach.

> IMHO, the best here is to move ahead, agreeing with a DT structure
> that represents the connectors and then change the driver to
> implement it, if needed.
>

There was some agreement on the DT binding, it's just that I never found time
to implement the logic in the driver. Let's see if I can get some during the
winter holidays and finally fix this.

> Thanks,
> Mauro
> 

Best regards,
-- 
Javier Martinez Canillas
Software Engineer - Desktop Hardware Enablement
Red Hat
