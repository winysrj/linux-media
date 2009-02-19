Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp104.rog.mail.re2.yahoo.com ([206.190.36.82]:45072 "HELO
	smtp104.rog.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750851AbZBSDoK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Feb 2009 22:44:10 -0500
Message-ID: <499CD588.8030104@rogers.com>
Date: Wed, 18 Feb 2009 22:44:08 -0500
From: CityK <cityk@rogers.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: linux-dvb@linuxtv.org
Subject: Re: [Bulk] [linux-dvb] Problem with TV card's sound (SAA7134)
References: <BAY111-W598DBD904310E159C109CC5B40@phx.gbl>
In-Reply-To: <BAY111-W598DBD904310E159C109CC5B40@phx.gbl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

panagiotis takis_rs wrote:
> Hey!!
>  
> I have a problem with my tv card(pinnacle pctv 310i)
> I can see image but i have no sound.
> I have tried both tvtime and kdetv.
>  
> I have found this http://ubuntuforums.org/showthread.php?t=568528 . Is it related with my problem?
>  
> My tv card give audio output with this way: direct cable connection from
> tv card to sound card ( same cable witch connect cdrom and soundcard )

I didn't read through the link you provided, but it appeared to be in
regards to getting audio via DMA (using the card's 7134 chip to digitize
the audio and send it over the PCI bus to the host system).  You, on the
other hand, indicate that you are attempting to use the method of
running a patch cable between your TV card and sound card (meaning that
the sound card will do the digitizing instead).  Question:  have you
checked your audio mixer to make sure that any of the inputs are not muted?

