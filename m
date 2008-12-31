Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Date: Wed, 31 Dec 2008 15:28:22 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Klaus Schmidinger <Klaus.Schmidinger@cadsoft.de>
Message-ID: <20081231152822.544c3a32@pedra.chehab.org>
In-Reply-To: <495B6C25.9010307@cadsoft.de>
References: <49293640.10808@cadsoft.de> <492A53C4.5030509@makhutov.org>
	<492DC5F5.3060501@gmx.de> <494FC15C.6020400@gmx.de>
	<495355F1.8020406@helmutauer.de>
	<1230219306.2336.25.camel@pc10.localdom.local>
	<20081231091321.55035a64@pedra.chehab.org>
	<495B5CE6.9010902@cadsoft.de>
	<20081231105036.2f9e6e76@pedra.chehab.org>
	<495B6C25.9010307@cadsoft.de>
Mime-Version: 1.0
Cc: linux-dvb-maintainer@linuxtv.org, linux-dvb@linuxtv.org,
	Manu Abraham <abraham.manu@gmail.com>
Subject: Re: [linux-dvb] [PATCH] Add missing S2 caps flag to S2API
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

On Wed, 31 Dec 2008 13:57:09 +0100
Klaus Schmidinger <Klaus.Schmidinger@cadsoft.de> wrote:

> > Maybe we may commit it as two separate patches:
> > 
> > The first one with the core changes, and the second one with the driver
> > (cx24116 and stb0899) ones. API changes are important enough to deserve their
> > own separate commit.
> 
> That's all fine with me.

Committed, thanks.

Cheers,
Mauro

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
