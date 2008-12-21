Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from moutng.kundenserver.de ([212.227.126.171])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <holger+linux-dvb@rusch.name>) id 1LETBW-0005Sb-RT
	for linux-dvb@linuxtv.org; Sun, 21 Dec 2008 19:37:51 +0100
Resent-Message-Id: <494E8CDD.4070902@rusch.name>
Message-ID: <494E8B97.7030608@rusch.name>
Date: Sun, 21 Dec 2008 19:31:51 +0100
From: Holger Rusch <holger@rusch.name>
MIME-Version: 1.0
To: Devin Heitmueller <devin.heitmueller@gmail.com>
References: <cae4ceb0812091511s668dcc5fj793e7efc113fedfd@mail.gmail.com>	<493F8A81.7040802@rusch.name>
	<494E61B4.2040006@rusch.name>
	<412bdbff0812210831w2c8930eal5181c766857b0aa8@mail.gmail.com>
In-Reply-To: <412bdbff0812210831w2c8930eal5181c766857b0aa8@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] TerraTec Cinergy DT USB XS Diversity (Quality with
 linux worse then with Windows)
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

Devin Heitmueller schrieb:
> On Sun, Dec 21, 2008 at 10:33 AM, Holger Rusch <holger@rusch.name> wrote:
>> Shameless repost. No idea? Anybody?
> 
> Are you using the latest code from http://linuxtv.org/hg/v4l-dvb,

Yes, i use the hg tree.

> including the newer 1.20 firmware?

storage:/lib/firmware# ls -la dvb-usb-dib0700-1.20.fw
-r--r--r-- 1 root root 33768 20. Nov 14:08 dvb-usb-dib0700-1.20.fw

(the only .fw file in the directory

storage:/lib/firmware# md5sum dvb-usb-dib0700-1.20.fw
f42f86e2971fd994003186a055813237  dvb-usb-dib0700-1.20.fw

Where do i get the newest one, if this one isnt the newest?

> Have you tried turning off the LNA and see if there is any difference
> in SNR?  While an amplifier can be a good thing in some cases, if
> you're to close to the transmitter the LNA may be driving the signal
> too hard for the demodulator.

I changed:
options dvb_usb_dib0700 force_lna_activation=1
to
options dvb_usb_dib0700 force_lna_activation=0

and retried (rebootet).

It did not help.

> Is the SNR level always being reported as poor, or only when the
> signal is dropping out?

SNR is constantly poor <45%.

And now?

-- 
+ Contact? => http://site.rusch.name/ +


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
