Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp5-g21.free.fr ([212.27.42.5]:33830 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751578AbZDXQHF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Apr 2009 12:07:05 -0400
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH/RFC] soc-camera: Convert to a platform driver
References: <Pine.LNX.4.64.0904061207530.4285@axis700.grange>
	<87iqlgkykd.fsf@free.fr>
	<Pine.LNX.4.64.0904241258350.4201@axis700.grange>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Fri, 24 Apr 2009 18:06:54 +0200
In-Reply-To: <Pine.LNX.4.64.0904241258350.4201@axis700.grange> (Guennadi Liakhovetski's message of "Fri\, 24 Apr 2009 13\:00\:04 +0200 \(CEST\)")
Message-ID: <87eivivxwh.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:

>> >  /* Board I2C devices. */
>> I would rather have :
>> /*
>>  * Board I2C devices
>>  */
>
> As a matter of fact (from git-blame):
>
> 8e7ccddf (Robert Jarzmik 2008-11-15 16:09:54 +0100 732) /* Board I2C devices. */
Yeah, nobody is perfect I guess.
It's hard to review oneself. Anyway, if you change that line, I'd rather have it
the other way around. If you don't, I'll repair it later.

>> The remaining /* blurpblurg */ forms are a leftover in device comments.
Leftover in device comments, backlight comment, I2C comments.

Cheers.

--
Robert
