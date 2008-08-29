Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ey-out-2122.google.com ([74.125.78.24])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <devin.heitmueller@gmail.com>) id 1KZ3zO-0001wv-Hu
	for linux-dvb@linuxtv.org; Fri, 29 Aug 2008 15:26:11 +0200
Received: by ey-out-2122.google.com with SMTP id 25so273019eya.17
	for <linux-dvb@linuxtv.org>; Fri, 29 Aug 2008 06:26:07 -0700 (PDT)
Message-ID: <412bdbff0808290626j20cae583kaf8384296fa1f9d3@mail.gmail.com>
Date: Fri, 29 Aug 2008 09:26:07 -0400
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: "Patrick Boettcher" <patrick.boettcher@desy.de>
In-Reply-To: <alpine.LRH.1.10.0808291202310.17297@pub3.ifh.de>
MIME-Version: 1.0
Content-Disposition: inline
References: <004f01c90921$248fe2b0$6dafa810$@com.au>
	<412bdbff0808280824s288de72el297dda0556d6ca4d@mail.gmail.com>
	<007f01c90965$344da360$9ce8ea20$@com.au>
	<412bdbff0808281638h7e911b37n4d5043bf40b42d65@mail.gmail.com>
	<008001c9096a$f315df10$d9419d30$@com.au>
	<412bdbff0808281731t7641e4d1kf86058e071c7d5fb@mail.gmail.com>
	<alpine.LRH.1.10.0808291202310.17297@pub3.ifh.de>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Hauppauge WinTV-NOVA-T-500 New Firmware
	(dvb-usb-dib0700-1.20.fw) causes problems
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

On Fri, Aug 29, 2008 at 6:25 AM, Patrick Boettcher
<patrick.boettcher@desy.de> wrote:
> Honestly spoken I never tried the 1.20 firmware on the NOVA-T 500. (This
> card was last used in DiBcom 3 years ago.)
>
> It might be that using the new i2c-requests along with the I2C-master do not
> work with some boards.
>
> In that case you can still use the new i2c-requests but you need to select
> the gpio-bus instead of the i2c-master-bus.

Do you think we would need to use the gpio-bus for all requests within
the device, or only for talking to the mt2060?  If it's device-wide, I
can just add another flag to dib0700_state, otherwise I'm not sure
what I'm going to have to do here.

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
