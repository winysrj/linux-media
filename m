Return-path: <mchehab@pedra>
Received: from mail.kapsi.fi ([217.30.184.167]:56209 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756556Ab1DBTQn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 2 Apr 2011 15:16:43 -0400
Message-ID: <4D977619.4080607@iki.fi>
Date: Sat, 02 Apr 2011 22:16:41 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Sami Haahtinen <sami@haahtinen.name>
CC: linux-media@vger.kernel.org
Subject: Re: Anysee E30 Combo Plus failing to tune
References: <BANLkTikXBUFjU-BjHv9LO2eTVn31rvdivQ@mail.gmail.com>
In-Reply-To: <BANLkTikXBUFjU-BjHv9LO2eTVn31rvdivQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Moi Sami,

On 04/02/2011 09:52 PM, Sami Haahtinen wrote:
> Hey,
> I have a Anysee E30 Combo Plus and i'm having trouble getting it to
> detect properly. According to various sources it should be supported,
> but yet it fails for me. I've tried with the stock driver and the
> backports one (one instructed in wiki) and neither work.

I think your device is newer model where is new DNOD44CDV086A tuner 
module and inside that module is TDA18212 silicon tuner which does not 
have working driver yet. If your device have antenna loop-through it 
does have this new tuner module.

Unfortunately I don't have this device model, I got older one :-(. But 
luckily enough I have got E7TC which is almost similar as E30 Combo. I 
have DVB-C and DVB-T picture out from E7TC, it is just up to few weeks I 
will get TDA18212 tuner driver ready.



Antti


-- 
http://palosaari.fi/
