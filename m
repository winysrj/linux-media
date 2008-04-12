Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fk-out-0910.google.com ([209.85.128.187])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <luis.cidoncha@gmail.com>) id 1Jkgnr-0000kM-0g
	for linux-dvb@linuxtv.org; Sat, 12 Apr 2008 16:34:03 +0200
Received: by fk-out-0910.google.com with SMTP id z22so1049215fkz.1
	for <linux-dvb@linuxtv.org>; Sat, 12 Apr 2008 07:33:59 -0700 (PDT)
Message-ID: <b04e7ceb0804120733p1930b77bw5698b50dae23a677@mail.gmail.com>
Date: Sat, 12 Apr 2008 16:33:59 +0200
From: "Luis Cidoncha" <luis.cidoncha@gmail.com>
To: linux-dvb <linux-dvb@linuxtv.org>
In-Reply-To: <b04e7ceb0804120733t5d87eb1bh2dc88f57f1949afd@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <47A98F3D.9070306@raceme.org> <47AB1FC0.8000707@raceme.org>
	<1202403104.5780.42.camel@eddie.sth.aptilo.com>
	<8ad9209c0802100743q6942ce28pf8e44f2220ff2753@mail.gmail.com>
	<47C4661C.4030408@philpem.me.uk>
	<C34A2B56-5B39-4BE4-BACD-4E653F61FB03@firshman.co.uk>
	<8ad9209c0803121334s1485b65ap7fe7d5e4df552535@mail.gmail.com>
	<8ad9209c0803121338w6b93c555y73bf82abee55a63c@mail.gmail.com>
	<8ad9209c0804050434i3b898edfucf0294403d87f5ca@mail.gmail.com>
	<b04e7ceb0804120733t5d87eb1bh2dc88f57f1949afd@mail.gmail.com>
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

>
 >  Just wanted to report that since stopped the active EIT scanning in
 >  mythtv-setup my NOVA-T 500 PCI have been stable for 4 days now with
 >  2.6.22-14 without any special module options or anything like that.
 >  Before i never had both tuners working for more that 24 hours so that
 >  seems to be the workaround for the moment.
 >  The card still collects EIT data when watching tv so EPG still works.
 >

 Hi. I was suffering the "loser one tuner" problem, and I just want to
 add that I use MythTV with active EIT scanning and my system has been
 stable for 4 days without a problem.

 MythTV has a parameter to delay the tuning of channels in the same
 configuration screen where you select active/passive EIT scanning.
 More precisely, it's at the right of the Active EIT scanning checkbox.
 I have adapter0 with passive EIT scanning, and 0 delay, and adapter1
 with Active EIT scanning and 150ms of tuning delay. That solved the
 tuner-losing stuff and also I have my EIT fully populated.

 Hope this can help you. Luis.



-- 
"I don't need a plan, just a goal. The rest will follow on its own"

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
