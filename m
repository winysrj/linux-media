Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:45376
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161AbcF3PIa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jun 2016 11:08:30 -0400
Date: Thu, 30 Jun 2016 12:01:05 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Steven Toth <stoth@kernellabs.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Michael Ira Krufky <mkrufky@linuxtv.org>
Subject: Re: [PATCH 08/10] dvb_frontend: create a new ops to help returning
 signals in dB
Message-ID: <20160630120105.5fbdecf2@recife.lan>
In-Reply-To: <CALzAhNUdS_aQ+gTHAJ02whAuUcOOpTpJUo33NK7FWYx_EmgSjQ@mail.gmail.com>
References: <0003e025f7664aae1500f084bbd6f7aa5d92d47f.1467240152.git.mchehab@s-opensource.com>
	<790b5e1664c84e806a13143eff1c79b95fb4bf63.1467240152.git.mchehab@s-opensource.com>
	<CALzAhNUdS_aQ+gTHAJ02whAuUcOOpTpJUo33NK7FWYx_EmgSjQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steven,

Em Thu, 30 Jun 2016 09:48:30 -0400
Steven Toth <stoth@kernellabs.com> escreveu:

> > add a new ops that will allow tuners to better report the
> > dB level of its AGC logic to the demod drivers. As the maximum
> > gain may vary from tuner to tuner, we'll be reversing the
> > logic here: instead of reporting the gain, let's report the
> > attenuation. This way, converting from it to the legacy DVBv3
> > way is trivial. It is also easy to adjust the level of
> > the received signal to dBm, as it is just a matter of adding
> > an offset at the demod and/or at the bridge driver.  
> 
> Mauro,
> 
> Have you verified this work with a detailed spectrum analysis study?
> If so then please share. For example, by measuring the I/F out of
> various tuners in a mix of use cases, with and without the AGC being
> driven by any downstream demodulator? Also, taking into consideration
> any external LNA variance.
> 
> I'm concerned that a tuner AGC Gain is a meaningless measurement and
> in practice demodulators don't actually care, and tuners don't
> implement their gain reporting capabilities correctly at all.
> 
> This feels like a solution to a problem that doesn't exist.

The role idea here is to provide a rough estimation about the signal
strength, and not to enter into the measurement instrument business.

I know that the actual tuner AGC gain is not precise[1]:
	- it may vary with the frequency;
	- it may vary with the component variance;
	- it may vary with modulation parameters;
	- it may vary with the temperature.

Yet, the signal strength is used on some software to detect "weak"
signals and skip such transponders. There is such code, for example
in Kaffeine since 2009:
	commit 73a5aae68ab46d761267043c9774289833b79dbc
	Author: Christoph Pfister <christophpfister@gmail.com>
	Date:   Sat Apr 25 13:41:28 2009 +0000

	    add autoscan support

+               if ((signal != 0) && (signal < 0x2000)) {
+                       // signal too weak
+                       carry = false;
+               }

The color on Kaffeine's gauge gradient bar also tries to express if
the signal level is OK or not, showing only red for weak signals,
and becoming green as the signal increases up to a certain level.

The strength is also one parameters to estimate the signal quality.
The libdvbv5 considers it, when reporting DTV_QUALITY parameter.

So, the hole idea here is *not* to provide a precise measure, but
to try to use about the same scale on the drivers, whenever
possible.

Regards,
Mauro

[1] I would give a 5-stars here for Siano: on the tests I did, the
signal strength reported by the siano devices is very precise.


Thanks,
Mauro
