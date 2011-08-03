Return-path: <linux-media-owner@vger.kernel.org>
Received: from bonnie-vm4.ifh.de ([141.34.50.21]:41251 "EHLO smtp.ifh.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753011Ab1HCILn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Aug 2011 04:11:43 -0400
Date: Wed, 3 Aug 2011 09:39:46 +0200 (CEST)
From: Patrick Boettcher <pboettcher@kernellabs.com>
To: Florian Mickler <florian@mickler.org>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Dan Carpenter <error27@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: vp702x
In-Reply-To: <20110802173942.6f951c95@schatten.dmk.lab>
Message-ID: <alpine.LRH.2.00.1108030937250.5518@pub4.ifh.de>
References: <20110802173942.6f951c95@schatten.dmk.lab>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Florian,

On Tue, 2 Aug 2011, Florian Mickler wrote:

> Hi Mauro! Hi Patrick!
>
> I realized this morning, that I broke vp702x (if it was working before)
> with my last patchseries. Sorry. :(
>
> I'm gonna follow up on this mail with a patch to hopefully fix it, but
> if nobody can test it, I'd say to rather revert my patchseries
> for v3.1 . It will then still use on-stack dma buffers and will
> produce a WARN() in the dmesg if it does so, but hopefully nothing bad
> happens.
>
> Patrick, do you still have the hardware to test this? I'm semi
> confident that I did not make any silly mistakes. :| (it compiles)

I'm not sure whether I still have exactly this box. There were two 
versions and I got rid of at least one of them.

I moved recently into a new house and right now a lot of things are hidden 
in some boxes somewhere... I'll try to find some time to check it. Don't 
ask me when that will be :).

regards,
--

Patrick Boettcher - Kernel Labs
http://www.kernellabs.com/
