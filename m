Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:53043 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756391Ab1FPPKX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jun 2011 11:10:23 -0400
Message-ID: <4DFA1D05.6020004@redhat.com>
Date: Thu, 16 Jun 2011 17:11:01 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Some fixes for alsa_stream
References: <4DF6C10C.8070605@redhat.com>	<4DF758AF.3010301@redhat.com>	<4DF75C84.9000200@redhat.com>	<4DF7667C.9030502@redhat.com> <BANLkTi=9L+oxjpUaFo3ge0iqcZ2NCjJWWA@mail.gmail.com> <4DF76D88.5000506@redhat.com> <4DF77229.2020607@redhat.com> <4DF77405.2070104@redhat.com> <4DF8B716.1020406@redhat.com> <4DF8C0D2.5070900@redhat.com> <4DF8C32A.7090004@redhat.com> <4DF8D37C.7010307@redhat.com> <4DF9F734.1090508@redhat.com> <4DFA1561.1030905@redhat.com>
In-Reply-To: <4DFA1561.1030905@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

On 06/16/2011 04:38 PM, Mauro Carvalho Chehab wrote:
> Em 16-06-2011 09:29, Hans de Goede escreveu:

<snip>

>> Note that I've just pushed a patch set which includes rewritten period
>> / buf size negotiation and a bunch of cleanups in general. This removes
>> over 150 lines of code, while at the same time making the code more
>> flexible.
>
> You removed mmap support, but you didn't removed the alsa-mmap option at xawtv.
>

Ah, fixed.

>> It should now work with pretty much any combination of
>> input / output device (tested with a bt878 input and intel hda,
>> usb-audio or pulseaudio output).
>
> I'll run some tests later with the boards I have here.
>

Thanks.

>> I've also changed the default -alsa-pb value to "default" as we should
>> not be picking something else then the user / distro configured defaults
>> for output IMHO. The user can set a generic default in alsarc, and override
>> that on the cmdline if he/she wants, but unless overridden on the cmdline
>> we should respect the users generic default as specified in his
>> alsarc.
>
> While pulseaudio refuses to work via ssh, this is actually a very bad idea.
> Xawtv is used by developers to test their stuff, and they generally do it
> on a remote machine, with the console captured via tty port, in order to
> be able to catch panic messages.
>

I'm sure developers are quite capable of creating either an .alsarc, pass
the cmdline option, or change pulseaudio's config to accept non local console
connections.

We should try to have sane user oriented defaults, not developer oriented
defaults.

Also not all developers work the same way you do, so having a certain default
just so it matches your work flow also is a bad idea IMHO.

> For now, please revert this patch. After having pulseaudio fixed to properly
> handle the audio group, I'm ok to re-add it.
>
>> We could consider making the desired latency configurable, currently
>> I've hardcoded it to 30 ms (was 38 with the old code on my system) note
>> that I've chosen to specify the latency in ms rather then in a number
>> of samples, since it should be samplerate independent IMO.
>
> Yeah, having latency configurable sounds a good idea to me.

Done.

Regards,

Hans
