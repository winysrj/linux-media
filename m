Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9OJ7g8B019203
	for <video4linux-list@redhat.com>; Fri, 24 Oct 2008 15:07:42 -0400
Received: from smtp1-g19.free.fr (smtp1-g19.free.fr [212.27.42.27])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9OJ7U5W000841
	for <video4linux-list@redhat.com>; Fri, 24 Oct 2008 15:07:30 -0400
Message-ID: <49021D07.802@free.fr>
Date: Fri, 24 Oct 2008 21:07:51 +0200
From: Thierry Merle <thierry.merle@free.fr>
MIME-Version: 1.0
To: Thomas Kaiser <linux-dvb@kaiser-linux.li>
References: <4900DA6B.4050902@kaiser-linux.li> <4900EDA7.6070000@free.fr>
	<4901010C.1020708@kaiser-linux.li>
In-Reply-To: <4901010C.1020708@kaiser-linux.li>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Cc: Video 4 Linux <video4linux-list@redhat.com>
Subject: Re: gspca, what do I am wrong?
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

Thomas Kaiser a écrit :
> Thierry Merle wrote:
>> Hi Thomas,
>>
>> Thomas Kaiser a écrit :
>>> Hey
>>>
>>> I think this mail came not through, so I send it again. Sorry, when it
>>> comes twice.
>>>
>>> I just pasted the interesting things into this email (With some comments
>>> inline). Hope somebody can help:
>>>
>>> thomas@LAPI01:~$ lsb_release -a
>>> No LSB modules are available.
>>> Distributor ID:    Ubuntu
>>> Description:    Ubuntu 8.04.1
>>> Release:    8.04
>>> Codename:    hardy
>>>
>>> thomas@LAPI01:~$ uname -a
>>> Linux LAPI01 2.6.24-21-generic #1 SMP Mon Aug 25 17:32:09 UTC 2008 i686
>>> GNU/Linux
>>>
>>> thomas@LAPI01:~/Projects/webcams$ hg clone http://linuxtv.org/hg/v4l-dvb
>>> to get the newest v4l source.
>>>
>>> make menuconfig in ~/Projects/webcams/v4l-dvb and remove all stuff
>>> except the gspca and V4l2.
>>> After this, I did not find a .config file in the
>>> ~/Projects/webcams/v4l-dvb folder. Where is the .config stored?
>> ~/Projects/webcams/v4l-dvb/v4l/.config
> 
> OK, I found it, thanks.
> 
>>
>>> Several dvb and/or analog capture driver where made. Why?, I disabled!
>>>
>> Look at the .config, perhaps you forgot to disable some additional
>> modules
> 
> When I did "make menuconfig" I only choose the v4l2 and gspca modules.
> But looking in .config in ...../v4l/ there are still some more modules
> enabled. I can manually remove them from the .config file, but that
> should not be the way to go, or I am mistaken?
> 
Well, if you disable all options, you will see that no module are compiled.
If you enable just 1 gspca webcam or whatever module, some modules like tuners are compiled by default.
Some options need to be checked in order to able to remove some modules.
For example the option "Customize analog and hybrid tuner modules to build" must be checked to see the list of tuners, and to allow you to disable them one by one.

>>> thomas@LAPI01:~/Projects/webcams/v4l-dvb$ make
>>> ¨make -C /home/thomas/Projects/webcams/v4l-dvb/v4l
>>> make[1]: Entering directory `/home/thomas/Projects/webcams/v4l-dvb/v4l'
>>> creating symbolic links...
>>> Kernel build directory is /lib/modules/2.6.24-21-generic/build
>>> make -C /lib/modules/2.6.24-21-generic/build
>>> SUBDIRS=/home/thomas/Projects/webcams/v4l-dvb/v4l  modules
>> [SNIP]
>>> After plugging the cam in the kernel log:
>>>
>>> Oct 23 20:52:54 LAPI01 kernel: [ 2015.905111] usb 1-1: new full speed
>>> USB device using uhci_hcd and address 5
>>> Oct 23 20:52:54 LAPI01 kernel: [ 2016.075400] usb 1-1: configuration #1
>>> chosen from 1 choice
>>> Oct 23 20:52:54 LAPI01 kernel: [ 2016.078879] usb 1-1: ZC0301[P] Image
>>> Processor and Control Chip detected (vid/pid 0x041E:0x401C)
>>> Oct 23 20:52:55 LAPI01 kernel: [ 2016.164172] usb 1-1: No supported
>>> image sensor detected
>>> Oct 23 20:52:55 LAPI01 kernel: [ 2016.194043] gspca_main: disagrees
>>> about version of symbol video_ioctl2
>> Please try make rmmod before plugging-in your device and check that no
>> v4l-dvb module is loaded.
>> This will remove any old v4l-dvb module already present.
> 
> I did several "sudo modprobe -r gspca-...." and check afterward that no
> gspca module is loaded anymore (lsmod |grep gspca).
> 
Well, the problem is the kernel version taken from the build script is different from the running kernel.
It is a very common problem on debian/ubuntu distributions that add some extra version information in kernel version but not in /usr/src/linux/Makefile
There may be a clean method to build modules with these distributions, you might look for that on corresponding ML.
To see the problem, do a modinfo gspca and a modinfo video_ioctl2 or a modinfo videodev and compare the vermagic.
Hope that this will help you in finding the solution.

Thierry

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
