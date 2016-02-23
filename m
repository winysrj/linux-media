Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:39489 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753940AbcBWSeH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Feb 2016 13:34:07 -0500
Subject: Re: [PATCH] [media] tvp5150: remove signal generator as input from
 the DT binding
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <1456243798-12453-1-git-send-email-javier@osg.samsung.com>
 <63317542.65NzPYJCcU@avalon> <56CCA3B4.7060700@osg.samsung.com>
 <4247934.WAaViM8cSf@avalon>
Cc: linux-kernel@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	devicetree@vger.kernel.org, linux-media@vger.kernel.org
From: Javier Martinez Canillas <javier@osg.samsung.com>
Message-ID: <56CCA613.2000309@osg.samsung.com>
Date: Tue, 23 Feb 2016 15:33:55 -0300
MIME-Version: 1.0
In-Reply-To: <4247934.WAaViM8cSf@avalon>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 02/23/2016 03:28 PM, Laurent Pinchart wrote:
> Hi Javier,

[snip]

>>>
>>> Shouldn't we revert the patch that introduced connectors support in the DT
>>> bindings in the meantime then, to avoid known to be broken bindings from
>>> hitting mainline in case we can't fix them in time for v4.6 ?
>>
>> Yes, that would be a good idea. I've seen recently though a DT binding doc
>> that was marked as unstable / work in progress and I wonder if that's a new
>> accepted convention for DT binding docs or is just something that slipped
>> through review.
>
> I'm not sure if it's an established practice but I certainly like it. However,
> in this specific case, we know that the bindings are broken, so I think a
> revert would be better.
>

Ok, I'll post a revert then that supersedes this patch.

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
