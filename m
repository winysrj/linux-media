Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:50738 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751210Ab3FDKS3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 4 Jun 2013 06:18:29 -0400
Message-ID: <51ADBECD.1070102@iki.fi>
Date: Tue, 04 Jun 2013 13:17:49 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Luca Olivetti <luca@ventoso.org>
CC: linux-media@vger.kernel.org
Subject: Re: Diversity support?
References: <507EE702.2010103@ventoso.org> <5091691A.4070903@ventoso.org> <51ACB2CA.6060503@ventoso.org> <51AD23F1.1050903@iki.fi> <51AD9758.2050009@ventoso.org>
In-Reply-To: <51AD9758.2050009@ventoso.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/04/2013 10:29 AM, Luca Olivetti wrote:
> Al 04/06/13 01:17, En/na Antti Palosaari ha escrit:
>
>>> I'm not easily discouraged :-) so here's the question again: is there
>>> some dvb-t usb stick (possibly available on the EU market) with
>>> diversity support under Linux?
>>
>> I have feeling AF9035/IT9135 dual devices could do that.
>
> Looking at the wiki, most devices based on those demodulators are either
> unsupported or have a dual tuner but not diversity.

Because diversity is not interesting feature at all in normal use case. 
Whole DVB-T standard fits poorly for mobile usage and you cannot make 
situation that much better using diversity.

Dual hardware could support diversity, but it is not usually enabled by 
software.


regards
Antti

-- 
http://palosaari.fi/
