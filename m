Return-Path: <SRS0=dU+R=OY=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43573C43387
	for <linux-media@archiver.kernel.org>; Sat, 15 Dec 2018 18:38:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EFEBB206C2
	for <linux-media@archiver.kernel.org>; Sat, 15 Dec 2018 18:38:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726813AbeLOSiv (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 15 Dec 2018 13:38:51 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:38016 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726520AbeLOSiv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 15 Dec 2018 13:38:51 -0500
Received: from [IPv6:2804:431:9719:f68f:53a6:20b4:af17:1a54] (unknown [IPv6:2804:431:9719:f68f:53a6:20b4:af17:1a54])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: koike)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id 955FA260891;
        Sat, 15 Dec 2018 18:38:45 +0000 (GMT)
Subject: Re: [Lkcamp][PATCH] media: vimc: Add vimc-streamer for stream control
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        =?UTF-8?Q?Lucas_A=2e_M=2e_Magalh=c3=a3es?= <lucmaga@gmail.com>
Cc:     linux-media@vger.kernel.org, hverkuil@xs4all.nl,
        lkcamp@lists.libreplanetbr.org, linux-kernel@vger.kernel.org
References: <20181215164631.8623-1-lucmaga@gmail.com>
 <20181215160110.1a353219@coco.lan>
From:   Helen Koike <helen.koike@collabora.com>
Openpgp: preference=signencrypt
Autocrypt: addr=helen.koike@collabora.com; keydata=
 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
Message-ID: <df515706-5649-abdb-2231-03dcf4517600@collabora.com>
Date:   Sat, 15 Dec 2018 16:38:41 -0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
In-Reply-To: <20181215160110.1a353219@coco.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Mauro,

On 12/15/18 4:01 PM, Mauro Carvalho Chehab wrote:
> Hi Lucas,
> 
> 
> Em Sat, 15 Dec 2018 14:46:31 -0200
> Lucas A. M. Magalhães <lucmaga@gmail.com> escreveu:
> 
>> The previous code pipeline used the stack to walk on the graph and
>> process a frame. Basically the vimc-sensor entity starts a thread that
>> generates the frames and calls the propagate_process function to send
>> this frame to each entity linked with a sink pad. The propagate_process
>> will call the process_frame of the entities which will call the
>> propagate_frame for each one of it's sink pad. This cycle will continue
>> until it reaches a vimc-capture entity that will finally return and
>> unstack.
> 
> I didn't review the code yet, but I have a few comments about the
> way you're describing this patch.
> 
> When you mention about a "previous code pipeline". Well, by adding it
> at the main body of the patch description, reviewers should expect
> that you're mentioning an implementation that already reached upstream.
> 
> I suspect that this is not the case here, as I don't think we merged
> any recursive algorithm using the stack, as this is something that
> we shouldn't do at Kernelspace, as a 4K stack is usually not OK
> with recursive algorithms.
> 
> So, it seems that this entire patch description (as-is) is bogus[1].
> 
> [1] if this is not the case and a recursive approach was indeed
> sneaked into the Kernel, this is a bug. So, you should really
> use the "Fixes:" meta-tag indicating what changeset this patch is
> fixing, and a "Cc: stable@vger.kernel.org", in order to hint
> stable maintainers that this require backports.

Just fyi, this is not the case, the current implementation in mainline
is bogus indeed (implemented by me when I was starting kernel
development, sorry about that and thanks Lucas for sending a fix). Not
only when propagating the frame [1] but also when activating the
pipeline [2].

But in any case this should be better written in the commit message.


[1]
Every entity calls vimc_propagate_frame()
https://git.linuxtv.org/media_tree.git/tree/drivers/media/platform/vimc/vimc-debayer.c#n506
That calls the process_frame() of each entity directly connected, that
calls vimc_propagate_frame() again:
https://git.linuxtv.org/media_tree.git/tree/drivers/media/platform/vimc/vimc-common.c#n237

[2]
.s_stream is calling the .s_stream of the subdevices directly connected
https://git.linuxtv.org/media_tree.git/tree/drivers/media/platform/vimc/vimc-debayer.c#n355


I was actually wondering if this is worthy in sending this to stable, as
this implementation is not a real problem, because the topology in vimc
is hardcoded and limited, and according to:
https://www.kernel.org/doc/Documentation/process/stable-kernel-rules.rst
"It must fix a real bug that bothers people"

So as the topology is fixed (in the current implementation), the max
number of nested calls is 4 (in the sensor->debayer->scaler->capture
path), this doesn't triggers any bug to users. But this will be a
problem once we have the configfs API in vimc.

You could say that if your memory is low, this can be a problem in the
current implementation, but then your system won't have memory for any 4
nested function calls anyway (which I think the kernel wouldn't work at
all).

Mauro, with that said, do you still think we should send this to stable?

Thanks
Helen

> 
> Please notice that the patch description will be stored forever
> at the git tree. Mentioning something that were never merged
> (and that, years from now people will hardly remember, and will
> have lots of trouble to seek as you didn't even mentioned any
> ML archive with the past solution) shouldn't be done.
> 
> So, you should rewrite the entire patch description explaining
> what the current approach took by this patch does. Then, in order
> to make easier for reviewers to compare with a previous implementation,
> you can add a "---" line and then a description about why this approach
> is better than the first version, e. g. something like:
> 
> 	[PATCH v2] media: vimc: Add vimc-streamer for stream control
> 
> 	Add a logic that will create a linear pipeline walking 
> 	backwards on the graph. When the stream starts it will simply
> 	loop through the pipeline calling the respective process_frame
> 	function for each entity on the pipeline.
> 
> 	Signed-off-by: Your Name <your@email>
> 
> 	---
> 
> 	v2: The previous approach were to use a recursive function that
> 	it was using the stack to walk on the graph and
> 	process a frame. Basically the vimc-sensor entity starts a thread that
> 	generates the frames and calls the propagate_process function to send
> 	this frame to each entity linked with a sink pad. The propagate_process
> 	will call the process_frame of the entities which will call the
> 	propagate_frame for each one of it's sink pad. This cycle will continue
> 	until it reaches a vimc-capture entity that will finally return and
> 	unstack.
> 	...
> 
> If the past approach was written by somebody else (or if you sent it
> a long time ago), please add an URL (if possible using 
> https://lore.kernel.org/linux-media/ archive) pointing to the previous 
> approach, in order to help us to check what you're referring to.
> 
> Regards,
> Mauro
> 
> Thanks,
> Mauro
> 
