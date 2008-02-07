Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from web57805.mail.re3.yahoo.com ([68.142.236.83])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <ar.saikia@yahoo.com>) id 1JMzMf-0000mD-LT
	for linux-dvb@linuxtv.org; Thu, 07 Feb 2008 06:32:01 +0100
Date: Wed, 6 Feb 2008 21:31:28 -0800 (PST)
From: ashim saikia <ar.saikia@yahoo.com>
To: Linux Forum 4 Dvb <linux-dvb@linuxtv.org>
MIME-Version: 1.0
Message-ID: <416132.40663.qm@web57805.mail.re3.yahoo.com>
Subject: [linux-dvb] How To Compile LINUX 2.6.24 KERNEL MODULES
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1719222731=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1719222731==
Content-Type: multipart/alternative; boundary="0-927905258-1202362288=:40663"

--0-927905258-1202362288=:40663
Content-Type: text/plain; charset=us-ascii

Hi,
M a kernel newbabie.. I want to compile a DVB device driver module into a running kernel. I have modified the makefile present in /usr/src/linux-2.6.24/drivers/media/dvb/dvb-core/ Makefile and have add the following code.

#
# Makefile for the kernel DVB device drivers.
#

dvb-core-objs -m = dvbdev.o dmxdev.o dvb_demux.o dvb_filter.o   \
                 dvb_ca_en50221.o dvb_frontend.o                \
                 dvb_net.o dvb_ringbuffer.o dvb_math.o

KVERSION = $(shell uname -r)

all:
        make -C /lib/modules/$(KVERSION)/build M=$(PWD) modules

clean:
        make -C /lib/modules/$(KVERSION)/build M=$(PWD) clean

But I am still unable to make this files.
Can anybody help me telling how I need to compile this modified code to the  running kernel. If possible please give me the steps.

Regards




      ____________________________________________________________________________________
Looking for last minute shopping deals?  
Find them fast with Yahoo! Search.  http://tools.search.yahoo.com/newsearch/category.php?category=shopping
--0-927905258-1202362288=:40663
Content-Type: text/html; charset=us-ascii

<html><head><style type="text/css"><!-- DIV {margin:0px;} --></style></head><body><div style="font-family:times new roman, new york, times, serif;font-size:12pt"><div>Hi,<br>M a kernel newbabie.. I want to compile a DVB device driver module into a running kernel. I have modified the makefile present in /usr/src/linux-2.6.24/drivers/media/dvb/dvb-core/ Makefile and have add the following code.<br><br>#<br># Makefile for the kernel DVB device drivers.<br>#<br><br>dvb-core-objs -m = dvbdev.o dmxdev.o dvb_demux.o dvb_filter.o&nbsp;&nbsp; \<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; dvb_ca_en50221.o dvb_frontend.o&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; \<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; dvb_net.o dvb_ringbuffer.o dvb_math.o<br><br>KVERSION = $(shell uname
 -r)<br><br>all:<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; make -C /lib/modules/$(KVERSION)/build M=$(PWD) modules<br><br>clean:<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; make -C /lib/modules/$(KVERSION)/build M=$(PWD) clean<br><br>But I am still unable to make this files.<br>Can anybody help me telling how I need to compile this modified code to the&nbsp; running kernel. If possible please give me the steps.<br><br>Regards<br></div></div><br>
      <hr size=1>Looking for last minute shopping deals? <a href="http://us.rd.yahoo.com/evt=51734/*http://tools.search.yahoo.com/newsearch/category.php?category=shopping"> 
Find them fast with Yahoo! Search.</a></body></html>
--0-927905258-1202362288=:40663--


--===============1719222731==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1719222731==--
