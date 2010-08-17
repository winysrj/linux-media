Return-path: <mchehab@pedra>
Received: from mail-in-01.arcor-online.net ([151.189.21.41]:58031 "EHLO
	mail-in-01.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753518Ab0HQA1c (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Aug 2010 20:27:32 -0400
Subject: Re: patch for lifeview hybrid mini
From: hermann pitton <hermann-pitton@arcor.de>
To: "tomlohave@gmail.com" <tomlohave@gmail.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <4C67790D.3060600@gmail.com>
References: <4C67790D.3060600@gmail.com>
Content-Type: text/plain
Date: Tue, 17 Aug 2010 02:24:45 +0200
Message-Id: <1282004685.8749.50.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hi,

Am Sonntag, den 15.08.2010, 07:20 +0200 schrieb tomlohave@gmail.com:
> Hi,
> 
> the proposed patch is 6 month old and the owner of the card does not 
> give any more sign of life for the support of the radio.
> can someone review it and push it as is?
> 
> Cheers,
> 
> Signed-off-by: thomas genty<tomlohave@gmail.com>
> 

Thomas, just some quick notes, since nobody else cares.

The m$ regspy gpio logs do show only gpio22 changing for analog and
DVB-T and this should be the out of reference AGC control on a hopefully
single hybrid tuner on that device called DUO.

Remember, gpios not set in the mask of the analog part of the device do
not change/switch anything, but those set there will change to zero even
without explicit gpio define for that specific analog input.

Out of historical reasons, we don't have this in our logs for DVB, also
else they would be littered by the changing gpios for the TS/MPEG
interface, but should be OK. We don't need to mark DVB related gpio
stuff in the analog gpio mask, since we need to use some sort of hack to
switch gpios on saa713x in DVB mode.

dvb and v4l still don't know much about what each other subsystem does
on that, but we have some progress.

So, for now, I don't know for what gpio21 high in analog TV mode should
be good, since the m$ driver seems not to do anything on that one, for
what we have so far. Also it is common on later LifeView stuff (arrgh),
but always is present in related logs then too.

If ever needed,

despite of that line inputs and muxes are also totally unconfirmed, and
radio is plain madness ...

drop the radio support for now, mark the external inputs as untested and
I give some reviewed by so far with headaches.

If we can't get more from here anymore, we must let it bounce.

Cheers,
Hermann












