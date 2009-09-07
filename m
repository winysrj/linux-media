Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f206.google.com ([209.85.219.206]:61741 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753399AbZIGOU1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Sep 2009 10:20:27 -0400
Received: by ewy2 with SMTP id 2so2085995ewy.17
        for <linux-media@vger.kernel.org>; Mon, 07 Sep 2009 07:20:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <13c90c570909070123r2ba1f5f6w2b288703f5e98738@mail.gmail.com>
References: <13c90c570909070123r2ba1f5f6w2b288703f5e98738@mail.gmail.com>
Date: Mon, 7 Sep 2009 10:20:26 -0400
Message-ID: <37219a840909070720r6feb05e2yd9172c65bb7d0fd3@mail.gmail.com>
Subject: Re: [linux-dvb] [PATCH] Add support for Zolid Hybrid PCI card
From: Michael Krufky <mkrufky@kernellabs.com>
To: Henk <henk.vergonet@gmail.com>
Cc: Linux DVB Mailing List <linux-dvb@linuxtv.org>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Apologies, I sent this from a bad email address at first.

On Mon, Sep 7, 2009 at 4:23 AM, Henk<henk.vergonet@gmail.com> wrote:
> This patch adds support for Zolid Hybrid TV card. The results are
> pretty encouraging DVB reception and analog TV reception are confirmed
> to work. Might still need to find the GPIO pin that switches AGC on
> the TDA18271.
>
> see:
> http://linuxtv.org/wiki/index.php/Zolid_Hybrid_TV_Tuner
> for more information.
>
> Signed-off-by: Henk.Vergonet@gmail.com

Henk, thanks for your contribution, but this patch has problems.  This
should NOT be merged as it is here.  Please see below:

#1) It's just a copy of the HVR1120 configuration.  There tuner_config
= 3 value is definitely wrong for your board.  To prove my point,
notice that you added a case for your board to the switch..case block
in saa7134_tda8290_callback.  This will cause
saa7134_tda8290_18271_callback to get called, then the default case
will do nothing and the entire thing was a no-op.

The correct value for your board for tuner_config is 0.  Always try
the defaults before blindly copying somebody else's configuration.

#2) Card description reads, "NXP Europa DVB-T hybrid reference design"
but the card ID is SAA7134_BOARD_ZOLID_HYBRID_PCI.  I suggest to pick
one name for the sake of clarity, specifically, the actual board name.
 Feel free to indicate that it is based on a reference design in
comments.

#3) The change in saa7134-dvb will prevent an HVR1120 and your Zolid
board from working together in the same PC.  Please create a new case
block for the Zolid board, and create a new configuration structure
for the tda10048 -- do not edit the value of static structures
on-the-fly, and dont alter configuration of cards other than that of
the board that you are adding today.

#4) Does your card have a saa7131 on it or some other saa713x variant?
Is there actually a tda8290 present on the board?  Does the
tda8290_attach function sucess or fail?  Please send in a dmesg
snippit of the board functioning with your next patch.

#5)  Aren't there multiple versions of this board using different
steppings of the tda18271 tuner?  This I am not sure of, but I do
recall having issues bringing up the Zolid board months ago -- is this
actually working for you?

After you resubmit a cleaned up patch, we should see if anybody else
out there can test this for you.  A dmesg snippit of the board's
driver output would be nice.

Cheers,

Mike
