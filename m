Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from nf-out-0910.google.com ([64.233.182.189])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <andrew.lyon@gmail.com>) id 1Kepwb-00068B-6i
	for linux-dvb@linuxtv.org; Sun, 14 Sep 2008 13:39:10 +0200
Received: by nf-out-0910.google.com with SMTP id g13so908682nfb.11
	for <linux-dvb@linuxtv.org>; Sun, 14 Sep 2008 04:39:05 -0700 (PDT)
Message-ID: <f4527be0809140439j33b3f5feh49a0ae767bfc7bed@mail.gmail.com>
Date: Sun, 14 Sep 2008 12:39:05 +0100
From: "Andrew Lyon" <andrew.lyon@gmail.com>
To: majamaki@freenet.de
In-Reply-To: <E1KeZMO-0006GQ-LJ@www11.emo.freenet-rz.de>
MIME-Version: 1.0
Content-Disposition: inline
References: <E1KeZMO-0006GQ-LJ@www11.emo.freenet-rz.de>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Technotrend S-1500 and CI - CI not really working
	with Conax?
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

2008/9/13  <majamaki@freenet.de>:
> I had this impression from linuxtv site that TT S-1500 and CI would be supported..

I am using S-1500 + CI with a T.Rex CAM and Mythtv, no problems at all.

> Anyway card runs fine - I am receiving 2 satellites with multifeed antenna and I was able
> to create channels.conf files for both with scan. szap also locks on channels from both satellites.
> Problem is that the other satellite (Thor) requires Conax card, but when I  CI slot
> it is acknowledged in dmesg by:
>
> dvb_ca adapter 0: DVB CAM detected and initialised successfully
>
> but now I do not get picture even from free channels anymore. szap still locks alright.
> Also interesting is to mention that with gnutv -cammenu I am able to get access to cammenu
> which is in finnish so I assume it is really originating from my conax card.

I am not familiar with Conax system but perhaps you need to do some
setup work in the cam menu? On my T.Rex I had to enter the STB serial
number into the cam menu to enable decryption.
>
> Also when tuning with gnutv (with Conax card in the slot) I get a lock on a free channel and I can
> watch it then few seconds with mplayer - < /dev/dvb/adapter0/dvr0 command but after these seconds
> gnutv reports something about CAM (does not look like error or anything like this) and the picture goes
> black.

Have you tried VDR or Mythtv?

Andy
>
> Have I misunderstood the supported but and have my hopes too high or am I just missing something
> I need to do first (load some modules or so?)
>
> I would appreciate every bit of help since I find little information about this approach, lot more about using a smartcard
> reader and sc-plugins and other methods...
>
> Haven't bothered to plug in my hardware on my second Windows computer, I know only from my digibox that card works
> and is activated...
>
> Heute schon ge"freeMail"t?
> Jetzt kostenlose E-Mail-Adresse sichern!
> http://email.freenet.de/dienste/emailoffice/produktuebersicht/basic/mail/index.html?pid=6831
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
