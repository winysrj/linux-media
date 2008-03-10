Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ti-out-0910.google.com ([209.85.142.188])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jarro.2783@gmail.com>) id 1JYcbk-0004pv-1G
	for linux-dvb@linuxtv.org; Mon, 10 Mar 2008 08:39:45 +0100
Received: by ti-out-0910.google.com with SMTP id y6so828473tia.13
	for <linux-dvb@linuxtv.org>; Mon, 10 Mar 2008 00:39:33 -0700 (PDT)
Message-ID: <abf3e5070803100039s232bf009ib5d1bde70b8e908d@mail.gmail.com>
Date: Mon, 10 Mar 2008 18:39:33 +1100
From: "Jarryd Beck" <jarro.2783@gmail.com>
To: "Michael Krufky" <mkrufky@linuxtv.org>
In-Reply-To: <47D4B8D0.9090401@linuxtv.org>
MIME-Version: 1.0
Content-Disposition: inline
References: <abf3e5070803091836g6415112ete553958792f54d@mail.gmail.com>
	<47D49309.8020607@linuxtv.org>
	<abf3e5070803092042q6f4e90d9h890efb0ea441419e@mail.gmail.com>
	<47D4B8D0.9090401@linuxtv.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] NXP 18211HDC1 tuner
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

>  I think that the tda18271 driver will work with your tuner, but we may
>  need to make some small adjustments.  If you look in tda18271-fe.c ,
>  you'll find the code that autodetects between a TDA18271c1 and a
>  TDA18271c2 ...

I just realised there's a problem with versions of code. I'm using
the code from http://www.linuxtv.org/hg/~anttip/af9015
However I suppose you want me to use the code from the main
repository. Needless to say it doesn't work with 0x60 or 0x61
as the address for the tuner.
Also if I could somehow get this working with the right
code, I don't know how to set up the values in the tda182171_config
struct.

Jarryd.

On Mon, Mar 10, 2008 at 3:28 PM, Michael Krufky <mkrufky@linuxtv.org> wrote:
> On Mon, Mar 10, 2008 at 12:46 PM, Michael Krufky <mkrufky@linuxtv.org>
>  wrote:
>  >> Jarryd Beck wrote:
>  >>  > Would someone be interested in writing tuner drivers for the NXP
>  >>  > 18211HDC1 tuner?
>  >>  > I recently bought the Winfast DTV Dongle Gold which uses an AF9015
>  >>  > chip and the NXP tuner.
>  >>  > I've managed to get it working up to the point of needing the tuner,
>  >>  > after that nothing works.
>  >>  > I have no idea how to write tuner code, so if someone is interested, I
>  >>  > can supply all the
>  >>  > info I've got about the card and test whatever you write.
>  >>  >
>  >>  > Jarryd.
>  >>
>  >>  Try the tda18271 driver -- I am under the impression that the tda18211
>  >>  is a dvb-t only subset of the tda18271, but I dont have a tda18211 to
>  >>  test with and find out, nor do I have a tda18211 spec to look at.  :-(
>  >>
>  >>  Good Luck,
>  >>
>  >>  Mike
>
> Jarryd Beck wrote:
>  > I tried that, but I wasn't sure about a few things, I was kind of making stuff
>  > up as I went along.
>  >
>  > Can you tell me if I've done this right?
>  >
>  > At the af9015_tuner_attach function I wrote a function
>  > tda18211_tuner_attach which
>  > calls dvb_attach. The one thing I'm not sure about is the function
>  > tda18271_attach
>  > has a parameter u8 addr. I don't know what that is supposed to do or where I am
>  > supposed to get it from.
>  >
>  > You can look up a datasheet from the nxp site, it appears it goes under the name
>  > tda18211HD, I don't know what the C1 at the end means, I'm hoping it's the same
>  > thing. The datasheet isn't very useful though, it pretty much only has a
>  > circuit diagram and a couple of numbers on it.
>  >
>  > Jarryd.
>  >
>  >
>
>  Jarryd,
>
>  Please don't drop cc to the mailing list (added back), and also remember
>  not to top quote.
>
>  The addr parameter is the i2c address of the tuner.  It is most likely
>  0x60 or 0x61.
>
>  For an example of how to attach the tda18271 driver, look in
>  cx23885-dvb.c for CX23885_BOARD_HAUPPAUGE_HVR1800 where alt_tuner is 1.
>
>  The datasheet on the nxp site wont help me -- i need to see the register
>  map.
>
>  I think that the tda18271 driver will work with your tuner, but we may
>  need to make some small adjustments.  If you look in tda18271-fe.c ,
>  you'll find the code that autodetects between a TDA18271c1 and a
>  TDA18271c2 ...   If the autodetection fails for your tuner, you might
>  want to try hardcoding it to the tda18271c1.  If that works, then I'll
>  ask you to enable the register dump debug option (debug = 4) in the
>  tda18271 driver and send me a dmesg snippit.  That should help us to add
>  the autodetection later.
>
>  hth,
>
>  Mike
>
>

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
