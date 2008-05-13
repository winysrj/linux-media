Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from viefep18-int.chello.at ([213.46.255.22]
	helo=viefep23-int.chello.at)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <rscheidegger_lists@hispeed.ch>) id 1JvtNk-0003ln-T1
	for linux-dvb@linuxtv.org; Tue, 13 May 2008 14:14:10 +0200
Message-ID: <4829856F.4080601@hispeed.ch>
Date: Tue, 13 May 2008 14:11:27 +0200
From: Roland Scheidegger <rscheidegger_lists@hispeed.ch>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
References: <198698.40491.qm@web55111.mail.re4.yahoo.com>	<200805121720.37639.boexli@gmx.net>
	<48297A72.4050305@iki.fi>
In-Reply-To: <48297A72.4050305@iki.fi>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Terratec Cinergy PCI C  HDTV
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

On 13.05.2008 13:24, Antti Palosaari wrote:
> nick kirjoitti:
>> Hi - Has anybody successfully managed to watch HDTV using the Terratec Cinergy 
>> PCI C card?  If is switch to a HD channel using Kaffeine nothing happens and 
>> after a couple of minutes the program freezes and does not reponse anymore. 
>> Any ideas what I might have done wrong? Thanks Nick
> 
> There might be bug in the driver.
> 
> Someone has similar problem in unbuntu-fi forum and he has hacked driver 
> to get it working. Hacked solution is most probably wrong and could be 
> break other functionality. Feel free to try.
> http://forum.ubuntu-fi.org/index.php?topic=18193.0

No, this bug got fixed recently (and it broke the driver completely, the
parent poster only seems to have trouble with HD channels).

Roland

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
