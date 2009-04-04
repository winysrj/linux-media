Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:61110 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752907AbZDDWcH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 4 Apr 2009 18:32:07 -0400
Subject: Re: [PATCH 1/6] cx18: Fix the handling of i2c bus registration
	error
From: Andy Walls <awalls@radix.net>
To: Jean Delvare <khali@linux-fr.org>
Cc: LMML <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Mike Isely <isely@pobox.com>
In-Reply-To: <20090404162355.511d872d@hyperion.delvare>
References: <20090404142427.6e81f316@hyperion.delvare>
	 <20090404142651.44757ccb@hyperion.delvare>
	 <1238849160.2845.12.camel@morgan.walls.org>
	 <20090404162355.511d872d@hyperion.delvare>
Content-Type: text/plain
Date: Sat, 04 Apr 2009 18:30:43 -0400
Message-Id: <1238884243.2995.34.camel@morgan.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2009-04-04 at 16:23 +0200, Jean Delvare wrote:
> Hi Andy,
> 
> Thanks for the fast review.
> 
> On Sat, 04 Apr 2009 08:46:00 -0400, Andy Walls wrote:

> 
> Correct, actually my initial attempt looked like this. But then patch
> 3/6 adds code, which makes "your" solution 2 lines bigger, while "my"
> solution stays as is, so the difference between both becomes very thin.
> 
> Some developers (including me) prefer to have a single error path,
> others hate gotos more than (potential) code duplication. I didn't know
> what you'd prefer as the driver maintainer. If you want me to use the
> variant without gotos, I can do that, no problem.

Meh, whichever way you like is fine for now.  If I really decide to care
about it, I'll muck with it when I get the hardware I2C masters working.
I'll have to touch that section of code at that time anyway.

Acked-by: Andy Walls <awalls@radix.net>

Regards,
Andy


