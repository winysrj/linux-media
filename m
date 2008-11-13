Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.kapsi.fi ([217.30.184.167] ident=Debian-exim)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1L0efE-0006sJ-R4
	for linux-dvb@linuxtv.org; Thu, 13 Nov 2008 17:03:25 +0100
Message-ID: <491C4FC8.9090308@iki.fi>
Date: Thu, 13 Nov 2008 18:03:20 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Jose Alberto Reguero <jareguero@telefonica.net>
References: <1587493004@web.de> <491C4A81.8020700@iki.fi>
	<200811131700.31884.jareguero@telefonica.net>
In-Reply-To: <200811131700.31884.jareguero@telefonica.net>
Cc: linux-dvb@linuxtv.org, Sebastian Marskamp <SebastianMarskamp@web.de>
Subject: Re: [linux-dvb] af9015 problem on fedora rawhide 9.93 with 2.6.27x
 kernel
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

Jose Alberto Reguero wrote:
> El Jueves, 13 de Noviembre de 2008, Antti Palosaari escribi=F3:
>> Sebastian Marskamp wrote:
>>> Theres also a patch   , which works fine for me.
>>>
>>> http://www.linuxtv.org/pipermail/linux-dvb/attachments/20081022/94261bb=
c/
>>> attachment.diff
>> This patch is not OK because it still sends reconnect USB-command. It
>> may lead to situation stick reconnects but driver does not except that.
>>
>> It seems like problem is that it sends USB-reconnect command to the
>> stick firmware immediately after firmware is downloaded. Sometimes
>> (especially Kernel 2.6.27) USB-reconnect command will be rejected by
>> stick firmware because firmware is not started yet. Small sleep just
>> before USB-reconnect is needed to ensure stick firmware is running.
>>
>> Is there anyone who has this problem and can make & test patch?
>>
>> regards
>> Antti
> =

> The attached patch work for me.
> =

> Jose Alberto

Looks better, could you provide signed-off-by?

regards
Antti

-- =

http://palosaari.fi/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
