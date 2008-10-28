Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from qb-out-0506.google.com ([72.14.204.238])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <oroitburd@gmail.com>) id 1Kun8Y-0003bB-Uc
	for linux-dvb@linuxtv.org; Tue, 28 Oct 2008 12:53:27 +0100
Received: by qb-out-0506.google.com with SMTP id e11so2085423qbe.25
	for <linux-dvb@linuxtv.org>; Tue, 28 Oct 2008 04:53:23 -0700 (PDT)
Message-ID: <b42fca4d0810280453j652a531ag94f1d3137e540f6c@mail.gmail.com>
Date: Tue, 28 Oct 2008 12:53:22 +0100
From: "oleg roitburd" <oroitburd@gmail.com>
To: jean-paul@goedee.nl
In-Reply-To: <20081028124505.tvjko4bvkgk4kg4o@webmail.goedee.nl>
MIME-Version: 1.0
Content-Disposition: inline
References: <20081028111538.1yl7p80uo0cggo80@webmail.goedee.nl>
	<4906E9CC.2040408@gmail.com>
	<20081028124505.tvjko4bvkgk4kg4o@webmail.goedee.nl>
Cc: linux-dvb@linuxtv.org, Manu Abraham <abraham.manu@gmail.com>
Subject: Re: [linux-dvb] S2API & TT3200
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

2008/10/28  <jean-paul@goedee.nl>:
> Ok clone the repo and its compiling again. Thanx. Now I want to scan
> channels (scab-s2) on both lnb;s (astra 1 & 3). First transponder
> scans only 13 services and  Diseqc doesn?t work with the second lnb.
>
> WARNING: >>> tuning failed!!!
>>>> tune to: 11856:vS1C56:S23.5E:27500: (tuning failed)
> DiSEqC: uncommitted switch pos 0
> DiSEqC: switch pos 1, 13V, hiband (index 6)
> DVB-S IF freq is 1256000
>>>> tuning status == 0x00
>>>> tuning status == 0x00
>>>> tuning status == 0x00
>>>> tuning status == 0x00
>>>> tuning status == 0x00
>>>> tuning status == 0x00
>>>> tuning status == 0x00
>>>> tuning status == 0x00
>>>> tuning status == 0x00
>>>> tuning status == 0x00
> WARNING: >>> tuning failed!!!
> ERROR: initial tuning failed
> dumping lists (0 services)
> Done.

I can confirm this issue with jusst.de/hg/v4l-dvb. Take a look another thread.
Ok. I'm not alone ;)

Regards
Oleg Roitburd

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
