Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from [212.57.247.218] (helo=glcweb.co.uk)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <michael.curtis@glcweb.co.uk>) id 1JgPki-0001v6-Lp
	for linux-dvb@linuxtv.org; Mon, 31 Mar 2008 21:33:10 +0200
Date: Mon, 31 Mar 2008 20:32:33 +0100
MIME-Version: 1.0
Message-ID: <A33C77E06C9E924F8E6D796CA3D635D1023987@w2k3sbs.glcdomain.local>
Content-class: urn:content-classes:message
From: "Michael Curtis" <michael.curtis@glcweb.co.uk>
To: <linux-dvb@linuxtv.org>
Subject: [linux-dvb] Compile errors Multiproto
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


Are these compile errors anything to worry about?

2.6.24.3-34.fc8 #1 SMP Wed Mar 12 18:17:20 EDT 2008 i686 athlon i386 GNU/Linux

Latest hg clone of multiproto

[root@mythhost multiproto]# make > errors

/opt/dvb/multiproto/v4l/dvb_frontend.c: In function 'dvb_frontend_thread':
/opt/dvb/multiproto/v4l/dvb_frontend.c:1126: warning: unused variable 'status'
/opt/dvb/multiproto/v4l/stb0899_drv.c: In function 'stb0899_diseqc_init':
/opt/dvb/multiproto/v4l/stb0899_drv.c:834: warning: unused variable 'ret_2'
/opt/dvb/multiproto/v4l/stb0899_drv.c:833: warning: unused variable 'ret_1'
/opt/dvb/multiproto/v4l/stb0899_drv.c:832: warning: unused variable 'trial'
/opt/dvb/multiproto/v4l/stb0899_drv.c:830: warning: unused variable 'i'
/opt/dvb/multiproto/v4l/stb0899_drv.c:830: warning: unused variable 'count'
/opt/dvb/multiproto/v4l/stb0899_drv.c:826: warning: unused variable 'rx_data'
/opt/dvb/multiproto/v4l/stb0899_drv.c: In function 'stb0899_sleep':
/opt/dvb/multiproto/v4l/stb0899_drv.c:899: warning: unused variable 'reg'
/opt/dvb/multiproto/v4l/stb0899_drv.c: In function 'stb0899_track':
/opt/dvb/multiproto/v4l/stb0899_drv.c:1930: warning: unused variable 'internal'
/opt/dvb/multiproto/v4l/stb0899_drv.c:1927: warning: unused variable 'lock_lost'
/opt/dvb/multiproto/v4l/stb0899_drv.c: At top level:
/opt/dvb/multiproto/v4l/stb0899_drv.c:1722: warning: 'stb0899_track_carrier' defined but not used
/opt/dvb/multiproto/v4l/stb0899_drv.c:1739: warning: 'stb0899_get_ifagc' defined but not used
/opt/dvb/multiproto/v4l/stb0899_drv.c:1756: warning: 'stb0899_get_s1fec' defined but not used
/opt/dvb/multiproto/v4l/stb0899_drv.c:1784: warning: 'stb0899_get_modcod' defined but not used


Regards

Mike Curtis

No virus found in this outgoing message.
Checked by AVG. 
Version: 7.5.519 / Virus Database: 269.22.1/1350 - Release Date: 30/03/2008 12:32
 

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
