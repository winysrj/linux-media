Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ey-out-2122.google.com ([74.125.78.25])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <devin.heitmueller@gmail.com>) id 1KYu4A-0003vy-VM
	for linux-dvb@linuxtv.org; Fri, 29 Aug 2008 04:50:28 +0200
Received: by ey-out-2122.google.com with SMTP id 25so190048eya.17
	for <linux-dvb@linuxtv.org>; Thu, 28 Aug 2008 19:50:23 -0700 (PDT)
Message-ID: <412bdbff0808281950r48f40835w3f81f506c32eaff3@mail.gmail.com>
Date: Thu, 28 Aug 2008 22:50:23 -0400
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: "Thomas Goerke" <tom@goeng.com.au>
In-Reply-To: <008201c90980$9b7ffd10$d27ff730$@com.au>
MIME-Version: 1.0
Content-Disposition: inline
References: <004f01c90921$248fe2b0$6dafa810$@com.au>
	<412bdbff0808280824s288de72el297dda0556d6ca4d@mail.gmail.com>
	<007f01c90965$344da360$9ce8ea20$@com.au>
	<412bdbff0808281638h7e911b37n4d5043bf40b42d65@mail.gmail.com>
	<008001c9096a$f315df10$d9419d30$@com.au>
	<412bdbff0808281731t7641e4d1kf86058e071c7d5fb@mail.gmail.com>
	<008101c90971$ca7e5080$5f7af180$@com.au>
	<412bdbff0808281905w1a76f8eald99de203fd0c18be@mail.gmail.com>
	<008201c90980$9b7ffd10$d27ff730$@com.au>
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

On Thu, Aug 28, 2008 at 10:40 PM, Thomas Goerke <tom@goeng.com.au> wrote:
> Devin,
>
> See output below.  Tuners are now working correctly with MythTV.

Well that's promising.  Could you please reboot the system a few times
and test both cold and warm starts so you are comfortable that
everything is working?

Once you're confident everything works, could you please try the following:

1.  Comment out the "st->fw_use_legacy_i2c_api = 1" line you added in
the previous email
2.  Add "| I2C_M_NOSTART" to line 46 of mt2060.c so it looks like the following:

{ .addr = priv->cfg->i2c_address, .flags = I2C_M_RD | I2C_M_NOSTART,
.buf = val,  .len = 1 },

make, make install, reboot

Then let me know if the dmesg output contains i2c errors (and send the
output if it does).

We're getting close here....

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
