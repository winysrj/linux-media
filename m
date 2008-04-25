Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wa-out-1112.google.com ([209.85.146.178])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <emaildericky@gmail.com>) id 1JpW9e-0005o5-Lt
	for linux-dvb@linuxtv.org; Sat, 26 Apr 2008 00:12:36 +0200
Received: by wa-out-1112.google.com with SMTP id m28so5817660wag.13
	for <linux-dvb@linuxtv.org>; Fri, 25 Apr 2008 15:12:25 -0700 (PDT)
Message-ID: <3271f22e0804251512s411a3a0bgaf4548422cc6e22f@mail.gmail.com>
Date: Sat, 26 Apr 2008 00:12:25 +0200
From: "Ricardo Carrillo Cruz" <emaildericky@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] TM6000 compilation error
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

Hi guys

I've purchased a WinTV HVR 900H, apparently it uses a TM6000 chipset.
I've followed the steps described at
http://www.linuxtv.org/v4lwiki/index.php/Trident_TM6000#TM6000_based_Devices
but I'm getting these errors:

dormammu@dormammu-laptop:~/v4l-dvb$ make
make -C /home/dormammu/v4l-dvb/v4l
make[1]: Entering directory `/home/dormammu/v4l-dvb/v4l'
creating symbolic links...
Kernel build directory is /lib/modules/2.6.22-14-386/build
make -C /lib/modules/2.6.22-14-386/build
SUBDIRS=/home/dormammu/v4l-dvb/v4l  modules
make[2]: Entering directory `/usr/src/linux-headers-2.6.22-14-386'
  CC [M]  /home/dormammu/v4l-dvb/v4l/tm6000.o
/home/dormammu/v4l-dvb/v4l/tm6000.c: In function 'tm6000_poll_remote':
/home/dormammu/v4l-dvb/v4l/tm6000.c:293: warning: passing argument 1
of 'schedule_delayed_work' from incompatible pointer type
/home/dormammu/v4l-dvb/v4l/tm6000.c: In function 'tm6000_start_stream':
/home/dormammu/v4l-dvb/v4l/tm6000.c:297: warning: unused variable 'errCode'
/home/dormammu/v4l-dvb/v4l/tm6000.c:297: warning: unused variable 'i'
/home/dormammu/v4l-dvb/v4l/tm6000.c: In function 'tm6000_zl10353_i2c_xfer':
/home/dormammu/v4l-dvb/v4l/tm6000.c:421: warning: unused variable 'k'
/home/dormammu/v4l-dvb/v4l/tm6000.c: In function 'tm6000_xc3028_i2c_xfer':
/home/dormammu/v4l-dvb/v4l/tm6000.c:504: warning: unused variable 'k'
/home/dormammu/v4l-dvb/v4l/tm6000.c: In function 'tm6000_zl10353_pll':
/home/dormammu/v4l-dvb/v4l/tm6000.c:644: warning: unused variable 'i'
/home/dormammu/v4l-dvb/v4l/tm6000.c: In function 'zl10353_read_status':
/home/dormammu/v4l-dvb/v4l/tm6000.c:1272: warning: unused variable 's8'
/home/dormammu/v4l-dvb/v4l/tm6000.c:1272: warning: unused variable 's7'
/home/dormammu/v4l-dvb/v4l/tm6000.c:1272: warning: unused variable 's6'
/home/dormammu/v4l-dvb/v4l/tm6000.c: In function 'tm6000_read_signal_strength':
/home/dormammu/v4l-dvb/v4l/tm6000.c:1304: warning: unused variable 'state'
/home/dormammu/v4l-dvb/v4l/tm6000.c: In function 'tm6000_read_snr':
/home/dormammu/v4l-dvb/v4l/tm6000.c:1313: warning: unused variable 'state'
/home/dormammu/v4l-dvb/v4l/tm6000.c: In function 'probe':
/home/dormammu/v4l-dvb/v4l/tm6000.c:2005: error: too few arguments to
function 'dvb_register_adapter'
/home/dormammu/v4l-dvb/v4l/tm6000.c:2059: warning: label 'err' defined
but not used
make[3]: *** [/home/dormammu/v4l-dvb/v4l/tm6000.o] Error 1
make[2]: *** [_module_/home/dormammu/v4l-dvb/v4l] Error 2
make[2]: Leaving directory `/usr/src/linux-headers-2.6.22-14-386'
make[1]: *** [default] Error 2
make[1]: Leaving directory `/home/dormammu/v4l-dvb/v4l'
make: *** [all] Error 2
dormammu@dormammu-laptop:~/v4l-dvb$

Any ideas?

Regards

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
