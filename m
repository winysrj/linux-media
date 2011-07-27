Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:53826 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752659Ab1G0WXK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jul 2011 18:23:10 -0400
Message-ID: <4E308FCA.9090509@iki.fi>
Date: Thu, 28 Jul 2011 01:23:06 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Malcolm Priestley <tvboxspy@gmail.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 2/3] dvb-usb: multi-frontend support (MFE)
References: <4E2E0788.3010507@iki.fi>  <4E3061CF.2080009@redhat.com> <1311804451.9058.20.camel@localhost>
In-Reply-To: <1311804451.9058.20.camel@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/28/2011 01:07 AM, Malcolm Priestley wrote:
> On Wed, 2011-07-27 at 16:06 -0300, Mauro Carvalho Chehab wrote:
>> Em 25-07-2011 21:17, Antti Palosaari escreveu:
>>> Signed-off-by: Antti Palosaari<crope@iki.fi>

>>> +            adap->fe[i] = NULL;
>>> +            /* In error case, do not try register more FEs,
>>> +             * still leaving already registered FEs alive. */
>>
>> I think that the proper thing to do is to detach everything, if one of
>> the attach fails. There isn't much sense on keeping the device partially
>> initialized.
>>
>> From memory, I recall the existing code doesn't detach the frontend even
> if the device driver forces an error. So, the device driver must detach
> the frontend first.

Yes, if you return for example error (or fe == NULL) for .tuner_attach() 
it does not detach or deregister it - just silently discard all. I 
thought very many times those when implementing this and keep very 
careful not to change old functionality.

> The trouble is that dvb-usb is becoming dated as new drivers tend to
> work around it. No one likes to touch it, out of fear of breaking
> existing drivers.

Yes, so true. I have thought that too. There is a lot of things I want 
to change but those are very hard without massive work.

* We should have priv at the very first. No priv for FW DL example.
* Remote keytable should be property of certain device model not adapter
* There should be way to set count of adapter (and fe) in runtime (this 
is why I allowed to fail 2nd FE attach silently)
* no probe (read eeprom etc) callback (I think read MAC could be renamed 
for probe)
* no FE power control (GPIOs etc) that MFE patch adds this too
* maybe probe1 and probe2 callbacks needed. sequence something like plug 
device => probe1 => download FW => probe2 => attach demod


> I think perhaps some kind of legacy wrapper is needed here, with the
> moving of dvb-usb to its own core, so more development work can be done.

Wish like to thank you these comments Malcolm!

regards
Antti

-- 
http://palosaari.fi/
