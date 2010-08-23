Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61120 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753732Ab0HWOQC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Aug 2010 10:16:02 -0400
Received: by wwe15 with SMTP id 15so155311wwe.1
        for <linux-media@vger.kernel.org>; Mon, 23 Aug 2010 07:16:01 -0700 (PDT)
Message-ID: <4C72829F.7040207@gmail.com>
Date: Mon, 23 Aug 2010 16:15:59 +0200
From: "tomlohave@gmail.com" <tomlohave@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: patch for lifeview hybrid mini
References: <4C67790D.3060600@gmail.com> <1282004685.8749.50.camel@pc07.localdom.local>
In-Reply-To: <1282004685.8749.50.camel@pc07.localdom.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Le 17/08/2010 02:24, hermann pitton a écrit :
> Hi,
>
> Am Sonntag, den 15.08.2010, 07:20 +0200 schriebtomlohave@gmail.com:
>    
>> Hi,
>>
>> the proposed patch is 6 month old and the owner of the card does not
>> give any more sign of life for the support of the radio.
>> can someone review it and push it as is?
>>
>> Cheers,
>>
>> Signed-off-by: thomas genty<tomlohave@gmail.com>
>>
>>      
> Thomas, just some quick notes, since nobody else cares.
>
> The m$ regspy gpio logs do show only gpio22 changing for analog and
> DVB-T and this should be the out of reference AGC control on a hopefully
> single hybrid tuner on that device called DUO.
>
> Remember, gpios not set in the mask of the analog part of the device do
> not change/switch anything, but those set there will change to zero even
> without explicit gpio define for that specific analog input.
>
> Out of historical reasons, we don't have this in our logs for DVB, also
> else they would be littered by the changing gpios for the TS/MPEG
> interface, but should be OK. We don't need to mark DVB related gpio
> stuff in the analog gpio mask, since we need to use some sort of hack to
> switch gpios on saa713x in DVB mode.
>
> dvb and v4l still don't know much about what each other subsystem does
> on that, but we have some progress.
>
> So, for now, I don't know for what gpio21 high in analog TV mode should
> be good, since the m$ driver seems not to do anything on that one, for
> what we have so far. Also it is common on later LifeView stuff (arrgh),
> but always is present in related logs then too.
>
> If ever needed,
>
> despite of that line inputs and muxes are also totally unconfirmed, and
> radio is plain madness ...
>
> drop the radio support for now, mark the external inputs as untested and
> I give some reviewed by so far with headaches.
>
> If we can't get more from here anymore, we must let it bounce.
>
> Cheers,
> Hermann
>
>
>
>    

Hi Hermann,

thanks for you response

for gpios : there is no software bundled with this card to listen to the 
radio so there is maybe a gpio not showed
in regspy when trying to listen music. Is this a bad assumption?
anyway gpios 22 and 16 are hight in regspy
with gpiomask 410 000 :
dvb, analog tv and svideo work fine
only radio remains :
you can hear the results for radio here (2 Mo):
http://perso.orange.fr/tomlohave/linux/radio.test
we can clearly hear the sound of a song but it is broken and 
interrupted, the question is why
have you a suggestion ?

Cheers

T.G
