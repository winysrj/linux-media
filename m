Return-path: <mchehab@pedra>
Received: from mail.kapsi.fi ([217.30.184.167]:40731 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751991Ab1FOXOo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Jun 2011 19:14:44 -0400
Message-ID: <4DF93CE2.8050201@iki.fi>
Date: Thu, 16 Jun 2011 02:14:42 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Juergen Lock <nox@jelal.kn-bremen.de>
CC: linux-media@vger.kernel.org, hselasky@c2i.net
Subject: Re: [PATCH] [media] af9015: setup rc keytable for LC-Power LC-USB-DVBT
References: <20110612202512.GA63911@triton8.kn-bremen.de> <201106122215.p5CMF0Xr069931@triton8.kn-bremen.de> <4DF53CB6.109@iki.fi> <20110612223437.GB71121@triton8.kn-bremen.de> <4DF542CE.4040903@iki.fi> <20110612230100.GA71756@triton8.kn-bremen.de> <4DF54FC2.2020104@iki.fi> <20110613003845.GA75278@triton8.kn-bremen.de>
In-Reply-To: <20110613003845.GA75278@triton8.kn-bremen.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Moikka Juergen,

On 06/13/2011 03:38 AM, Juergen Lock wrote:
> af9015_rc_query: key repeated

>   Does that help?

Repeat check logick in function af9015_rc_query() is failing for some 
reason. You could try to look that function and checks if you wish as I 
cannot reproduce it.

Add debug dump immediately after registers are read and look from log 
what happens.

debug_dump(buf, 17, deb_rc);


regards
Antti

-- 
http://palosaari.fi/
