Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.work.de ([212.12.32.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1JVwyr-00012E-Iv
	for linux-dvb@linuxtv.org; Sun, 02 Mar 2008 23:48:29 +0100
Message-ID: <47CB2EB1.8040806@gmail.com>
Date: Mon, 03 Mar 2008 02:48:17 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Andr=E9_Weidemann?= <Andre.Weidemann@web.de>
References: <47C92937.7000703@web.de>
In-Reply-To: <47C92937.7000703@web.de>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] Support for TT connect S2-3600
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

Andr=E9 Weidemann wrote:

> Note:
> Manu's code in changeset 7207 seems to have broken tuning for this =

> device. Changesets 7202 to 7205 are still working.

Cool, thanks for testing. Still need to figure out why deselecting =

puncture rates
doesn't work as expected. Have pulled out the offending changeset for =

the time
being. Will try to get some answers soon.

Regards,
Manu


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
