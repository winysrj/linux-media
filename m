Return-path: <mchehab@pedra>
Received: from mail.kapsi.fi ([217.30.184.167]:55009 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752226Ab1CTThn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Mar 2011 15:37:43 -0400
Message-ID: <4D865783.20808@iki.fi>
Date: Sun, 20 Mar 2011 21:37:39 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Lucio Crusca <lucio@sulweb.org>
CC: linux-media@vger.kernel.org
Subject: Re: AF9015 problems
References: <201103202010.33892.lucio@sulweb.org>
In-Reply-To: <201103202010.33892.lucio@sulweb.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 03/20/2011 09:10 PM, Lucio Crusca wrote:
> I'm trying to tune a AF9015, but w_scan finds only 4 tv services, while the
> same dongle attached to the same antenna cable, on the same computer, with
> Windows Media Center finds as much as 135 tv services.
>
> The 4 services it finds are all from the same 205500 KHz transponder. Any clue?

[...]

> 205500: (time: 00:10) (time: 00:13) signal ok:
>          QAM_AUTO f = 205500 kHz I999B7C999D999T999G999Y999
>          new transponder:
>             (QAM_64   f = 1600000 kHz I999B8C34D0T8G16Y0)

[...]

> tune to: QAM_64   f = 1600000 kHz I999B8C34D0T8G16Y0
> (time: 02:53) set_frontend:1703: ERROR: Setting frontend parameters failed
> (API v5.x)
> : 22 Invalid argument
> tune to: QAM_64   f = 1600000 kHz I999B8C34D0T8G16Y0
> (time: 02:53) set_frontend:1703: ERROR: Setting frontend parameters failed
> (API v5.x)
> : 22 Invalid argument
> dumping lists (7 services)
> Done.

1600000 kHz == 1600 MHz == 1.6 GHz
uh, operator have configured wrongly neighbour transponders ?


I have still no knowledge why scanning didn't find any other freqs. If 
there is error in driver then most likely it is TDA18218HN tuner driver 
issue since thats reverse-engineered one and without modulator I cannot 
ran very much tests.

Could you say which are missing freqs and bandwidth of those freqs?


Antti

-- 
http://palosaari.fi/
