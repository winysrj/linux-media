Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ey-out-2122.google.com ([74.125.78.24])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <devin.heitmueller@gmail.com>) id 1KYut6-00064d-6P
	for linux-dvb@linuxtv.org; Fri, 29 Aug 2008 05:43:05 +0200
Received: by ey-out-2122.google.com with SMTP id 25so196391eya.17
	for <linux-dvb@linuxtv.org>; Thu, 28 Aug 2008 20:43:00 -0700 (PDT)
Message-ID: <412bdbff0808282043y572a74b4o69fdc71a956131f0@mail.gmail.com>
Date: Thu, 28 Aug 2008 23:43:00 -0400
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: "Thomas Goerke" <tom@goeng.com.au>
In-Reply-To: <008301c90987$866b3e60$9341bb20$@com.au>
MIME-Version: 1.0
Content-Disposition: inline
References: <004f01c90921$248fe2b0$6dafa810$@com.au>
	<007f01c90965$344da360$9ce8ea20$@com.au>
	<412bdbff0808281638h7e911b37n4d5043bf40b42d65@mail.gmail.com>
	<008001c9096a$f315df10$d9419d30$@com.au>
	<412bdbff0808281731t7641e4d1kf86058e071c7d5fb@mail.gmail.com>
	<008101c90971$ca7e5080$5f7af180$@com.au>
	<412bdbff0808281905w1a76f8eald99de203fd0c18be@mail.gmail.com>
	<008201c90980$9b7ffd10$d27ff730$@com.au>
	<412bdbff0808281950r48f40835w3f81f506c32eaff3@mail.gmail.com>
	<008301c90987$866b3e60$9341bb20$@com.au>
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

On Thu, Aug 28, 2008 at 11:29 PM, Thomas Goerke <tom@goeng.com.au> wrote:
> See below for dmesg o/p with i2c errors.

Thanks for doing this test.  I've done some additional reading which
suggests the mt2060 has an extended history of flaky i2c behavior.
Given that I don't have the hardware, I don't think I'm going to be
able to debug it further.  I'm going to submit to have that device
fall back to the legacy interface, so it shouldn't be any worse with
1.20, but at least it won't block other devices that use 1.20 from
being committed.

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
