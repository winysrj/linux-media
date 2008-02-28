Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.work.de ([212.12.32.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1JUf5Z-0002Gk-Ol
	for linux-dvb@linuxtv.org; Thu, 28 Feb 2008 10:30:05 +0100
Message-ID: <47C67F13.4050906@gmail.com>
Date: Thu, 28 Feb 2008 13:29:55 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: Simeon Simeonov <simeonov_2000@yahoo.com>
References: <803523.78624.qm@web33103.mail.mud.yahoo.com>
In-Reply-To: <803523.78624.qm@web33103.mail.mud.yahoo.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] STB0899 users,
 please verify results was Re: TechniSat SkyStar HD: Problems
 scaning and zaping
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

Simeon Simeonov wrote:
> I don't know if is the same but with the latest mantis tree I get 100% success.
> Reverting to changeset mantis-100d4b009238 (which I think corresponds to multiproto 7200)
> I do NOT any locks on the same transponder.

For the mantis tree, please test this changeset: 7275	72e81184fb9f as head
Please test how that looks in comparison to tip changeset 7282	a9ecd19a37c9

Regards,
Manu

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
