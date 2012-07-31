Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:52469 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753640Ab2GaWIF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Jul 2012 18:08:05 -0400
Message-ID: <50185739.8090605@iki.fi>
Date: Wed, 01 Aug 2012 01:07:53 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Reporting signal overload condition for tuners?
References: <CAGoCfizvvq7C+axexewU_wrmhhggoiNJ7D5H3=SPfa3jaxpVcA@mail.gmail.com>
In-Reply-To: <CAGoCfizvvq7C+axexewU_wrmhhggoiNJ7D5H3=SPfa3jaxpVcA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/31/2012 10:56 PM, Devin Heitmueller wrote:
> Quick question:  we don't currently have any way to report to userland
> that a tuning is failing due to signal overload, right?

right

I assume you speak issue where signal is too strong and tuner (or demod 
too?) makes it broken / too noisy for demod.

> There are some tuner chips out there which can detect this condition,
> and being able to report it back to userland would make it much easier
> to inform the user that he/she needs to stick an attenuator inline.

I have never seen such property.

Is that condition something like (RF?) gain control is set minimum but 
signal strength meter is still maximum...

> Has anybody given any thought to this before?  Perhaps use up the last
> available bit in fe_status for DVB?

I left other negative side of LNA integer unused, just thinking it could 
be extended for attenuator. It does not fit for that case, but I have 
seen such feature used by anysee Windows driver. There has been problems 
with strong DVB-C signal in case of TDA10023 demod. I don't know how 
this software attenuator is implemented but I could guess it is done by 
tweaking some tuner or demod property a little bit wrong in order to 
make signal weaker.

And answer for the question is you should likely add new DVBv5 property 
for reading that. I don't like idea of adding such info for frontend status.

regards
Antti

-- 
http://palosaari.fi/
