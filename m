Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61560 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470Ab1CLPrr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Mar 2011 10:47:47 -0500
Received: by bwz15 with SMTP id 15so3420869bwz.19
        for <linux-media@vger.kernel.org>; Sat, 12 Mar 2011 07:47:45 -0800 (PST)
From: Patrick Boettcher <pboettcher@kernellabs.com>
To: Peter Tilley <peter_tilley13@hotmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Dib7000/mt2266 help
Date: Sat, 12 Mar 2011 16:47:40 +0100
References: <SNT129-W418509BB02BD3867DCAA77E5CA0@phx.gbl>
In-Reply-To: <SNT129-W418509BB02BD3867DCAA77E5CA0@phx.gbl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201103121647.40488.pboettcher@kernellabs.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Peter,

(adding back the list to CC)

On Saturday 12 March 2011 11:48:38 Peter Tilley wrote:
> Hi Patrick,
> My sincerest apologies for coming to you directly but I have tried the
> Linux mailing list and received no response and noticed you seem to have
> been heavily involved with much of the Dibcom driver development.
> 
> I have an issue with a dual tuner which is sold under the brand of Kaiser
> Baas KBA01004 but identifies itself as 1164:1e8c which is a Yaun device
> and this device seems to have already been included in the driver files.
> 
> It loads ok and reports not problems.  It tunes ok and reports FE lock on
> all channels however on all but one channel upon receiving FE lock the
> BER stays at 1ffff instead of dropping to a low number which would
> indicate I am not getting viterbi.
> 
> The device is fitted with pairs of MT2266 and DIB7000 which I have
> positive identified by opening the USB stick.
> 
>  am more than happy to try and work this out myself however the amount of
> detail around in support of the Linux drivers is extremely low and a
> search for manufacturers data sheets finds next to nothing.    There
> seems to be lots of what I would call "magic numbers" in the drivers and
> little to determine what they are doing.

Are you sure it is a driver problem?

If the BER stays at this value it could also mean that the channel-
configuration is wrong.

Are you using a channels.conf which has all parameters set, or are you doing 
a channel-scan-like tune (all values are set to AUTO).
 
> My question to you is are you able to offer either any pointers to solve
> the problem or help me find detailed information about the devices so I
> can help myself.
> 
> I should point out that the device works perfectly under windows on the
> same antenna and indeed I have even successfully extracted the firmware
> from the supplied windows driver, renamed it so it loads and the problem
> still remains.

There are usually some adaptations board-designing companies do to improve 
reception quality (adding external LNAs and things like that) that are of 
course handled by the Window-driver, because it is created by the 
manufacturer and not by the Linux-driver, because (in this case) the driver 
was released by the chip-manufacturer.

Is the device toggling between FE_HAS_LOCK and no FE_HAS_LOCK or does it 
stay constantly at 

Please try whether you can achieve the BER lowering by moving the antenna or 
using a better one. If this helps, it really means that the windows-driver 
does something more the board.

I doubt that the chip-driver needs to be changed, more likely the GPIOs of 
the dib0700 (in dib0700_core.c) or of the dib7000 are used to turn on or off 
a frequency switch or a LNA.

Good point, what are the frequencies you're tuning ?

regards,

--
Patrick
http://www.kernellabs.com/
