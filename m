Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1CF6t6N024972
	for <video4linux-list@redhat.com>; Tue, 12 Feb 2008 10:06:55 -0500
Received: from smtp106.rog.mail.re2.yahoo.com (smtp106.rog.mail.re2.yahoo.com
	[68.142.225.204])
	by mx3.redhat.com (8.13.1/8.13.1) with SMTP id m1CF6MTM009513
	for <video4linux-list@redhat.com>; Tue, 12 Feb 2008 10:06:23 -0500
Message-ID: <47B1B5E2.6050700@rogers.com>
Date: Tue, 12 Feb 2008 10:06:10 -0500
From: CityK <CityK@rogers.com>
MIME-Version: 1.0
To: Muppet Man <muppetman4662@yahoo.com>
References: <653934.59125.qm@web34401.mail.mud.yahoo.com>
In-Reply-To: <653934.59125.qm@web34401.mail.mud.yahoo.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: Trouble compiling driver in PClinuxOS
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Muppet Man wrote:
> Greetings all,
> I am having trouble compiling the latest v4l-dvb in order to get my pinnicale pci card to work.  I am running PClinuxOS 2007.  I have downloaded the latest tree, mkdir v4l-dvb extracted the tz file to that folder, went into root mode and got this error when I make the file
>
> make -C /home/ed/v4l-dvb/v4l
> make[1]: Entering directory `/home/ed/v4l-dvb/v4l'
> creating symbolic links...
> Kernel build directory is /lib/modules/2.6.18.8.tex5/build
> make -C /lib/modules/2.6.18.8.tex5/build SUBDIRS=/home/ed/v4l-dvb/v4l  modules
> make[2]: Entering directory `/usr/src/linux-2.6.18.8.tex5'
>   CC [M]  /home/ed/v4l-dvb/v4l/videodev.o
> /home/ed/v4l-dvb/v4l/videodev.c:491: error: unknown field 'dev_attrs' specified in initializer
> /home/ed/v4l-dvb/v4l/videodev.c:491: warning: initialization from incompatible pointer type
> /home/ed/v4l-dvb/v4l/videodev.c:492: error: unknown field 'dev_release' specified in initializer
> /home/ed/v4l-dvb/v4l/videodev.c:492: warning: missing braces around initializer
> /home/ed/v4l-dvb/v4l/videodev.c:492: warning: (near initialization for 'video_class.subsys')
> /home/ed/v4l-dvb/v4l/videodev.c:492: warning: initialization from incompatible pointer type
> make[3]: *** [/home/ed/v4l-dvb/v4l/videodev.o] Error 1
> make[2]: *** [_module_/home/ed/v4l-dvb/v4l] Error 2
> make[2]: Leaving directory `/usr/src/linux-2.6.18.8.tex5'
> make[1]: *** [default] Error 2
> make[1]: Leaving directory `/home/ed/v4l-dvb/v4l'
>
> I know this driver works because I had it running under ubuntu, but I heard so much about PClinuxOS that I thought I would give it a shot.
>
> Any help would be greatly appreciated.

See: 
http://www.linuxtv.org/wiki/index.php/How_to_install_DVB_device_drivers#Case_2:_Installation_of_LinuxTV_Drivers_Required

Also note that, as shown in the instructions, you should be building as 
"user" (denoted by the $ .... i.e. "$ make" ), then install as "root" 
(which, in the instructions, is achieved through "sudo make install" 
...... if the instructions called for being the root user all along, 
then the cli prompt would be denoted by a #, and there would, of course, 
be no need for the use of a "sudo" .... sudo allows one to invoke the 
superuser's privileges in respect to performing some command i.e. "sudo 
command".

In any regard, building as root user will generally work, BUT you are 
exposing yourself to the risk/potential of introducing system changes 
that could very easily vary from being entirely benign to entirely 
destabilizing ... [dirty harry mode] being that this is root, the most 
powerful user in the Linux world, and will blow your installation clean 
off, you gotta ask yourself a question --- do I feel lucky? .... Well do 
you punk?[/dirty harry mode]

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
