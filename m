Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wf-out-1314.google.com ([209.85.200.173])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <daniel.akerud@gmail.com>) id 1JjEjZ-0004DS-Bn
	for linux-dvb@linuxtv.org; Tue, 08 Apr 2008 16:23:39 +0200
Received: by wf-out-1314.google.com with SMTP id 28so2095544wfa.17
	for <linux-dvb@linuxtv.org>; Tue, 08 Apr 2008 07:23:05 -0700 (PDT)
Message-ID: <b000da060804080723k3eb9056bt8f9e6d37e089616@mail.gmail.com>
Date: Tue, 8 Apr 2008 16:23:05 +0200
From: "=?ISO-8859-1?Q?daniel_=E5kerud?=" <daniel.akerud@gmail.com>
To: linux-dvb <linux-dvb@linuxtv.org>
In-Reply-To: <8ad9209c0804050434i3b898edfucf0294403d87f5ca@mail.gmail.com>
MIME-Version: 1.0
References: <47A98F3D.9070306@raceme.org> <1202330097.4825.3.camel@anden.nu>
	<47AB1FC0.8000707@raceme.org>
	<1202403104.5780.42.camel@eddie.sth.aptilo.com>
	<8ad9209c0802100743q6942ce28pf8e44f2220ff2753@mail.gmail.com>
	<47C4661C.4030408@philpem.me.uk>
	<C34A2B56-5B39-4BE4-BACD-4E653F61FB03@firshman.co.uk>
	<8ad9209c0803121334s1485b65ap7fe7d5e4df552535@mail.gmail.com>
	<8ad9209c0803121338w6b93c555y73bf82abee55a63c@mail.gmail.com>
	<8ad9209c0804050434i3b898edfucf0294403d87f5ca@mail.gmail.com>
Subject: Re: [linux-dvb] Nova-T 500 issues - losing one tuner
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0039977539=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0039977539==
Content-Type: multipart/alternative;
	boundary="----=_Part_23067_31410438.1207664585674"

------=_Part_23067_31410438.1207664585674
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Sat, Apr 5, 2008 at 1:34 PM, Patrik Hansson <patrik@wintergatan.com>
wrote:

> Just wanted to report that since stopped the active EIT scanning in
> mythtv-setup my NOVA-T 500 PCI have been stable for 4 days now with
> 2.6.22-14 without any special module options or anything like that.
> Before i never had both tuners working for more that 24 hours so that
> seems to be the workaround for the moment.
> The card still collects EIT data when watching tv so EPG still works.
>
>
I second that. I disabled Active EIT (mythtv-setup) and also added:
options usbcore autosuspend=-1
options dvb_usb disable_rc_polling=1
to the module options. My system has been rock solid since (~2 weeks) and I
used to have at least a couple of problems per week before.
/D

------=_Part_23067_31410438.1207664585674
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Sat, Apr 5, 2008 at 1:34 PM, Patrik Hansson &lt;<a href="mailto:patrik@wintergatan.com">patrik@wintergatan.com</a>&gt; wrote:<br><div class="gmail_quote"><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
Just wanted to report that since stopped the active EIT scanning in<br>
mythtv-setup my NOVA-T 500 PCI have been stable for 4 days now with<br>
2.6.22-14 without any special module options or anything like that.<br>
Before i never had both tuners working for more that 24 hours so that<br>
seems to be the workaround for the moment.<br>
The card still collects EIT data when watching tv so EPG still works.<br>
<div><div></div><div class="Wj3C7c"><br></div></div></blockquote></div><br>I second that. I disabled Active EIT (mythtv-setup) and also added:<br>options usbcore autosuspend=-1<br>options dvb_usb disable_rc_polling=1<br>
to the module options. My system has been rock solid since (~2 weeks) and I used to have at least a couple of problems per week before.<br>/D<br><br>

------=_Part_23067_31410438.1207664585674--


--===============0039977539==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0039977539==--
