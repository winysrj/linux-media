Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:39910 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452Ab1GaS1s (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 31 Jul 2011 14:27:48 -0400
Received: by wwe5 with SMTP id 5so4960599wwe.1
        for <linux-media@vger.kernel.org>; Sun, 31 Jul 2011 11:27:47 -0700 (PDT)
From: Patrick Boettcher <pboettcher@kernellabs.com>
To: Antti Palosaari <crope@iki.fi>
Subject: Re: [PATCH 2/3] dvb-usb: multi-frontend support (MFE)
Date: Sun, 31 Jul 2011 20:28:01 +0200
Cc: Malcolm Priestley <tvboxspy@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
References: <4E2E0788.3010507@iki.fi> <1311804451.9058.20.camel@localhost> <4E308FCA.9090509@iki.fi>
In-Reply-To: <4E308FCA.9090509@iki.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201107312028.02342.pboettcher@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 28 July 2011 00:23:06 Antti Palosaari wrote:
> On 07/28/2011 01:07 AM, Malcolm Priestley wrote:
> > On Wed, 2011-07-27 at 16:06 -0300, Mauro Carvalho Chehab wrote:
> >> Em 25-07-2011 21:17, Antti Palosaari escreveu:
> >>> Signed-off-by: Antti Palosaari<crope@iki.fi>
> >>> 
> >>> +            adap->fe[i] = NULL;
> >>> +            /* In error case, do not try register more FEs,
> >>> +             * still leaving already registered FEs alive. */
> >> 
> >> I think that the proper thing to do is to detach everything, if one of
> >> the attach fails. There isn't much sense on keeping the device
> >> partially initialized.
> >> 
> >> From memory, I recall the existing code doesn't detach the frontend
> >> even
> > 
> > if the device driver forces an error. So, the device driver must detach
> > the frontend first.
> 
> Yes, if you return for example error (or fe == NULL) for .tuner_attach()
> it does not detach or deregister it - just silently discard all. I
> thought very many times those when implementing this and keep very
> careful not to change old functionality.
> 
> > The trouble is that dvb-usb is becoming dated as new drivers tend to
> > work around it. No one likes to touch it, out of fear of breaking
> > existing drivers.
> 
> Yes, so true. I have thought that too. There is a lot of things I want
> to change but those are very hard without massive work.
> 
> * We should have priv at the very first. No priv for FW DL example.
> * Remote keytable should be property of certain device model not adapter
> * There should be way to set count of adapter (and fe) in runtime (this
> is why I allowed to fail 2nd FE attach silently)
> * no probe (read eeprom etc) callback (I think read MAC could be renamed
> for probe)
> * no FE power control (GPIOs etc) that MFE patch adds this too
> * maybe probe1 and probe2 callbacks needed. sequence something like plug
> device => probe1 => download FW => probe2 => attach demod

If I had more time I'd add 

* handle suspend/resume calls properly for buggy USB firmwares (iow: all 
devices I saw)

--
Patrick Boettcher - KernelLabs
http://www.kernellabs.com/
