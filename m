Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.work.de ([212.12.32.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1KbJoY-0004rE-Qx
	for linux-dvb@linuxtv.org; Thu, 04 Sep 2008 20:44:19 +0200
Message-ID: <48C02C7B.2060201@gmail.com>
Date: Thu, 04 Sep 2008 22:44:11 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: o_lucian@yahoo.com
References: <23657.38924.qm@web55603.mail.re4.yahoo.com>
In-Reply-To: <23657.38924.qm@web55603.mail.re4.yahoo.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] S2API - First release
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

lucian orasanu wrote:
> Hello Steven Toth,
> 
> I was not pro for new DVBS2 API, but seeing now how fast the things are mouving, I think this is reale goodand cool, can you add  your API to stb6100 and stb08900 driver?
> 


Let me put things a bit clear. The multiproto tree already supports
DVB-S2 and future modulations, with backward compatibility. Also all
STB0899 based devices are supported by the multiproto tree. Patches do
exist for the cx24116 devices as well. Once the API patches are in
kernel (a pull request is already pending) it will be easy to add in
newer devices as well.

If you need to use the stb0899 based drivers, you can simply pull the
tree from http:http://jusst.de/hg/multiproto

It is available -now- you don't have to wait for things

Regards,
Manu

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
