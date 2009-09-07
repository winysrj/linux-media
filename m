Return-path: <linux-media-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:62233 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753278AbZIGOSq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Sep 2009 10:18:46 -0400
Received: by ey-out-2122.google.com with SMTP id 25so919049eya.19
        for <linux-media@vger.kernel.org>; Mon, 07 Sep 2009 07:18:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090907124934.GA8339@systol-ng.god.lan>
References: <13c90c570909070123r2ba1f5f6w2b288703f5e98738@mail.gmail.com>
	 <13c90c570909070127j11ae6ee2w2aa677529096f820@mail.gmail.com>
	 <20090907124934.GA8339@systol-ng.god.lan>
Date: Mon, 7 Sep 2009 10:18:46 -0400
Message-ID: <37219a840909070718q47890f5bgbf76a00ea8826880@mail.gmail.com>
Subject: Re: [PATCH] Add support for Zolid Hybrid PCI card
From: Michael Krufky <mkrufky@gmail.com>
To: Henk <henk.vergonet@gmail.com>, spam@systol-ng.god.lan
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Sep 7, 2009 at 8:49 AM, <spam@systol-ng.god.lan> wrote:
> Hmm gmail front-end encoded the attachment as binary, retry....
> ----- snip -----
>
> This patch adds support for Zolid Hybrid TV card. The results are
> pretty encouraging DVB reception and analog TV reception are confirmed
> to work. Might still need to find the GPIO pin that switches AGC on
> the TDA18271 for even better reception.
>
> see:
> http://linuxtv.org/wiki/index.php/Zolid_Hybrid_TV_Tuner
> for more information.
>
> Signed-off-by: Henk.Vergonet@gmail.com
>
>

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
