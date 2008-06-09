Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fmmailgate02.web.de ([217.72.192.227])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <Andre.Weidemann@web.de>) id 1K5hTQ-0003yU-Fg
	for linux-dvb@linuxtv.org; Mon, 09 Jun 2008 15:31:53 +0200
Message-ID: <484D3099.2090807@web.de>
Date: Mon, 09 Jun 2008 15:31:05 +0200
From: =?ISO-8859-1?Q?Andr=E9_Weidemann?= <Andre.Weidemann@web.de>
MIME-Version: 1.0
To: Mike Beeson <michaelbeeson@gmail.com>
References: <57eb3fe80806090530o7d1d5684r43047b33b182966a@mail.gmail.com>	<484D26A3.2010604@iki.fi>	<57eb3fe80806090553s44e6cbe0wf77b4c0cbc9b1cdd@mail.gmail.com>	<484D2AE3.1030208@iki.fi>
	<57eb3fe80806090621j3c79be9eu32aa6bb990a85f33@mail.gmail.com>
In-Reply-To: <57eb3fe80806090621j3c79be9eu32aa6bb990a85f33@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] UK Freesat twin tuner USB/PCI/PCI-E
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Mike Beeson wrote:
> Thanks. I did look at the Technotrend S3600. Can I use two of these at =

> the same time? Could I expect to have problems with this?

Hi Mike, since there are no DVB-S2 channels on the Freesat platform(not =

even the 2 HD channels), there's no need to go for DVB-S2 unless you =

want to be set for the future.
So any DVB-S card or USB box will do just fine.

If you think about using VDR you might want to apply this patch =

here(http://www.rst38.org.uk/vdr/freesat.zip), since it adds Freesat EPG =

information to the channels. Most Freesat channels only carry Now/Next =

info, and a few like Channel 4 have no EPG at all without the patch. The =

patch is against VDR 1.4.7, so if you intend to use VDR 1.6.0 you might =

have to resolve some rejects by hand.

Have fun.
  Andr=E9

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
