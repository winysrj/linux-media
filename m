Return-path: <linux-media-owner@vger.kernel.org>
Received: from skyboo.net ([82.160.187.4]:35116 "EHLO draco.skyboo.net"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750856AbZHILHO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 9 Aug 2009 07:07:14 -0400
Received: from manio ([10.1.0.2])
	by draco.skyboo.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <manio@skyboo.net>)
	id 1Ma6F7-0003Dd-2A
	for linux-media@vger.kernel.org; Sun, 09 Aug 2009 13:07:13 +0200
Message-ID: <4A7E8121.4040406@skyboo.net>
Date: Sun, 09 Aug 2009 09:56:17 +0200
From: manio <manio@skyboo.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: SAA7146 / TT1.3 stream corruption
References: <4A7471D2.3070004@skyboo.net>
In-Reply-To: <4A7471D2.3070004@skyboo.net>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

manio wrote:

 > Hello
 > I am using Technotrend Rev1.3 for many years. But last time
 > suddenly i find out strange problem. Seems that in some
 > circumstances the card can't decode stream from satellite properly.
 > I don't know for sure but it could be a driver problem, firmware
 > or even (worse) a hardware problem.

Now i can reply myself to provide info for users with similar problem.

The parameter which i need is:
hw_sections=1
When i load dvb_ttpci module with this parameter the stream is correct.
Just by the way: people on DVBN forum has similar issues, but this
parameter was not sufficient - they also need to write a patch for
select pid ranges for providers (in their case: BEV and DN)
More info on dvbn topics#: 42822 and 42653

regards,
-- 
manio
jabber/e-mail: manio@skyboo.net
http://manio.skyboo.net
