Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fk-out-0910.google.com ([209.85.128.185])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <bokola@gmail.com>) id 1JolmL-00082C-SY
	for linux-dvb@linuxtv.org; Wed, 23 Apr 2008 22:41:22 +0200
Received: by fk-out-0910.google.com with SMTP id z22so4295222fkz.1
	for <linux-dvb@linuxtv.org>; Wed, 23 Apr 2008 13:41:18 -0700 (PDT)
Message-ID: <854d46170804231341r85c52eerf03af61e4a626c34@mail.gmail.com>
Date: Wed, 23 Apr 2008 22:41:18 +0200
From: "Faruk A" <fa@elwak.com>
To: "Dominik Kuhlen" <dkuhlen@gmx.net>
In-Reply-To: <200804202215.14234.dkuhlen@gmx.net>
MIME-Version: 1.0
Content-Disposition: inline
References: <200804190101.14457.dkuhlen@gmx.net>
	<200804201739.35206.dkuhlen@gmx.net>
	<854d46170804201248k70b14c99k5aba1fa8079b4649@mail.gmail.com>
	<200804202215.14234.dkuhlen@gmx.net>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Pinnacle PCTV Sat HDTV Pro USB (PCTV452e) and
	TT-Connect-S2-3600 final version (RC-keymap)
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

>  > It works, with this new changes i had no problem loading the drivers.
>  >
>  > One more thing i did some testing with vdr and dvbs2 it looks like it
>  > locks in exactly after 1 minute
>  > but no video or audio vdr just displays no signal. I don't know if is
>  > the vdrs fault or the drivers
>  > anyway i have attached a small log. (no attachment rejected by
>  > moderator, I've sent copy of this mail to Dominik with attachment.
>  > Tried pastebin too didn't help)
>  Hmm, i have received your log file (its 3MB, you could try to bzip2 it before attaching.
>  usually log files compress well)

Sorry i usually use bzip2 but i have a good excuse i had fever that
day and now i am well :)

>  The log starts at 19:51:19 with opening the device.
>  but it looks like delivery system is set to DVB-S not DVB-S2
>  frequency and symbolrate would match the astra-hd channel (1314MHz and 27500kSym/s).
>  then at 19:52:20 the frontend parameter were changed to 1479MHz and 24500kSym/s
>  not sure what triggered the retuning.
>  after 5 seconds the FE locks, which is surprising since the symbolrate is not correct.
>

I found out the problem its my channel list and its solved. The reason
is i rely on other peoples
channel list, i cannot produce one by my self i have tried many times
and i just doesn't work for me.
I'm using the patch scan and with latest api patch. the program woks
but the problem is it cannot
produce vdr output format when i use -o vdr at the end lets say it
finds 150 channels it doesn't save
anything it only produce empty channels.conf file but when i use -o
zap the saves what whatever
channels it finds to channels.conf the zap format never failed me before.
I don't know how to fix this problem and i don't know if its the
drivers fault or the softwares or me?

Faruk

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
