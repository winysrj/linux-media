Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:49625 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756710Ab1FPPfG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jun 2011 11:35:06 -0400
Message-ID: <4DFA22A5.1080303@redhat.com>
Date: Thu, 16 Jun 2011 12:35:01 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Some fixes for alsa_stream
References: <4DF6C10C.8070605@redhat.com>	<4DF758AF.3010301@redhat.com>	<4DF75C84.9000200@redhat.com>	<4DF7667C.9030502@redhat.com> <BANLkTi=9L+oxjpUaFo3ge0iqcZ2NCjJWWA@mail.gmail.com> <4DF76D88.5000506@redhat.com> <4DF77229.2020607@redhat.com> <4DF77405.2070104@redhat.com> <4DF8B716.1020406@redhat.com> <4DF8C0D2.5070900@redhat.com> <4DF8C32A.7090004@redhat.com> <4DF8D37C.7010307@redhat.com> <4DF9F734.1090508@redhat.com> <4DFA1561.1030905@redhat.com> <4DFA1D05.6020004@redhat.com>
In-Reply-To: <4DFA1D05.6020004@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 16-06-2011 12:11, Hans de Goede escreveu:

>>> I've also changed the default -alsa-pb value to "default" as we should
>>> not be picking something else then the user / distro configured defaults
>>> for output IMHO. The user can set a generic default in alsarc, and override
>>> that on the cmdline if he/she wants, but unless overridden on the cmdline
>>> we should respect the users generic default as specified in his
>>> alsarc.
>>
>> While pulseaudio refuses to work via ssh, this is actually a very bad idea.
>> Xawtv is used by developers to test their stuff, and they generally do it
>> on a remote machine, with the console captured via tty port, in order to
>> be able to catch panic messages.
>>
> 
> I'm sure developers are quite capable of creating either an .alsarc, pass
> the cmdline option, or change pulseaudio's config to accept non local console
> connections.

As far as I noticed, most media developers seems to not be comfortable with 
pulseaudio. Using pulseaudio by default would require more experience from
developers, otherwise nobody will be able to properly support it.

For example, the only way I know that works to remove an audio 
module used by pulseaudio is by doing dirty tricks like: 

while : ; do kill pulseaudio; rmmod <audio_module> && break; done

I was told that there's a pactl syntax, but I was never able to find how to
make it work, not even on a local console (and I need it supported via ssh).
>From other posts, other developers at this ML also didn't discover how to do 
it yet.

A pulseaudio or .alsarc config to enable ssh would be fine, but, again,
that's not obvious.

While developers are not comfortable with pulseaudio, turning it into a default
is a bad idea.

> 
> We should try to have sane user oriented defaults, not developer oriented
> defaults.
> 
> Also not all developers work the same way you do, so having a certain default
> just so it matches your work flow also is a bad idea IMHO.
> 
>> For now, please revert this patch. After having pulseaudio fixed to properly
>> handle the audio group, I'm ok to re-add it.
>>
>>> We could consider making the desired latency configurable, currently
>>> I've hardcoded it to 30 ms (was 38 with the old code on my system) note
>>> that I've chosen to specify the latency in ms rather then in a number
>>> of samples, since it should be samplerate independent IMO.
>>
>> Yeah, having latency configurable sounds a good idea to me.
> 
> Done.

Thanks!

Mauro
