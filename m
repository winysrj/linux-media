Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp03.smtpout.orange.fr ([80.12.242.125]:28865 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932133AbbEMTy7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 May 2015 15:54:59 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org
Subject: Re: v4.1-rcX regression in v4l2 build
References: <87d225mve4.fsf@belgarion.home>
	<Pine.LNX.4.64.1505122221150.11250@axis700.grange>
	<Pine.LNX.4.64.1505122302570.11250@axis700.grange>
	<87pp64l1o4.fsf@belgarion.home>
	<20150513194844.GS2067@n2100.arm.linux.org.uk>
Date: Wed, 13 May 2015 21:54:06 +0200
In-Reply-To: <20150513194844.GS2067@n2100.arm.linux.org.uk> (Russell King's
	message of "Wed, 13 May 2015 20:48:44 +0100")
Message-ID: <87h9rgl0dd.fsf@belgarion.home>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Russell King - ARM Linux <linux@arm.linux.org.uk> writes:

> On Wed, May 13, 2015 at 09:26:03PM +0200, Robert Jarzmik wrote:
>> First, a question for Russell :
>>   Given that the current PXA architecture is not implementing the
>>   clk_round_rate() function, while implementing clk_get(), etc..., is it correct
>>   to say that it is betraying the clk API by doing so ?
>
> Really, yes.  PXA used to be self-contained as far as clk API usage, and
> so it only ever implemented what it needed from the API to support the
> SoC.  Now that things are getting "more complicated" then the other
> functions will probably be needed.
So I thought, thanks.

Cheers.

-- 
Robert
