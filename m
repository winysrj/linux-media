Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:55385 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932226Ab2EGUvD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 May 2012 16:51:03 -0400
Message-ID: <4FA835B3.40802@iki.fi>
Date: Mon, 07 May 2012 23:50:59 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Hin-Tak Leung <hintak_leung@yahoo.co.uk>
CC: linux-media <linux-media@vger.kernel.org>,
	will.cooke@canonical.com, Greg KH <greg@kroah.com>
Subject: Re: GSoC 2012 Linux-Media!
References: <4FA291F5.3000103@iki.fi> <4FA49DB4.9080206@yahoo.co.uk>
In-Reply-To: <4FA49DB4.9080206@yahoo.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello!

On 05.05.2012 06:25, Hin-Tak Leung wrote:
> Hi Antti,
>
> I promised to put you in touch with some more knowledgeable people, so
> here they are. Will made a few comments during our discussions (inserted
> verbatim below - may or may not be relevant)... Please feel free to
> respond to Mr Cooke and/or write to him and Greg.
>
> Hin-Tak
>
> Will Cooke wrote:
>  > The hacks with USB stick are entirely reliant on the chips inside the
> stick. In
>  > this case, the demod (Realtek RTL2832U)has the ability to pass
> through to the
>  > USB bus raw 8-bit sampled RF called I/Q
>  > (http://zone.ni.com/devzone/cda/tut/p/id/4805).
>  >
>  > Once you have this raw I/Q data you can demodulate the signals and
> process them
>  > in software. So it's possible to build an FM radio, an AM radio, a
> DAB radio,
>  > Ham radio, Packet radio, slow scan TV, basically anything which
> modulates a sine
>  > wave within the frequency range of the tuner inside the DVB stick.
> Not all DVB
>  > tuners are created equal. Some will be limited to n hundred MHz, some
> have a
>  > range as low as 50 or 60 MHz up to a few GHz.
>  >
>  > Chips that have this functionality AND are built in to DVB USB sticks
> AND cost
>  > less than 20 Dollars are few and far between. So it's pretty rare to
> find a
>  > compatible USB stick, and not every USB stick can pull off this neat
> trick.
>  >
>  > There is probably scope to run a project around a single targeted DVB
> USB stick,
>  > but hardware support would be limited. GNU Radio is a good tool to
> build the
>  > remodulators. As an example real world application, how about
> building one of
>  > these sticks in to a laptop and integrating it with the audio stack.
> Now my
>  > laptop comes with a TV tuner, an FM tuner, a DAB tuner, and so on.
>  >
>  > I hope that helps set the scene a little bit more. Let me know if you
> need any
>  > more help.
>  >
>  > Cheers, Will
>
> Will Cooke wrote:
>  > Hi Till!
>  >
>  > I am familiar with what a USB-DVB stick is, how it works, the inside
> of a DVB
>  > transport stream, and so on, but... I'm in no way an expert, and I'm
> in no way a
>  > developer!
>  >
>  > Depending on what sort of mentoring you had in mind, I would be happy
> to get
>  > involved.
>  >
>  > Can you let me know a little more about the project and what kind of
> input you
>  > need from me.
>  >
>  > Cheers, Will

Yes I know that RTL2832U SDR since I did a little bit initial stuff for it:
http://comments.gmane.org/gmane.linux.drivers.video-input-infrastructure/44461

Actually, RTL2832U GNU Radio driver, is accepted as my Bachelor's 
Thesis. But I don't see idea to do that no longer since it was already 
done by the others...

I have still some interest of hacking with that area. One thing what I 
have been thinking in my brains is Kernel DVB interface support for 
SDRs. It is not very much work for adding Kernel support. Define new 
dilivery system for frontend and some changes for the DVB core to pass 
raw payload data. Some very simple conversion is also needed as RTL2832U 
supports only 8 bit samples what we know. And then suitable driver for 
the GNU Radio which can speak our Kernel DVB "API" language ;)

But there is currently only that one DVB device we known how to use as a 
general SDR. There is surely some others available and more is coming as 
all new radios are less or more SDRs. For example Dibcom Octopus. I 
still suspect vendors are not very willingly releasing needed 
information which could slow down things...

I do not have clear vision how that kind of SDR radios should be 
integrated to the existing desktop. But likely Linux DVB -interface + 
userspace stuff for the signal handling?

regards
Antti
-- 
http://palosaari.fi/
