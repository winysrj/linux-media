Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.work.de ([212.12.32.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1JUVLO-0003ej-KC
	for linux-dvb@linuxtv.org; Thu, 28 Feb 2008 00:05:46 +0100
Message-ID: <47C5ECC1.2@gmail.com>
Date: Thu, 28 Feb 2008 03:05:37 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: Michael Curtis <michael.curtis@glcweb.co.uk>
References: <A33C77E06C9E924F8E6D796CA3D635D1023978@w2k3sbs.glcdomain.local>
In-Reply-To: <A33C77E06C9E924F8E6D796CA3D635D1023978@w2k3sbs.glcdomain.local>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] make errors multiproto
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

Michael Curtis wrote:
> Can anyone help with this please?
> 

Disable that relevant module by using a custom config, such as
using make menuconfig, or make xconfig or whatever.


Regards,
Manu

> -----Original Message-----
> From: linux-dvb-bounces@linuxtv.org [mailto:linux-dvb-bounces@linuxtv.org] On Behalf Of Michael Curtis
> Sent: 20 February 2008 08:03
> To: linux-dvb@linuxtv.org
> Subject: [linux-dvb] make errors multiproto
> 
> Hi all
> 
> The following errors occurred during the 'make all' of the multiproto
> install
> 
> The mercurial was from the above date
> 
> I am using the TT3200 so the stb0899 errors will matter
> 
> 
> /home/mythtv/dvb/multiproto/v4l/dvb_frontend.c: In function
> 'dvb_frontend_thread':
> /home/mythtv/dvb/multiproto/v4l/dvb_frontend.c:1123: warning: unused
> variable 'status'
> /home/mythtv/dvb/multiproto/v4l/stb0899_drv.c: In function
> 'stb0899_diseqc_init':
> /home/mythtv/dvb/multiproto/v4l/stb0899_drv.c:834: warning: unused
> variable 'ret_2'
> /home/mythtv/dvb/multiproto/v4l/stb0899_drv.c:833: warning: unused
> variable 'ret_1'
> /home/mythtv/dvb/multiproto/v4l/stb0899_drv.c:832: warning: unused
> variable 'trial'
> /home/mythtv/dvb/multiproto/v4l/stb0899_drv.c:830: warning: unused
> variable 'i'
> /home/mythtv/dvb/multiproto/v4l/stb0899_drv.c:830: warning: unused
> variable 'count'
> /home/mythtv/dvb/multiproto/v4l/stb0899_drv.c:826: warning: unused
> variable 'rx_data'
> /home/mythtv/dvb/multiproto/v4l/stb0899_drv.c: In function
> 'stb0899_sleep':
> /home/mythtv/dvb/multiproto/v4l/stb0899_drv.c:899: warning: unused
> variable 'reg'
> /home/mythtv/dvb/multiproto/v4l/stb0899_drv.c: In function
> 'stb0899_track':
> /home/mythtv/dvb/multiproto/v4l/stb0899_drv.c:1935: warning: unused
> variable 'internal'
> /home/mythtv/dvb/multiproto/v4l/stb0899_drv.c:1932: warning: unused
> variable 'lock_lost'
> /home/mythtv/dvb/multiproto/v4l/stb0899_drv.c: At top level:
> /home/mythtv/dvb/multiproto/v4l/stb0899_drv.c:1727: warning:
> 'stb0899_track_carrier' defined but not used
> /home/mythtv/dvb/multiproto/v4l/stb0899_drv.c:1744: warning:
> 'stb0899_get_ifagc' defined but not used
> /home/mythtv/dvb/multiproto/v4l/stb0899_drv.c:1761: warning:
> 'stb0899_get_s1fec' defined but not used
> /home/mythtv/dvb/multiproto/v4l/stb0899_drv.c:1789: warning:
> 'stb0899_get_modcod' defined but not used
> /home/mythtv/dvb/multiproto/v4l/radio-si470x.c: In function
> 'si470x_get_rds_registers':
> /home/mythtv/dvb/multiproto/v4l/radio-si470x.c:562: warning: format '%d'
> expects type 'int', but argument 3 has type 'long unsigned int'
> 
> Regards
> 
> Mike curtis
> 
> 
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> 


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
