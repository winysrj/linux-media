Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from [212.57.247.218] (helo=glcweb.co.uk)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <michael.curtis@glcweb.co.uk>) id 1JRjvS-0006oj-Cc
	for linux-dvb@linuxtv.org; Wed, 20 Feb 2008 09:03:34 +0100
Content-class: urn:content-classes:message
MIME-Version: 1.0
Date: Wed, 20 Feb 2008 08:02:57 -0000
Message-ID: <A33C77E06C9E924F8E6D796CA3D635D1023975@w2k3sbs.glcdomain.local>
From: "Michael Curtis" <michael.curtis@glcweb.co.uk>
To: <linux-dvb@linuxtv.org>
Subject: [linux-dvb] make errors multiproto
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

Hi all

The following errors occurred during the 'make all' of the multiproto
install

The mercurial was the latest from jusste.de

I am using the TT3200 so the stb0899 errors will matter


/home/mythtv/dvb/multiproto/v4l/dvb_frontend.c: In function
'dvb_frontend_thread':
/home/mythtv/dvb/multiproto/v4l/dvb_frontend.c:1123: warning: unused
variable 'status'
/home/mythtv/dvb/multiproto/v4l/stb0899_drv.c: In function
'stb0899_diseqc_init':
/home/mythtv/dvb/multiproto/v4l/stb0899_drv.c:834: warning: unused
variable 'ret_2'
/home/mythtv/dvb/multiproto/v4l/stb0899_drv.c:833: warning: unused
variable 'ret_1'
/home/mythtv/dvb/multiproto/v4l/stb0899_drv.c:832: warning: unused
variable 'trial'
/home/mythtv/dvb/multiproto/v4l/stb0899_drv.c:830: warning: unused
variable 'i'
/home/mythtv/dvb/multiproto/v4l/stb0899_drv.c:830: warning: unused
variable 'count'
/home/mythtv/dvb/multiproto/v4l/stb0899_drv.c:826: warning: unused
variable 'rx_data'
/home/mythtv/dvb/multiproto/v4l/stb0899_drv.c: In function
'stb0899_sleep':
/home/mythtv/dvb/multiproto/v4l/stb0899_drv.c:899: warning: unused
variable 'reg'
/home/mythtv/dvb/multiproto/v4l/stb0899_drv.c: In function
'stb0899_track':
/home/mythtv/dvb/multiproto/v4l/stb0899_drv.c:1935: warning: unused
variable 'internal'
/home/mythtv/dvb/multiproto/v4l/stb0899_drv.c:1932: warning: unused
variable 'lock_lost'
/home/mythtv/dvb/multiproto/v4l/stb0899_drv.c: At top level:
/home/mythtv/dvb/multiproto/v4l/stb0899_drv.c:1727: warning:
'stb0899_track_carrier' defined but not used
/home/mythtv/dvb/multiproto/v4l/stb0899_drv.c:1744: warning:
'stb0899_get_ifagc' defined but not used
/home/mythtv/dvb/multiproto/v4l/stb0899_drv.c:1761: warning:
'stb0899_get_s1fec' defined but not used
/home/mythtv/dvb/multiproto/v4l/stb0899_drv.c:1789: warning:
'stb0899_get_modcod' defined but not used
/home/mythtv/dvb/multiproto/v4l/radio-si470x.c: In function
'si470x_get_rds_registers':
/home/mythtv/dvb/multiproto/v4l/radio-si470x.c:562: warning: format '%d'
expects type 'int', but argument 3 has type 'long unsigned int'

Regards

Mike curtis


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
