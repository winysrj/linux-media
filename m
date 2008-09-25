Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mout2.freenet.de ([195.4.92.92])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <majamaki@freenet.de>) id 1Kiwzy-0003N4-2A
	for linux-dvb@linuxtv.org; Thu, 25 Sep 2008 21:59:38 +0200
To: "Andrew Lyon"<andrew.lyon@gmail.com>,majamaki@freenet.de
From: majamaki@freenet.de
MIME-Version: 1.0
Message-Id: <E1Kiwqo-0005zO-In@www14.emo.freenet-rz.de>
Date: Thu, 25 Sep 2008 21:50:10 +0200
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

> I am using S-1500 + CI with a T.Rex CAM and Mythtv, no problems at all.
> 
Do you load any particular additional modules or is it all with budget-ci and budget-core? 


> > Anyway card runs fine - I am receiving 2 satellites with multifeed antenna
> and I was able
> > to create channels.conf files for both with scan. szap also locks on
> channels from both satellites.
> > Problem is that the other satellite (Thor) requires Conax card, but when I
>  CI slot
> > it is acknowledged in dmesg by:
> >
> > dvb_ca adapter 0: DVB CAM detected and initialised successfully
> >

This seems now to be a past history. I do not know what happened but I built the cards in another
machine and tried to use them with windows and now I do not get even this message anymore.
The computer is not reacting to insertion of CAM at all anymore. I don't think I was too hamfisted 
with hardware but there we are.


> I am not familiar with Conax system but perhaps you need to do some
> setup work in the cam menu? On my T.Rex I had to enter the STB serial
> number into the cam menu to enable decryption.
> >
> > Also when tuning with gnutv (with Conax card in the slot) I get a lock on
> a free channel and I can
> > watch it then few seconds with mplayer - < /dev/dvb/adapter0/dvr0 command
> but after these seconds
> > gnutv reports something about CAM (does not look like error or anything
> like this) and the picture goes
> > black.
> 
> Have you tried VDR or Mythtv?
> 
Yes I am using mythtv but I figured the best would be to get the system up and running with
mplayer and stuff from command line before









#adBox3 {display:none;}




_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
