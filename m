Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:48816 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755516Ab2FYU72 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jun 2012 16:59:28 -0400
Received: by wibhq12 with SMTP id hq12so3077817wib.1
        for <linux-media@vger.kernel.org>; Mon, 25 Jun 2012 13:59:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <0DB44B38-19BB-49E5-9286-18846E23D5E7@gmail.com>
References: <0DB44B38-19BB-49E5-9286-18846E23D5E7@gmail.com>
From: Andrew Hakman <andrew.hakman@gmail.com>
Date: Mon, 25 Jun 2012 14:59:07 -0600
Message-ID: <CABKuU7oRB41h1gbxVAvopVB06Cb=8aaNfUOF2V_N7rS1xqb9-g@mail.gmail.com>
Subject: Re: Skystar HD2 / mantis status?
To: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'm using 3.2-4.slh.1-aptosid-amd64

It seems to me something isn't quite setup with the STB0899 properly.
Tuning the same mux on a TT-3200 (which uses the same tuner and demod
chip) on a windows box coming from the same signal source at the same
time in TSReader, zero errors on the TT-3200, and pretty much
continual continuity and TEI errors from the Skystar HD2. (I'm using
DVBlast, so it prints out all the errors -  makes it easy to see
what's going on). The TEI errors lead me to suspect a setup problem
with the STB0899, as it's actually marking the packets as
uncorrectable after FEC processing. Also in the DVB wiki, it says the
TT3200 doesn't work properly either in linux, and again, that would
lead to a problem with the STB0899 code. I will try putting my TT3200
into the linux box and see if it does any better.

I managed to find the Twinhan released source (after much searching,
and setting up a windows VM to use driver guide's stupid download
program - didn't trust it enough to just run it on my windows box),
which seems like it's the reference code from ST for the STB0899 (been
discussed before on the mailing list, in 2009 I think), but it's not
exactly a 1:1 comparison between that code, and the current driver. I
do notice fewer registers being set on init in the current STB0899
code than the 'reference' code, but I'm not at a point where I'm ready
to actually make any official statements on that.

I seem to recall the STB0899 driver is kindof a touchy subject around
these parts...

The other thing that would be interesting would be to scope the I2C
lines on the STB0899, and tune the same things in windows and linux,
and see if the STB0899 is being setup the same way. Only trouble is I
don't know which pins are SCL and SDA on the STB0899, and of course
the actual data sheet is NDA only. Looks like all the digital-ish
looking pins have convenient series resistors which make for great
soldering locations!

On Mon, Jun 25, 2012 at 2:34 PM, walou <walou.media@gmail.com> wrote:
> I tried xubuntu 12.04 with 3.2.0-26 kernel and no success to get it work properly.
> I have the 1ae4:0003 subsystem device.
> Pls help.--
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
