Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mailout10.t-online.de ([194.25.134.21])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <rdwebert@t-online.de>) id 1KRq1w-0001Nz-1n
	for linux-dvb@linuxtv.org; Sat, 09 Aug 2008 17:06:58 +0200
From: "D. Webert" <rdwebert@t-online.de>
To: linux-dvb@linuxtv.org
Date: Sat, 9 Aug 2008 17:06:35 +0200
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200808091706.35601.rdwebert@t-online.de>
Subject: [linux-dvb] configuration of Cinergy DT USB XS
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

Using the guide 
at 'http://www.linuxtv.org/wiki/index.php/How_to_install_DVB_device_drivers ' 
to compile the v4l-dvb source code with 'make'  I get the following error 
message:
make -C /home/v4l-dvb/v4l
make[1]: Entering directory `/home/v4l-dvb/v4l'
creating symbolic links...
Kernel build directory is /lib/modules/2.6.25.11-0.1-pae/build
make -C /lib/modules/2.6.25.11-0.1-pae/build SUBDIRS=/home/v4l-dvb/v4l  
modules
make: Entering an unknown directory
make: *** /lib/modules/2.6.25.11-0.1-pae/build: No such file or directory.  
Stop.
make: Leaving an unknown directory
make[1]: *** [default] Fehler 2
make[1]: Leaving directory `/home//v4l-dvb/v4l'
make: *** [all] Fehler 2

Is that a known item or did I something wrong?

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
