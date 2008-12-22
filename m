Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from qw-out-2122.google.com ([74.125.92.25])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <devin.heitmueller@gmail.com>) id 1LEn5D-0005W2-KU
	for linux-dvb@linuxtv.org; Mon, 22 Dec 2008 16:52:41 +0100
Received: by qw-out-2122.google.com with SMTP id 9so764242qwb.17
	for <linux-dvb@linuxtv.org>; Mon, 22 Dec 2008 07:52:33 -0800 (PST)
Message-ID: <412bdbff0812220752p4f4d3bf0t741472a8349db683@mail.gmail.com>
Date: Mon, 22 Dec 2008 10:52:33 -0500
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: "Matt R" <mattr121@gmail.com>
In-Reply-To: <25864d030812220513i22938f4dt28b0190f8aaafeba@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <25864d030812220513i22938f4dt28b0190f8aaafeba@mail.gmail.com>
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Pinnacle USB TV tuner sticks
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

On Mon, Dec 22, 2008 at 8:13 AM, Matt R <mattr121@gmail.com> wrote:
> Dear Devin,
>
> I recently purchased a Pinnacle PCTV HD Pro Stick (801e) without realizing
> that it's different from the 800e version of the model. I was able to play
> OTA digital channels on a Jaunty snapshop (dec 12) of Ubuntu after copying
> in the more recent firmware version(s) mentioned  at the wiki page for this
> model.
>
> I was wondering whether and which of these features of the 801e currently
> work or might be supported in the near future:
> 1. clear QAM digital cable
> 2. analog
> 3. FM radio
> as I am considering returning the unit if support for clear QAM and FM by
> open source projects such a linuxtv/mythtv is going to take some time. What
> would be your recommendation on this, and what is your recommendation for
> the best USB tuner stick out there in terms of both model features as well
> as current/forthcoming linux support for those features?
>
> Also, in this mailing list thread, were you referring to Pinnacle's new
> "Ultimate" stick (whose number seems to be 880e and not 80e)? If so, I am a
> bit confused about what Markus Rechberger said in response:
>
> Not so fast, even though I wasn't involved at knocking this down.
> We have a custom player now which is capable of directly interfacing the
> I2C chips from those devices. Another feature is that it supports all the
>
> features of those devices, there won't be any need of different applications
> anymore. There's also the thought about publishing an SDK, most applications
> have problems of detecting all corresponding devicenodes which are required
>
> for those devices anyway. i2c-dev is an already available and accepted
> kernel interface
> to userland just as usbfs is.
>
> best regards,
> Markus Rechberger
>
> Is a full-featured custom player (including device drivers) is available for
> that model? If so, are you able to point me where to look for it?
>
> Thanks and best regards
> Matt

Putting the ML on the CC so others can benefit from the information.

First off - the mistake you made in buying the 801e thinking you were
getting an 800e is a common one - I made that mistake myself and that
is what prompted me to add Linux support for the 801e (for the record
though, I later added the 800e support too).

Just to make things confusing, Pinnacle makes four different products
with nearly identical model numbers (800e, 801e, 880e, 80e).

Let's start with the one you have: the 801e (Pro).  This device
supports ATSC, ClearQAM, analog, and radio.  However, only the ATSC
and ClearQAM are implemented in Linux.  Because of some limitations in
the Linux dvb_usb stack, I couldn't make the analog support work
without adding all the necessary infrastructure.  And the FM support
falls under analog.  Also, the ClearQAM support should work in theory
but I couldn't test it when I added support since I didn't have access
to cable.  I really do need to follow up on that now and correct any
problems I find.

The 800e (Pro) is the older version of the product you have.  The ATSC
and analog both are supported, however the hardware does not support
ClearQAM or FM Radio.

The 880e (Ultimate) hardware supports ATSC, ClearQAM, analog, but no
FM radio.  The device is currently completely unsupported in Linux as
I have just last week gotten the datasheets and started working on
analog support (it uses chips that are not supported at all in Linux
so it will take longer).

The 80e (Mini) hardware only has ATSC and ClearQAM support (no analog
or FM).  As indicated in the Wiki, this device will never be supported
in an open source manner because Micronas refused to let me release
the driver source (after I did all the work).

Regarding your question on Markus's player, he is working on a piece
of commercial software for playing video, and because it is closed
source and he has relationships with Micronas he was able to include
their driver source required for the 80e Mini.  That said, his player
will not allow you to use applications such as MythTV or Kaffeine, as
none of those projects are going to create a dependency on his
closed-source player.  Also, his product is locked to Empia based
devices, so it will not work with products such as the 801e.  You can
go to his website at http://mcentral.de for more information.

You're going to be hard pressed to find a USB product that does all
four in Linux - ATSC, ClearQAM, analog, and FM.  Most of the older
products that do ATSC have analog/FM working (but the hardware doesn't
support QAM), but most of the products that do ClearQAM and ATSC do
not have any analog or FM support implemented in the Linux driver.
The Pinnacle Ultimate driver I am working on (when it is completed)
will support ClearQAM, ATSC, and analog, but the hardware doesn't
support FM).

Hope that answers your question,

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
