Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ti-out-0910.google.com ([209.85.142.189])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jarro.2783@gmail.com>) id 1JYpNm-0004uA-NL
	for linux-dvb@linuxtv.org; Mon, 10 Mar 2008 22:18:55 +0100
Received: by ti-out-0910.google.com with SMTP id y6so1012313tia.13
	for <linux-dvb@linuxtv.org>; Mon, 10 Mar 2008 14:15:21 -0700 (PDT)
Message-ID: <abf3e5070803101415g79c1f4a6m9b7467a0e6590348@mail.gmail.com>
Date: Tue, 11 Mar 2008 08:15:21 +1100
From: "Jarryd Beck" <jarro.2783@gmail.com>
To: "Michael Krufky" <mkrufky@linuxtv.org>
In-Reply-To: <47D539E8.6060204@linuxtv.org>
MIME-Version: 1.0
Content-Disposition: inline
References: <abf3e5070803091836g6415112ete553958792f54d@mail.gmail.com>
	<47D49309.8020607@linuxtv.org>
	<abf3e5070803092042q6f4e90d9h890efb0ea441419e@mail.gmail.com>
	<47D4B8D0.9090401@linuxtv.org>
	<abf3e5070803100039s232bf009ib5d1bde70b8e908d@mail.gmail.com>
	<47D539E8.6060204@linuxtv.org>
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

On Tue, Mar 11, 2008 at 12:38 AM, Michael Krufky <mkrufky@linuxtv.org> wrote:
> Jarryd Beck wrote:
>  >>  I think that the tda18271 driver will work with your tuner, but we may
>  >>  need to make some small adjustments.  If you look in tda18271-fe.c ,
>  >>  you'll find the code that autodetects between a TDA18271c1 and a
>  >>  TDA18271c2 ...
>  >>
>  >
>  > [snip]
>
> >
>  > Also if I could somehow get this working with the right
>  > code, I don't know how to set up the values in the tda182171_config
>  > struct.
>  >
>
>  Jarryd,
>
>  Assuming that there is no tda829x analog demod present, and that this is
>  a digital-only device, try something like this:
>
>  static struct tda18271_config jarryd_tda18271_config = {
>         .gate = TDA18271_GATE_DIGITAL
>  }
>
>
>  You should leave .std_map as NULL unless you need to override the default values per standard.
>
>  The value in the ".std_bits" corresponds to the lower five bits in EP3 (register 0x05 [4:0])
>
>  Most likely, the driver's default setting will work for you, but you
>  may find that the vendor chose a different value if you sniff the usb
>  traffic from the windows driver.  This value is directly tied to the IF
>  frequency between the tuner and demod.
>
>  -Mike Krufky
>
>

That didn't work, the problem is I can't tell where it's going wrong and
I don't understand usb sniffs. I have a few questions:
When af9015 reads the tuner, the existing tuners set the spectral
inversion state->gpio3. Do you know what state->gpio3 does?
The code then goes on to read the spectral inversion, but there's
a comment there saying it's always 0, and the existing tuners
have theirs set to 1, what should I set it to for this one?

If it's the case that some of the other values in the config are wrong,
how would I go about making sense of a usb sniff?

Jarryd.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
