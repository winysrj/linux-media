Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from f132.mail.ru ([194.67.57.113])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <goga777@bk.ru>) id 1JqLGZ-0000cH-AZ
	for linux-dvb@linuxtv.org; Mon, 28 Apr 2008 06:47:08 +0200
From: Igor <goga777@bk.ru>
To: Ian Bonham <ian.bonham@gmail.com>
Mime-Version: 1.0
Date: Mon, 28 Apr 2008 08:46:28 +0400
References: <2f8cbffc0804271318gf146080yfc988718556ad405@mail.gmail.com>
In-Reply-To: <2f8cbffc0804271318gf146080yfc988718556ad405@mail.gmail.com>
Message-Id: <E1JqLG0-000Jpq-00.goga777-bk-ru@f132.mail.ru>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] =?koi8-r?b?SFZSNDAwMCAmIEhlcm9u?=
Reply-To: Igor <goga777@bk.ru>
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

Hi

you can try second variant

- to install multiproto_plus
http://jusst.de/hg/multiproto_plus/
http://jusst.de/hg/multiproto_plus/archive/tip.tar.bz2

- to install hvr4000-patch from Gregoire Favre
http://linuxtv.org/pipermail/linux-dvb/2008-April/025655.html

Igor

-----Original Message-----
From: "Ian Bonham" <ian.bonham@gmail.com>
To: "linux-dvb@linuxtv.org" <linux-dvb@linuxtv.org>
Date: Sun, 27 Apr 2008 22:18:46 +0200
Subject: [linux-dvb] HVR4000 & HeronHi
> 
> Hi All.
> 
> Ok, so just installed the shiny, spangly new Ubuntu 8.04LTS (Hardy Heron) on
> my machine with the HVR4000 in, and now, no TV! It's gone on with kernel
> 2.6.24-16 on a P4 HyperThread, and everything worked just fine under Gutsy.
> I've pulled down the v4l-dvb tree (current and revision 127f67dea087 as
> suggested in Wiki) and tried patching with dev.kewl.org's MFE and SFE
> current patches (7285) and the latest.
> 
> Everything 'seems' to compile Ok, and installs fine. When I reboot however I
> get a huge chunk of borked stuff and no card. (Dmesg output at end of
> message)
> 
> Could anyone please give me any pointers on how (or if) they have their
> HVR4000 running under Ubuntu 8.04LTS ?
> 
> Would really appriciate it.
> Thanks in advance,
> 
> Ian
> 
> DMESG Output:
> cx88xx: disagrees about version of symbol videobuf_waiton
> [   37.790909] cx88xx: Unknown symbol videobuf_waiton
> 

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
