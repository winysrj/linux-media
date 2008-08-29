Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ey-out-2122.google.com ([74.125.78.24])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <devin.heitmueller@gmail.com>) id 1KYvqV-00019g-1c
	for linux-dvb@linuxtv.org; Fri, 29 Aug 2008 06:44:29 +0200
Received: by ey-out-2122.google.com with SMTP id 25so203054eya.17
	for <linux-dvb@linuxtv.org>; Thu, 28 Aug 2008 21:44:23 -0700 (PDT)
Message-ID: <412bdbff0808282144l4a6f5e68l26a775f01685febc@mail.gmail.com>
Date: Fri, 29 Aug 2008 00:44:23 -0400
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: "Thomas Goerke" <tom@goeng.com.au>
In-Reply-To: <008501c9098f$4f888490$ee998db0$@com.au>
MIME-Version: 1.0
Content-Disposition: inline
References: <004f01c90921$248fe2b0$6dafa810$@com.au>
	<412bdbff0808281731t7641e4d1kf86058e071c7d5fb@mail.gmail.com>
	<008101c90971$ca7e5080$5f7af180$@com.au>
	<412bdbff0808281905w1a76f8eald99de203fd0c18be@mail.gmail.com>
	<008201c90980$9b7ffd10$d27ff730$@com.au>
	<412bdbff0808281950r48f40835w3f81f506c32eaff3@mail.gmail.com>
	<008301c90987$866b3e60$9341bb20$@com.au>
	<412bdbff0808282043y572a74b4o69fdc71a956131f0@mail.gmail.com>
	<008401c9098a$35ccf090$a166d1b0$@com.au>
	<008501c9098f$4f888490$ee998db0$@com.au>
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

On Fri, Aug 29, 2008 at 12:25 AM, Thomas Goerke <tom@goeng.com.au> wrote:
> Devin,
>
> Is it worth updating
> (http://linuxtv.org/wiki/index.php/Hauppauge_WinTV-NOVA-T-500#Firmware) to
> include some information related to having to use the patched source code if
> using the .20 firmware?

Average users probably shouldn't be using the 1.20 firmware until the
patch is checked in to the v4l-dvb, so we can control which devices
use 1.20 and the new i2c functionality (based on actual testing).

My original plan was to keep everybody at 1.10 in the initial patch,
and once maintainers of individual devices tested 1.20, they could
submit a patch to make that the default for said device.  Patrick felt
strongly that 1.20 should be a drop-in replacement for 1.20, but based
on this evening's experience I'm thinking we should go back to my
original plan.

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
