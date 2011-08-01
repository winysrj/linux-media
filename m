Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:43677 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753388Ab1HAB2X (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 31 Jul 2011 21:28:23 -0400
Message-ID: <4E360134.6010102@iki.fi>
Date: Mon, 01 Aug 2011 04:28:20 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Patrick Boettcher <pboettcher@kernellabs.com>
CC: Malcolm Priestley <tvboxspy@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 2/3] dvb-usb: multi-frontend support (MFE)
References: <4E2E0788.3010507@iki.fi> <1311804451.9058.20.camel@localhost> <4E308FCA.9090509@iki.fi> <201107312028.02342.pboettcher@kernellabs.com>
In-Reply-To: <201107312028.02342.pboettcher@kernellabs.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/31/2011 09:28 PM, Patrick Boettcher wrote:
> On Thursday 28 July 2011 00:23:06 Antti Palosaari wrote:
>> * We should have priv at the very first. No priv for FW DL example.
>> * Remote keytable should be property of certain device model not adapter
>> * There should be way to set count of adapter (and fe) in runtime (this
>> is why I allowed to fail 2nd FE attach silently)
>> * no probe (read eeprom etc) callback (I think read MAC could be renamed
>> for probe)
>> * no FE power control (GPIOs etc) that MFE patch adds this too
>> * maybe probe1 and probe2 callbacks needed. sequence something like plug
>> device => probe1 => download FW => probe2 => attach demod
> 
> If I had more time I'd add 
> 
> * handle suspend/resume calls properly for buggy USB firmwares (iow: all 
> devices I saw)

I think I will try to change next that priv is accessible at the very
first. That's rather big problem since there is multiple drivers needing
priv for communication (buffers, msg seq numbers, etc) for example fw
loading.

After that I see important to move remote keytable mapping to level
where is USB IDs, device name and such info.

regards
Antti

-- 
http://palosaari.fi/
