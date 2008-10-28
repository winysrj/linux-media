Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ns1.nijcomplesk5.nl ([83.172.148.40])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jean-paul@goedee.nl>) id 1Kulbu-0003wh-6s
	for linux-dvb@linuxtv.org; Tue, 28 Oct 2008 11:15:38 +0100
Message-ID: <20081028111538.1yl7p80uo0cggo80@webmail.goedee.nl>
Date: Tue, 28 Oct 2008 11:15:38 +0100
From: jean-paul@goedee.nl
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] S2API & TT3200
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

Ok again.

I using now vdr 1.7.0 and multiproto from  manu to make my two tt  
3200-ci working with streamdev. Vdr zapper en MPC. Its working fine  
except some judder  but its more a vdr issue.

For now I have a development system with an TT 3200 to and try to let  
vdr run with S2API drivers.  After getting the drivers from  
http://mercurial.intuxication.org/hg/s2-liplianin/ the compile ends  
with a error:

   CC [M]  /usr/local/src/dvb/v4l/cx88-vbi.o
   CC [M]  /usr/local/src/dvb/v4l/cx88-mpeg.o
   CC [M]  /usr/local/src/dvb/v4l/cx88-cards.o
/usr/local/src/dvb/v4l/cx88-cards.c:2314: error: request for member  
'subdevice' in something not a structure or union
make[4]: *** [/usr/local/src/dvb/v4l/cx88-cards.o] Error 1
make[3]: *** [_module_/usr/local/src/dvb/v4l] Error
make[2]: *** [sub-make] Error 2
make[1]: *** [all] Error 2
make[1]: Leaving directory `/usr/src/linux-2.6.25.16-0.1-obj/x86_64/default'
make: *** [default] Error 2


Remove those stuff I?m not using and compile it again. Reboot the  
system and try to use scan-s2. Next problem. Diseqc doesn?t work  
anymore and I?m   able to scan one transponder.

Is it possible to make a list with patches and repositories I need to  
make it working?


Regards


Jean-Paul




_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
