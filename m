Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <HWerner4@gmx.de>) id 1LLIc1-0004Ff-QK
	for linux-dvb@linuxtv.org; Fri, 09 Jan 2009 15:45:29 +0100
Date: Fri, 09 Jan 2009 15:44:50 +0100
From: "Hans Werner" <HWerner4@gmx.de>
In-Reply-To: <49673D65.9030404@gmail.com>
Message-ID: <20090109144450.4110@gmx.net>
MIME-Version: 1.0
References: <mailman.1.1231412401.14666.linux-dvb@linuxtv.org>
	<26D75E582F22456998AE6365440ACEC6@xplap> <49673D65.9030404@gmail.com>
To: Manu Abraham <abraham.manu@gmail.com>, reklam@holisticode.se
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Compiling mantis driver on 2.6.28
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

> M=E5rten Gustafsson wrote:
> > I tried downloading and compiling from s2-liplianin repository.
> > Unfortunately the driver doesn't work at all with AzureWave AD-CP300,
> > frontend tda10021 is identified instead of tda10023.
> =

> The official mantis repository is at http://jusst.de/hg/mantis. It =

> contains the latest mantis related changes. =

> =

> Please do test and report.
> =

> =

> Regards,
> Manu

The repository at http://jusst.de/hg/mantis does not compile with 2.6.28.

Try s2-liplianin again : it has been patched to fix the tda10021/tda10023 i=
ssue.

Hans

-- =

Release early, release often.

Sensationsangebot verl=E4ngert: GMX FreeDSL - Telefonanschluss + DSL =

f=FCr nur 16,37 Euro/mtl.!* http://dsl.gmx.de/?ac=3DOM.AD.PD003K1308T4569a

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
