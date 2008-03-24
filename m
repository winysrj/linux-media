Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from f152.mail.ru ([194.67.57.238])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <goga777@bk.ru>) id 1JdmTp-0007Qc-KY
	for linux-dvb@linuxtv.org; Mon, 24 Mar 2008 14:12:49 +0100
From: Igor <goga777@bk.ru>
To: Gasiu <gasiu@konto.pl>
Mime-Version: 1.0
Date: Mon, 24 Mar 2008 16:12:15 +0300
References: <47E7A6F5.8030106@konto.pl>
In-Reply-To: <47E7A6F5.8030106@konto.pl>
Message-Id: <E1JdmTH-000FPx-00.goga777-bk-ru@f152.mail.ru>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb]
	=?koi8-r?b?SSdtIG5vdCBhYmxlIHRvIGNvbXBpbGUgaGFja2Vk?=
	=?koi8-r?b?IHN6YXAuIHdpdGggbmV3IG11bHRpcHJvdG8=?=
Reply-To: Igor <goga777@bk.ru>
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

with new multiproto you should use the szap2 from http://linuxtv.org/hg/dvb-apps/file/2686c080e0b5/test/

Igor


-----Original Message-----
From: Gasiu <gasiu@konto.pl>
To: linux-dvb@linuxtv.org
Date: Mon, 24 Mar 2008 14:04:53 +0100
Subject: [linux-dvb] I'm not able to compile hacked szap. with new multiproto

> I'm not able to compile hacked szap (from 
> abraham.manu.googlepages.com/szap.c) with new multiproto (b5a34b6a209d). 
> 2 weeks ago was a change, and now by compiling:
> 
> CC szap
> szap.c: In function  zap_to':
> szap.c:368: error:  struct dvbfe_info' has no member named  delivery'
> szap.c:372: error:  struct dvbfe_info' has no member named  delivery'
> szap.c:376: error:  struct dvbfe_info' has no member named  delivery'
> szap.c:401: error:  struct dvbfe_info' has no member named  delivery'
> szap.c:412: error:  struct dvbfe_info' has no member named  delivery'
> make: *** [szap] Error 1
> 
> szap from:
> 
> dvb-apps-2686c080e0b5.tar.gz
> 
> doesn't work...
> 
> 
> ./szap polonia
> reading channels from file '/home/gasiu/.szap/channels.conf'
> zapping to 4 'polonia':
> sat 0, frequency = 11488 MHz H, symbolrate 27500000, vpid = 0x00a0, apid 
> = 0x0050 sid = 0x13ed
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> FE_READ_STATUS failed: Invalid argument
> status 40000 | signal fffe | snr fffe | ber fffffffe | unc fffffffe |
> FE_READ_STATUS failed: Invalid argument
> status 40000 | signal fffe | snr fffe | ber fffffffe | unc fffffffe |
> FE_READ_STATUS failed: Invalid argument
> status 40000 | signal fffe | snr fffe | ber fffffffe | unc fffffffe |


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
