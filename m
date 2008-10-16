Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from yx-out-2324.google.com ([74.125.44.28])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <softnhard.es@gmail.com>) id 1KqO7S-0001EW-9v
	for linux-dvb@linuxtv.org; Thu, 16 Oct 2008 10:22:07 +0200
Received: by yx-out-2324.google.com with SMTP id 8so690770yxg.41
	for <linux-dvb@linuxtv.org>; Thu, 16 Oct 2008 01:22:01 -0700 (PDT)
Message-ID: <d2f7e03e0810160122j49f7618dr9a571b140da9806b@mail.gmail.com>
Date: Thu, 16 Oct 2008 11:52:01 +0330
From: "Seyyed Mohammad mohammadzadeh" <softnhard.es@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: [linux-dvb] .:: TT3200 doesn't work on 8PSK channels::.
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0276209004=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0276209004==
Content-Type: multipart/alternative;
	boundary="----=_Part_28446_12243940.1224145321283"

------=_Part_28446_12243940.1224145321283
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

I'm using a TT3200 and I installed drivers using
http://linuxtv.org/wiki/index.php/TechnoTrend_TT-budget_S2-3200 manual.
using standard szap program I can tune to most of the QPSK channels on
Hotbird but none of the 8PSK channels.
After installing drivers from
http://mercurial.intuxication.org/hg/s2-liplianin no difference could be
notified and also no 8PSK channels can be tunned via szap/dvbtune/dvbstream.
I have tested szap2 from http://mercurial.intuxication.org/hg/szap2  and got
the following error for a QPSK channel:

reading channels from file '/root/.szap/channels.conf'
zapping to 4 'HBQPSK2':
sat 0, frequency = 10723 MHz V, symbolrate 27500000, vpid = 0x0430, apid =
0x04f8 sid = 0x0001 (fec = -2147483648, mod = 2)
Querying info .. Delivery system=DVB-S
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
ioctl DVBFE_GET_INFO failed: Operation not supported

I have tried to compile szap-s2 from
http://mercurial.intuxication.org/hg/szap-s2<http://mercurial.intuxication.org/hg/szap2>but
seems that the new szap programs needs Linux DVB API version 5 that I
couldn't find it.

-- 
Best Regards
Mehran

------=_Part_28446_12243940.1224145321283
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div dir="ltr"><br clear="all">I&#39;m using a TT3200 and I installed drivers using <a title="http://linuxtv.org/wiki/index.php/TechnoTrend_TT-budget_S2-3200" href="http://linuxtv.org/wiki/index.php/TechnoTrend_TT-budget_S2-3200" target="_blank">http://linuxtv.org/wiki/index.php/TechnoTrend_TT-budget_S2-3200</a> manual. using standard szap program I can tune to most of the QPSK channels on Hotbird but none of the 8PSK channels. <br>

After installing drivers from <a href="http://mercurial.intuxication.org/hg/s2-liplianin" target="_blank">http://mercurial.intuxication.org/hg/s2-liplianin</a> no difference could be notified and also no 8PSK channels can be tunned via szap/dvbtune/dvbstream. I have tested szap2 from <a href="http://mercurial.intuxication.org/hg/szap2" target="_blank">http://mercurial.intuxication.org/hg/szap2</a>&nbsp; and got the following error for a QPSK channel:<br>

<br>reading channels from file &#39;/root/.szap/channels.conf&#39;<br>zapping to 4 &#39;HBQPSK2&#39;:<br>sat 0, frequency = 10723 MHz V, symbolrate 27500000, vpid = 0x0430, apid = 0x04f8 sid = 0x0001 (fec = -2147483648, mod = 2)<br>

Querying info .. Delivery system=DVB-S<br>using &#39;/dev/dvb/adapter0/frontend0&#39; and &#39;/dev/dvb/adapter0/demux0&#39;<br>ioctl DVBFE_GET_INFO failed: Operation not supported<br><br>I have tried to compile szap-s2 from <a href="http://mercurial.intuxication.org/hg/szap2" target="_blank">http://mercurial.intuxication.org/hg/szap-s2</a> but seems that the new szap programs needs Linux DVB API version 5 that I couldn&#39;t find it. <br>

<br>-- <br>Best Regards<br>Mehran<br><br><br>
</div>

------=_Part_28446_12243940.1224145321283--


--===============0276209004==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0276209004==--
