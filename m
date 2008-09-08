Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.work.de ([212.12.32.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1KcnlC-0005Tw-SJ
	for linux-dvb@linuxtv.org; Mon, 08 Sep 2008 22:54:59 +0200
Message-ID: <48C5911A.4050808@gmail.com>
Date: Tue, 09 Sep 2008 00:54:50 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: Jelle De Loecker <skerit@kipdola.com>
References: <364203.80680.qm@web46101.mail.sp1.yahoo.com>	<48C58D03.8040004@gmail.com>
	<48C58F6B.9000609@kipdola.com>
In-Reply-To: <48C58F6B.9000609@kipdola.com>
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Multiproto API/Driver Update
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

Jelle De Loecker wrote:
> Is there any change in the cultiproto disecq code?
> 

No newer changes on the diseqc part.

> For example
> MythTV won't tune to channels on disecq port 2 or higher. (Disecq port 1
> always works)
> 
> However, Kaffeine works. I'm able to watch every BBC channel on Astra
> 28,2 (which is on my second port)
> 
> This made me think it's MythTV.

There was a post on the VDR ML a while back on the same. It was the
DiSEqC Command sequence being used. There was a discussion on that very
same topic. You can do a quick lookup on the archives for the same.


Regards,
Manu

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
