Return-path: <mchehab@gaivota>
Received: from mail.bluewatersys.com ([202.124.120.130]:29768 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758734Ab1ELV3S (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 May 2011 17:29:18 -0400
Message-ID: <4DCC512E.1000603@bluewatersys.com>
Date: Fri, 13 May 2011 09:29:18 +1200
From: Ryan Mallon <ryan@bluewatersys.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
	mchehab@redhat.com, linux-kernel@vger.kernel.org,
	Josh Wu <josh.wu@atmel.com>, lars.haring@atmel.com,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] at91: add Atmel Image Sensor Interface (ISI)
 support
References: <1305186138-5656-1-git-send-email-josh.wu@atmel.com>	<20110512114530.GE18952@game.jcrosoft.org> <Pine.LNX.4.64.1105121413220.24486@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1105121413220.24486@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On 05/13/2011 12:14 AM, Guennadi Liakhovetski wrote:
> On Thu, 12 May 2011, Jean-Christophe PLAGNIOL-VILLARD wrote:
> 
> [snip]
> 
>>> +	if (0 == *nbuffers)
>> please invert the test
> 
> Don't think this is required by CodingStyle or anything like that. If it 
> were, you'd have to revamp half of the kernel.

It should at least be consistent within a file, which it is not true in
this case. I think the preferred style is to have the variable on the left.

~Ryan

-- 
Bluewater Systems Ltd - ARM Technology Solution Centre

Ryan Mallon         		5 Amuri Park, 404 Barbadoes St
ryan@bluewatersys.com         	PO Box 13 889, Christchurch 8013
http://www.bluewatersys.com	New Zealand
Phone: +64 3 3779127		Freecall: Australia 1800 148 751
Fax:   +64 3 3779135			  USA 1800 261 2934
