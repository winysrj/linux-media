Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from web55606.mail.re4.yahoo.com ([206.190.58.230])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <o_lucian@yahoo.com>) id 1KcNsr-00026d-1t
	for linux-dvb@linuxtv.org; Sun, 07 Sep 2008 19:17:10 +0200
Date: Sun, 7 Sep 2008 10:16:33 -0700 (PDT)
From: lucian orasanu <o_lucian@yahoo.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Message-ID: <946638.16132.qm@web55606.mail.re4.yahoo.com>
Subject: [linux-dvb] Update multiproto to recent kernel
Reply-To: o_lucian@yahoo.com
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

Hy,

Maybe this will help you: 

cd /usr/local/src/dvb/linux/include/linux
ln -s /usr/src/linux/include/linux/compiler.h compiler.h

Is from here :


http://www.vdr-wiki.de/wiki/index.php/OpenSUSE_VDR_DVB-S2_-_Teil2:_DVB_Treiber

Regard Lucian.


      

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
