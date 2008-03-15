Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wf-out-1314.google.com ([209.85.200.173])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hansson.patrik@gmail.com>) id 1JabHY-00087W-Lf
	for linux-dvb@linuxtv.org; Sat, 15 Mar 2008 19:39:06 +0100
Received: by wf-out-1314.google.com with SMTP id 28so4480345wfa.17
	for <linux-dvb@linuxtv.org>; Sat, 15 Mar 2008 11:38:51 -0700 (PDT)
Message-ID: <8ad9209c0803151138v45edf1e1p27f12aa4faa32d23@mail.gmail.com>
Date: Sat, 15 Mar 2008 19:38:51 +0100
From: "Patrik Hansson" <patrik@wintergatan.com>
To: linux-dvb <linux-dvb@linuxtv.org>
In-Reply-To: <20080314164100.GA3470@mythbackend.home.ivor.org>
MIME-Version: 1.0
Content-Disposition: inline
References: <20080314164100.GA3470@mythbackend.home.ivor.org>
Subject: Re: [linux-dvb] Nova-T 500 issues - losing one tuner
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

I tried changing to 2.6.22-19 on my ubuntu 7.10 with autosuspend=-1
but i still lost one tuner.

Have reverted back to 2.6.22-14-generic now and have disabled the
remote-pulling...and i just lost a tuner, restarting my cardclient and
mythbackend got it back.

Did you have remote-pulling disabled in -19 ?

2008/3/14 Ivor Hewitt <ivor@ivor.org>:
> Still no failures here on 2.6.22.19, had one or two "mt2060 I2C write failed" messages but that didn't stop anything working. Running mythtv with multi-rec.
>  I've attached the list of usb and i2c named files that changed between 2.6.22.19 and linux-2.6.23.12. I'll browse through and if I have time I'll apply a few of the diffs and see if I can create a breakage.
>
>  Cheers,
>  Ivor
>
> _______________________________________________
>  linux-dvb mailing list
>  linux-dvb@linuxtv.org
>  http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
