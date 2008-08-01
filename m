Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from web34403.mail.mud.yahoo.com ([66.163.178.152])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <muppetman4662@yahoo.com>) id 1KP4Xs-0007L0-Pg
	for linux-dvb@linuxtv.org; Sat, 02 Aug 2008 02:00:29 +0200
Date: Fri, 1 Aug 2008 16:59:52 -0700 (PDT)
From: Muppet Man <muppetman4662@yahoo.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Message-ID: <595821.21214.qm@web34403.mail.mud.yahoo.com>
Subject: [linux-dvb] Error message trying to compile v4l with Fedora 9
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0553664231=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0553664231==
Content-Type: multipart/alternative; boundary="0-468723820-1217635192=:21214"

--0-468723820-1217635192=:21214
Content-Type: text/plain; charset=us-ascii

Greetings all,
I am attempting to compile the v4l-dvb drivers via the instructions on the website, but when I go into root to "make" I get this error.

[root@localhost ~]# cd /home/ed/v4l-dvb/
[root@localhost v4l-dvb]# make
make -C /home/ed/v4l-dvb/v4l 
make[1]: Entering directory `/home/ed/v4l-dvb/v4l'
No version yet, using 2.6.25.11-97.fc9.i686
make[1]: Leaving directory `/home/ed/v4l-dvb/v4l'
make[1]: Entering directory `/home/ed/v4l-dvb/v4l'
scripts/make_makefile.pl
Updating/Creating .config
Preparing to compile for kernel version 2.6.25
File not found: /lib/modules/2.6.25.11-97.fc9.i686/build/.config at ./scripts/make_kconfig.pl line 32, <IN> line 4.
make[1]: Leaving directory `/home/ed/v4l-dvb/v4l'
make[1]: Entering directory `/home/ed/v4l-dvb/v4l'
Updating/Creating .config
Preparing to compile for kernel version 2.6.25
File not found: /lib/modules/2.6.25.11-97.fc9.i686/build/.config at ./scripts/make_kconfig.pl line 32, <IN> line 4.
make[1]: *** No rule to make target `.myconfig', needed by `config-compat.h'.  Stop.
make[1]: Leaving directory `/home/ed/v4l-dvb/v4l'
make: *** [all] Error 2

I have searched around trying to find any answers but I found nothing.  Any help would be greatly appreciated.
Thanks



      
--0-468723820-1217635192=:21214
Content-Type: text/html; charset=us-ascii

<html><head><style type="text/css"><!-- DIV {margin:0px;} --></style></head><body><div style="font-family:times new roman,new york,times,serif;font-size:12pt"><div>Greetings all,<br>I am attempting to compile the v4l-dvb drivers via the instructions on the website, but when I go into root to "make" I get this error.<br><br>[root@localhost ~]# cd /home/ed/v4l-dvb/<br>[root@localhost v4l-dvb]# make<br>make -C /home/ed/v4l-dvb/v4l <br>make[1]: Entering directory `/home/ed/v4l-dvb/v4l'<br>No version yet, using 2.6.25.11-97.fc9.i686<br>make[1]: Leaving directory `/home/ed/v4l-dvb/v4l'<br>make[1]: Entering directory `/home/ed/v4l-dvb/v4l'<br>scripts/make_makefile.pl<br>Updating/Creating .config<br>Preparing to compile for kernel version 2.6.25<br>File not found: /lib/modules/2.6.25.11-97.fc9.i686/build/.config at ./scripts/make_kconfig.pl line 32, &lt;IN&gt; line 4.<br>make[1]: Leaving directory `/home/ed/v4l-dvb/v4l'<br>make[1]: Entering directory
 `/home/ed/v4l-dvb/v4l'<br>Updating/Creating .config<br>Preparing to compile for kernel version 2.6.25<br>File not found: /lib/modules/2.6.25.11-97.fc9.i686/build/.config at ./scripts/make_kconfig.pl line 32, &lt;IN&gt; line 4.<br>make[1]: *** No rule to make target `.myconfig', needed by `config-compat.h'.&nbsp; Stop.<br>make[1]: Leaving directory `/home/ed/v4l-dvb/v4l'<br>make: *** [all] Error 2<br><br>I have searched around trying to find any answers but I found nothing.&nbsp; Any help would be greatly appreciated.<br>Thanks<br></div></div><br>

      </body></html>
--0-468723820-1217635192=:21214--


--===============0553664231==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0553664231==--
