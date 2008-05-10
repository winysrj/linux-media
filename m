Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from f53.mail.ru ([194.67.57.88])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <goga777@bk.ru>) id 1JulBT-0002BF-Kp
	for linux-dvb@linuxtv.org; Sat, 10 May 2008 11:16:04 +0200
From: Igor <goga777@bk.ru>
To: Philipp Kolmann <philipp@kolmann.at>
Mime-Version: 1.0
Date: Sat, 10 May 2008 13:15:19 +0400
In-Reply-To: <20080510085803.GA30598@kolmann.at>
References: <20080510085803.GA30598@kolmann.at>
Message-Id: <E1JulAl-0001Ho-00.goga777-bk-ru@f53.mail.ru>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb]
	=?koi8-r?b?TWFudGlzLTA4ZjI3ZWY5OWQ3NDogQ29tcGlsZSBl?=
	=?koi8-r?b?cnJvciB3aXRoIDIuNi4yNQ==?=
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

could you try with the latest mantis version
http://jusst.de/hg/mantis/rev/b7b8a2a81f3e

and during of the compilation you should use the updated dvb-headers - frontend.h anf version.h from mantis tree

> I have a Terratec Cinergy C which worked with the mantis driver and 2.6.24
> fine. Now I have updated to 2.6.25 and can't compile the mantis driver
> anymore:
> 
> [...]
>   CC [M]  /home/philipp/test/deb/dvb/mantis-08f27ef99d74/v4l/cx23885-dvb.o
>   CC [M]  /home/philipp/test/deb/dvb/mantis-08f27ef99d74/v4l/cx25840-core.o
> /home/philipp/test/deb/dvb/mantis-08f27ef99d74/v4l/cx25840-core.c:71: error: conflicting type qualifiers for 'addr_data'
> /home/philipp/test/deb/dvb/mantis-08f27ef99d74/v4l/../linux/include/media/v4l2-i2c-drv-legacy.h:41: error: previous declaration of 'addr_data' was here
> make[3]: *** [/home/philipp/test/deb/dvb/mantis-08f27ef99d74/v4l/cx25840-core.o] Error 1
> make[2]: *** [_module_/home/philipp/test/deb/dvb/mantis-08f27ef99d74/v4l] Error 2
> make[2]: Leaving directory `/usr/src/linux-headers-2.6.25-1-686'
> make[1]: *** [default] Error 2
> make[1]: Leaving directory `/home/philipp/test/deb/dvb/mantis-08f27ef99d74/v4l'
> make: *** [all] Error 2
> 
> Any ideas how to solve this.
> 
> Thanks
> Philipp
> 
> PS: Anyone know, if and when mantis will be merged with v4l-dvb tree?

good question. I don't know :(

Igor

 

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
