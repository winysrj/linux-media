Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.hauppauge.com ([167.206.143.4]:3087 "EHLO
	mail.hauppauge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753870AbZC3QkT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Mar 2009 12:40:19 -0400
Message-ID: <49D0F5E1.2030108@linuxtv.org>
Date: Mon, 30 Mar 2009 12:40:01 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Mark Lord <lkml@rtr.ca>, linux-media@vger.kernel.org
Subject: Re: Patch for 2.6.29 stable series: remove #ifdef MODULE nonsense
References: <200903301835.55023.hverkuil@xs4all.nl>
In-Reply-To: <200903301835.55023.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil wrote:
> Hi Mike,
>
> The attached patch should be queued for 2.6.29.X. It corresponds to 
> changeset 11098 (v4l2-common: remove incorrect MODULE test) in our v4l-dvb 
> tree and is part of the initial set of git patches going into 2.6.30.
>
> Without this patch loading ivtv as a module while v4l2-common is compiled 
> into the kernel will cause a delayed load of the i2c modules that ivtv 
> needs since request_module is never called directly.
>
> While it is nice to see the delayed load in action, it is not so nice in 
> that ivtv fails to do a lot of necessary i2c initializations and will oops 
> later on with a division-by-zero.
>
> Thanks to Mark Lord for reporting this and helping me figure out what was 
> wrong.
>
> Regards,
>
> 	Hans
>
>   
Got it, thanks.

In the future, please point to hash codes rather than revision ID's -- 
my rev IDs are not the same as yours, but hash codes are always unique.

I'll queue this the moment Linus merges Mauro's pending request.

Cheers,

Mike
