Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:4805 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479AbZBUN43 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Feb 2009 08:56:29 -0500
Date: Sat, 21 Feb 2009 14:56:15 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Trent Piepho <xyzzy@speakeasy.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	urishk@yahoo.com, linux-media@vger.kernel.org
Subject: Re: Minimum kernel version supported by v4l-dvb
Message-ID: <20090221145615.324c4cb7@hyperion.delvare>
In-Reply-To: <200902211428.31814.hverkuil@xs4all.nl>
References: <43235.62.70.2.252.1234947353.squirrel@webmail.xs4all.nl>
	<Pine.LNX.4.58.0902210343520.24268@shell2.speakeasy.net>
	<20090221141130.1c4f1265@hyperion.delvare>
	<200902211428.31814.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 21 Feb 2009 14:28:31 +0100, Hans Verkuil wrote:
> On Saturday 21 February 2009 14:11:30 Jean Delvare wrote:
> > Well, that's basically what Hans has been doing with
> > v4l2-i2c-drv-legacy.h for months now, isn't it? This is the easy part
> > (even though even this wasn't exactly trivial...)
> 
> Sorry, that's not quite true. v4l2-i2c-drv-legacy.h is for i2c modules that 
> are either called new-style (by converted adapter drivers) or old-style (by 
> not-yet converted adapter drivers). It does that by creating two i2c_driver 
> instances, one for each variant. By contrast, i2c modules that include 
> v4l2-i2c-drv.h can only be called by converted adapter drivers. This has 
> nothing to do with detect(). I'm not using that at all.
> 
> It was always the intention that the legacy.h header would disappear once 
> all adapter drivers are converted. But v4l2-i2c-drv.h still has to support 
> kernels < 2.6.22 were the new API doesn't exist at all. That's the sticking 
> point that prevents us from dropping this header as well and go back to a 
> normally written i2c module without all this nonsense.
> 
> You may have meant the same thing, Jean, but I thought I should clarify it 
> yet a bit more :-)

Thanks for the clarification. This just shows one thing: this
compatibility layer has become so complex that even I lose track of what
is what...

> (...)
> The point is not how easy or complicated these headers are, the point is 
> that we shouldn't have them at all since they make no sense in the upstream 
> kernel.

True...

-- 
Jean Delvare
