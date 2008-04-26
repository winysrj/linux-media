Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail1.radix.net ([207.192.128.31])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <awalls@radix.net>) id 1JpZ3O-0000za-0s
	for linux-dvb@linuxtv.org; Sat, 26 Apr 2008 03:18:15 +0200
From: Andy Walls <awalls@radix.net>
To: Ricardo Carrillo Cruz <emaildericky@gmail.com>
In-Reply-To: <3271f22e0804251512s411a3a0bgaf4548422cc6e22f@mail.gmail.com>
References: <3271f22e0804251512s411a3a0bgaf4548422cc6e22f@mail.gmail.com>
Date: Fri, 25 Apr 2008 21:17:13 -0400
Message-Id: <1209172633.3207.22.camel@palomino.walls.org>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] TM6000 compilation error
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

On Sat, 2008-04-26 at 00:12 +0200, Ricardo Carrillo Cruz wrote:
> Hi guys
> 
> I've purchased a WinTV HVR 900H, apparently it uses a TM6000 chipset.
> I've followed the steps described at
> http://www.linuxtv.org/v4lwiki/index.php/Trident_TM6000#TM6000_based_Devices
> but I'm getting these errors:
> 

The driver tar archive at 

http://colabti.org/tm6000/tm6000.tar.gz

has a date of 30 Aug 2007.  It may be a little outdated compared to the
latest v4l-dvb trees pulled from hg.



> dormammu@dormammu-laptop:~/v4l-dvb$ make
> make -C /home/dormammu/v4l-dvb/v4l
> make[1]: Entering directory `/home/dormammu/v4l-dvb/v4l'
> creating symbolic links...
> Kernel build directory is /lib/modules/2.6.22-14-386/build
> make -C /lib/modules/2.6.22-14-386/build
> SUBDIRS=/home/dormammu/v4l-dvb/v4l  modules
> make[2]: Entering directory `/usr/src/linux-headers-2.6.22-14-386'
>   CC [M]  /home/dormammu/v4l-dvb/v4l/tm6000.o
> /home/dormammu/v4l-dvb/v4l/tm6000.c: In function 'tm6000_poll_remote':
> /home/dormammu/v4l-dvb/v4l/tm6000.c:293: warning: passing argument 1
> of 'schedule_delayed_work' from incompatible pointer type

In include/linux/workqueue.h, the prototype for schedule_delayed_work()
has it's first argument as 

	struct delayed_work *

but the driver code on line 293 is passing a variable of type 

	struct work_struct *

These two types in include/linux/workqueue.h are different.  You will
stomp on the transfer_buffer pointer (line 151 of the driver source) if
you do not fix it.

You can probably get away with changing the type of the
"remote_work_struct" variable on line 150 of the file to resolve this
error.


> /home/dormammu/v4l-dvb/v4l/tm6000.c: In function 'tm6000_start_stream':
> /home/dormammu/v4l-dvb/v4l/tm6000.c:297: warning: unused variable 'errCode'
> /home/dormammu/v4l-dvb/v4l/tm6000.c:297: warning: unused variable 'i'

You can safely ignore all unused variable warnings.

> /home/dormammu/v4l-dvb/v4l/tm6000.c: In function 'tm6000_zl10353_i2c_xfer':
> /home/dormammu/v4l-dvb/v4l/tm6000.c:421: warning: unused variable 'k'
> /home/dormammu/v4l-dvb/v4l/tm6000.c: In function 'tm6000_xc3028_i2c_xfer':
> /home/dormammu/v4l-dvb/v4l/tm6000.c:504: warning: unused variable 'k'
> /home/dormammu/v4l-dvb/v4l/tm6000.c: In function 'tm6000_zl10353_pll':
> /home/dormammu/v4l-dvb/v4l/tm6000.c:644: warning: unused variable 'i'
> /home/dormammu/v4l-dvb/v4l/tm6000.c: In function 'zl10353_read_status':
> /home/dormammu/v4l-dvb/v4l/tm6000.c:1272: warning: unused variable 's8'
> /home/dormammu/v4l-dvb/v4l/tm6000.c:1272: warning: unused variable 's7'
> /home/dormammu/v4l-dvb/v4l/tm6000.c:1272: warning: unused variable 's6'
> /home/dormammu/v4l-dvb/v4l/tm6000.c: In function 'tm6000_read_signal_strength':
> /home/dormammu/v4l-dvb/v4l/tm6000.c:1304: warning: unused variable 'state'
> /home/dormammu/v4l-dvb/v4l/tm6000.c: In function 'tm6000_read_snr':
> /home/dormammu/v4l-dvb/v4l/tm6000.c:1313: warning: unused variable 'state'
> /home/dormammu/v4l-dvb/v4l/tm6000.c: In function 'probe':
> /home/dormammu/v4l-dvb/v4l/tm6000.c:2005: error: too few arguments to
> function 'dvb_register_adapter'

In the newer v4l-dvb trees, dvb_register_adapter() takes an additional
final argument: an array of "adapter numbers".

Somewhere early in the driver source file, but after the includes,
declare:

DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nums);


Then change the call on line 2006 from:

ret = dvb_register_adapter (&tm6000_dev->dvb_adapter, "Trident TVMaster 6000 DVB-T", THIS_MODULE, &dev->dev);

to

ret = dvb_register_adapter (&tm6000_dev->dvb_adapter, "Trident TVMaster 6000 DVB-T", THIS_MODULE, &dev->dev, adapter_nums);

See linux/drivers/media/dvb/dvb-core/dvbdev.[ch] for the details.

> /home/dormammu/v4l-dvb/v4l/tm6000.c:2059: warning: label 'err' defined
> but not used

You can probably ignore unused label warnings.

> make[3]: *** [/home/dormammu/v4l-dvb/v4l/tm6000.o] Error 1
> make[2]: *** [_module_/home/dormammu/v4l-dvb/v4l] Error 2
> make[2]: Leaving directory `/usr/src/linux-headers-2.6.22-14-386'
> make[1]: *** [default] Error 2
> make[1]: Leaving directory `/home/dormammu/v4l-dvb/v4l'
> make: *** [all] Error 2
> dormammu@dormammu-laptop:~/v4l-dvb$
> 
> Any ideas?

Once you fix those errors, more will pop-up, and then you'll have to fix
those.

You could politely ask the maintainer to see if he can update the driver
for you, if you don't feel comfortable fixing things yourself.

Regards,
Andy

> Regards
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
