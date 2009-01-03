Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rouge.crans.org ([138.231.136.3])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <braice@braice.net>) id 1LJ9s8-0001iK-Ah
	for linux-dvb@linuxtv.org; Sat, 03 Jan 2009 18:01:12 +0100
Received: from localhost (localhost.crans.org [127.0.0.1])
	by rouge.crans.org (Postfix) with ESMTP id 2B4AC82E8
	for <linux-dvb@linuxtv.org>; Sat,  3 Jan 2009 18:01:07 +0100 (CET)
Received: from rouge.crans.org ([10.231.136.3])
	by localhost (rouge.crans.org [10.231.136.3]) (amavisd-new, port 10024)
	with LMTP id qCYLQeOOb58V for <linux-dvb@linuxtv.org>;
	Sat,  3 Jan 2009 18:01:07 +0100 (CET)
Received: from [192.168.1.10] (116.pool85-50-88.dynamic.orange.es
	[85.50.88.116])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by rouge.crans.org (Postfix) with ESMTP id E1B8D8073
	for <linux-dvb@linuxtv.org>; Sat,  3 Jan 2009 18:01:06 +0100 (CET)
Message-ID: <495F99CD.8000202@braice.net>
Date: Sat, 03 Jan 2009 18:01:01 +0100
From: Brice DUBOST <braice@braice.net>
MIME-Version: 1.0
CC: linux-dvb@linuxtv.org
References: <op.um6wpcvirj95b0@localhost>
In-Reply-To: <op.um6wpcvirj95b0@localhost>
Subject: Re: [linux-dvb] DVB-S Channel searching problem
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Roman Jarosz a =E9crit :
> Hi,
> =

> I have a problem with DVB-S channel searching, the scan command doesn't f=
ind all channels in Linux on Astra 19.2E.
> It works in Windows.
> =

> For instance the scan doesn't find RTL2, but if I add to channels.conf
> RTL2:12187:h:0:27500:166:128:12020
> then szap -r works correctly.
> =

> I have TeVii S460 DVB-S/S2.
> Linux kernel 2.6.28.
> =

> Can anybody help me to find out why the scan doesn't work correctly.
> I've compiled kernel from source so I can apply patches or change its set=
tings.
> =

> Regards,
> Roman
> =



Hello

Scan tunes on one frequency, and uses the informations given by the
provider to find the others

Sometimes (quite often in fact) the providers doesn't give full informations

You can use wscan wich will try to lock on each possible frequency
(longer method)

regards

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
