Return-path: <mchehab@pedra>
Received: from zone0.gcu-squad.org ([212.85.147.21]:18694 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673Ab0JEQqF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Oct 2010 12:46:05 -0400
Date: Tue, 5 Oct 2010 18:45:50 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Pete Eberlein <pete@sensoray.com>,
	Mike Isely <isely@pobox.com>,
	Eduardo Valentin <eduardo.valentin@nokia.com>,
	Andy Walls <awalls@md.metrocast.net>,
	Vaibhav Hiremath <hvaibhav@ti.com>,
	Muralidharan Karicheri <mkaricheri@gmail.com>
Subject: Re: [PATCH 00/16] Use modaliases to load I2C modules - please
 review
Message-ID: <20101005184550.7a0527ea@endymion.delvare>
In-Reply-To: <Pine.LNX.4.64.1010051833100.31708@axis700.grange>
References: <1285337654-5044-1-git-send-email-laurent.pinchart@ideasonboard.com>
	<Pine.LNX.4.64.1009242057570.18077@axis700.grange>
	<Pine.LNX.4.64.1010051833100.31708@axis700.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Guennadi,

On Tue, 5 Oct 2010 18:41:09 +0200 (CEST), Guennadi Liakhovetski wrote:
> Hm, maybe testing patches between packing and completing a thousand of 
> other things was not a very good idea... In any case, I think, it has been 
> something in my rootfs. Can it be, that modules, loaded per modalias and 
> per explicit module names interact differently with module blacklists? 
> That would explain the different behaviour, that I've been observing.

As far as I know, blacklisting only affects alias-based module loading.
Explicit module loading isn't affected by blacklisting.

This is one more good reason to use module aliases where possible,
BTW... Respecting user-defined blacklisting is desirable.

-- 
Jean Delvare
