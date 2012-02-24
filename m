Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:42250 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754719Ab2BXDqR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Feb 2012 22:46:17 -0500
Message-ID: <2956179e26b9bbceb167f9adba3b9693.squirrel@webmail.kapsi.fi>
In-Reply-To: <201202232328.36340.hfvogt@gmx.net>
References: <201202222320.56583.hfvogt@gmx.net> <4F467E80.4060302@iki.fi>
    <201202232328.36340.hfvogt@gmx.net>
Date: Fri, 24 Feb 2012 05:46:13 +0200
From: "Antti Palosaari" <crope@iki.fi>
To: "Hans-Frieder Vogt" <hfvogt@gmx.net>
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: Re: [PATCH 0/3] Support for AF9035/AF9033
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

pe 24.2.2012 0:28 Hans-Frieder Vogt kirjoitti:
> Am Donnerstag, 23. Februar 2012 schrieb Antti Palosaari:
>> On 23.02.2012 00:20, Hans-Frieder Vogt wrote:
>> > I have written a driver for the AF9035&  AF9033 (called af903x), based
>> on
>> > the various drivers and information floating around for these chips.
>> > Currently, my driver only supports the devices that I am able to test.
>> > These are
>> > - Terratec T5 Ver.2 (also known as T6)
>> > - Avermedia Volar HD Nano (A867)
>> >
>> > The driver supports:
>> > - diversity and dual tuner (when the first frontend is used, it is in
>> > diversity mode, when two frontends are used in dual tuner mode)
>> > - multiple devices
>> > - pid filtering
>> > - remote control in NEC and RC-6 mode (currently not switchable, but
>> > depending on device)
>> > - support for kernel 3.1, 3.2 and 3.3 series
>> >
>> > I have not tried to split the driver in a DVB-T receiver (af9035) and
>> a
>> > frontend (af9033), because I do not see the sense in doing that for a
>> > demodulator, that seems to be always used in combination with the very
>> > same receiver.
>>
>> That was how I originally implemented it. Reason for that is simple:
>> af9033 demodulator exists as single chip. I think it is also used for
>> dual tuner devices or is there 2 af9035 chips used, like one is master
>> and one is slave and working as a demod?
>>
>> Situation is rather same for af9005/af9003 and af9015/af9013. Search
>> from the mailing list and see there is devices using af9003 demod but as
>> it is not split correctly from the af9005 those devices are never
>> supported (due to fact af9003 demod is not split out).
>>
>> Reason behind my af9035/af9033 is not merged to the Kernel is that I
>> never found people from ITE who was able to give permission to merge
>> that. As it contains some vendor code I didn't want to merge it without
>> permission.
>>
>> It is not many day work to write all vendor code out from the driver and
>> get it clean. If you want I can do it for you and merge that to the
>> Kernel. You can then take whole driver and start hacking if you wish.
>> What do you think? I am currently busy as hell and I don't want more
>> drivers to maintain so you can take maintaining responsibility.
>>
>> > The patch is split in three parts:
>> > Patch 1: support for tuner fitipower FC0012
>> > Patch 2: basic driver
>> > Patch 3: firmware
>> >
>> > Hans-Frieder Vogt                       e-mail: hfvogt<at>  gmx .dot.
>> net
>>
>> regards
>> Antti
>
> Antti,
>
> of course I understand that the af9033 is a separate chip, but still I
> don't
> know of any device that uses the af9033 without the af9035. Clearly, the
> situation is very similar with the other Afatech chips and you managed the
> "splitting job" very well for the af9015/af9013 and for the af9005/af9003
> chips. In fact, when you look at the EEPROM code and the register sequence
> (not the actual addresses, they have been moved), then it seems that in
> particular the af9015 and the af9035 have quite a lot in common (The main
> difference in the description on the afatech web page is the "low power"
> for
> the af9035).
> The main reason for me to leave the code together is rather the diversity
> code. I liked the idea of the driver selecting diversity and dual tuner
> code
> depending on how many tuners are actually used, and I simply struggled to
> make
> a clean split between frontend and main driver code.
>
> Thanks very much for your offer to support me in getting rid of vendor
> code.
> Honestly I was of the opinion that I already got rid of all of it, but if
> you
> still see some then I really appreciate if you can help me removing it
> once
> and for all. I am happy to do the maintainer job on that driver, but if it
> can
> be improved using some of your experience that would be great!
> Thanks very much!

I have few days after 12.3. All the others are clear but diversity mode
needs some work. I have currently no idea how it should be implemented.

Antti

