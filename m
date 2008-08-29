Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from nf-out-0910.google.com ([64.233.182.191])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <devin.heitmueller@gmail.com>) id 1KYtND-0001iD-BS
	for linux-dvb@linuxtv.org; Fri, 29 Aug 2008 04:06:05 +0200
Received: by nf-out-0910.google.com with SMTP id g13so192083nfb.11
	for <linux-dvb@linuxtv.org>; Thu, 28 Aug 2008 19:06:00 -0700 (PDT)
Message-ID: <412bdbff0808281905w1a76f8eald99de203fd0c18be@mail.gmail.com>
Date: Thu, 28 Aug 2008 22:05:59 -0400
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: "Thomas Goerke" <tom@goeng.com.au>
In-Reply-To: <008101c90971$ca7e5080$5f7af180$@com.au>
MIME-Version: 1.0
Content-Disposition: inline
References: <004f01c90921$248fe2b0$6dafa810$@com.au>
	<412bdbff0808280824s288de72el297dda0556d6ca4d@mail.gmail.com>
	<007f01c90965$344da360$9ce8ea20$@com.au>
	<412bdbff0808281638h7e911b37n4d5043bf40b42d65@mail.gmail.com>
	<008001c9096a$f315df10$d9419d30$@com.au>
	<412bdbff0808281731t7641e4d1kf86058e071c7d5fb@mail.gmail.com>
	<008101c90971$ca7e5080$5f7af180$@com.au>
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

On Thu, Aug 28, 2008 at 8:54 PM, Thomas Goerke <tom@goeng.com.au> wrote:
> I have applied the latest patch, swapped back to the .20firmware and now get
> the following output from dmesg:

Let's try this to rule out whether it's the new i2c interface or some
other aspect of the 1.20 firmware:

Add the following line to the dib0700_devices.c at line 78:

st->fw_use_legacy_i2c_api = 1;

It should end up looking like:

=======
static int bristol_frontend_attach(struct dvb_usb_adapter *adap)
{
        struct dib0700_state *st = adap->dev->priv;

	st->fw_use_legacy_i2c_api = 1;

        if (adap->id == 0) {
....
=======

That will tell it to fall back to the legacy i2c interface (which was
working fine for you in the 1.10 firmware).

Make that change, reboot your system, and send me the dmesg output so
we can see if you still get i2c errors.

Thanks,

Devin
-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
