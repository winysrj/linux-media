Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBBDufh2029440
	for <video4linux-list@redhat.com>; Thu, 11 Dec 2008 08:56:41 -0500
Received: from mail-fx0-f10.google.com (mail-fx0-f10.google.com
	[209.85.220.10])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBBDuP97030061
	for <video4linux-list@redhat.com>; Thu, 11 Dec 2008 08:56:25 -0500
Received: by fxm3 with SMTP id 3so373259fxm.3
	for <video4linux-list@redhat.com>; Thu, 11 Dec 2008 05:56:24 -0800 (PST)
Message-ID: <f271e9090812110556lc2173b4l6b96d7b139d8562f@mail.gmail.com>
Date: Thu, 11 Dec 2008 13:56:24 +0000
From: "Andy Piper" <andy.piper@gmail.com>
To: video4linux-list@redhat.com
In-Reply-To: <1229003184324-1643171.post@n2.nabble.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Disposition: inline
References: <491726CF.4050008@home.se>
	<da493cc0811110526k49afdebtf278c9255de4791d@mail.gmail.com>
	<491C8EE1.5050203@home.se> <1229003184324-1643171.post@n2.nabble.com>
Content-Transfer-Encoding: 8bit
Subject: Re: Failing to build em28xx-new
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

Hi again,

I decided to not be lazy and have a search at launchpad.net, and I
will now answer my own question: There is an existing bug submission
for this:

https://bugs.launchpad.net/ubuntu/+source/linux/+bug/286283

Cheers folks

-Andy


2008/12/11 apiper <andy.piper@gmail.com>:
>
> Hi folks,
>
> I just ran into this problem myself when compiling em28xx-new on Ubuntu
> 8.10, thanks for the fix!
>
> Did you ever file that bug report Andreas?
>
> Cheers
>
> -Andy
>
>
>
> Andreas Lunderhage wrote:
>>
>> Great!
>>
>> Now it was just a matter of make, make install, plugin the receiver and
>> start watching TV. Thanks!
>>
>> But I'm suprised those header files wheren't in the linux-headers
>> package in Ubuntu... Since not many dvb receivers are in the kernel,
>> those headers are needed in linux-headers. Maybe I should file a bug on
>> it...
>>
>> Regards
>> /Andreas
>>
>> Seláf Szabolcs wrote:
>>> Hi,
>>>
>>> I found same issue. To resolve put your kernel source into
>>> /lib/modules/`uname -r`/source directory or just create a link like me:
>>> ln -sf /lib/modules/2.6.26-1-amd64/source /usr/src/linux-source-2.6.26
>>>
>>> Regards,
>>> Selu
>>>
>>> On Sun, Nov 9, 2008 at 7:07 PM, Andreas Lunderhage
>>> <lunderhage@home.se>wrote:
>>>
>>>
>>>> Hi,
>>>>
>>>> I fail to build the em28xx-new driver due to missing files.
>>>>
>>>> dmxdev.h, dvb_demux.h, dvb_net.h and dvb_frontend.h.
>>>>
>>>> Where are these files? I have searched the whole repository of Ubuntu
>>>> 8.10 and only found them one time in a package that did seem to be too
>>>> old for use with this code.
>>>>
>>>> My question is: How do you build em28xx-new in Ubuntu 8.10?
>>>>
>>>> BR
>>>> /Lunderhage
>>>>
>>>> I attach the output of trying to build this module:
>>>>
>>>> lunderhage@Lunsectop:~/em28xx-new$ ./build.sh build
>>>> rm -rf Module.symvers;
>>>> make -C /lib/modules/`if [ -d /lib/modules/2.6.21.4-eeepc ]; then echo
>>>> 2.6.21.4-eeepc; else uname -r; fi`/build SUBDIRS=`pwd` modules
>>>> make[1]: Entering directory `/usr/src/linux-headers-2.6.27-7-generic'
>>>> CC [M] /home/lunderhage/em28xx-new/em2880-dvb.o
>>>> In file included from /home/lunderhage/em28xx-new/em2880-dvb.c:33:
>>>> /home/lunderhage/em28xx-new/em28xx.h:32:20: error: dmxdev.h: No such
>>>> file or directory
>>>> /home/lunderhage/em28xx-new/em28xx.h:33:23: error: dvb_demux.h: No such
>>>> file or directory
>>>> /home/lunderhage/em28xx-new/em28xx.h:34:21: error: dvb_net.h: No such
>>>> file or directory
>>>> /home/lunderhage/em28xx-new/em28xx.h:35:26: error: dvb_frontend.h: No
>>>> such file or directory
>>>> In file included from /home/lunderhage/em28xx-new/em2880-dvb.c:33:
>>>> /home/lunderhage/em28xx-new/em28xx.h:553: error: field 'demux' has
>>>> incomplete type
>>>> /home/lunderhage/em28xx-new/em28xx.h:561: error: field 'adapter' has
>>>> incomplete type
>>>> /home/lunderhage/em28xx-new/em28xx.h:564: error: field 'dmxdev' has
>>>> incomplete type
>>>> /home/lunderhage/em28xx-new/em28xx.h:566: error: field 'dvbnet' has
>>>> incomplete type
>>>> In file included from /home/lunderhage/em28xx-new/em2880-dvb.c:40:
>>>> /home/lunderhage/em28xx-new/mt352/mt352.h: In function 'mt352_write':
>>>> /home/lunderhage/em28xx-new/mt352/mt352.h:68: error: dereferencing
>>>> pointer to incomplete type
>>>> /home/lunderhage/em28xx-new/mt352/mt352.h:69: error: dereferencing
>>>> pointer to incomplete type
>>>> In file included from /home/lunderhage/em28xx-new/em2880-dvb.c:42:
>>>> /home/lunderhage/em28xx-new/drx3973d/drx3973d_demod.h: At top level:
>>>> /home/lunderhage/em28xx-new/drx3973d/drx3973d_demod.h:9: error: field
>>>> 'frontend' has incomplete type
>>>> /home/lunderhage/em28xx-new/em2880-dvb.c:48:22: error: lgdt330x.h: No
>>>> such file or directory
>>>> /home/lunderhage/em28xx-new/em2880-dvb.c: In function
>>>> 'em2880_complete_irq':
>>>> /home/lunderhage/em28xx-new/em2880-dvb.c:256: error: implicit
>>>> declaration of function 'dvb_dmx_swfilter'
>>>> /home/lunderhage/em28xx-new/em2880-dvb.c: At top level:
>>>> /home/lunderhage/em28xx-new/em2880-dvb.c:365: warning: 'struct
>>>> dvb_demux_feed' declared inside parameter list
>>>> /home/lunderhage/em28xx-new/em2880-dvb.c:365: warning: its scope is only
>>>> this definition or declaration, which is probably not what you want
>>>> /home/lunderhage/em28xx-new/em2880-dvb.c: In function
>>>> 'em2880_start_feed':
>>>> /home/lunderhage/em28xx-new/em2880-dvb.c:367: error: dereferencing
>>>> pointer to incomplete type
>>>> /home/lunderhage/em28xx-new/em2880-dvb.c:368: error: dereferencing
>>>> pointer to incomplete type
>>>> /home/lunderhage/em28xx-new/em2880-dvb.c: At top level:
>>>> /home/lunderhage/em28xx-new/em2880-dvb.c:382: warning: 'struct
>>>> dvb_demux_feed' declared inside parameter list
>>>> /home/lunderhage/em28xx-new/em2880-dvb.c: In function
>>>> 'em2880_stop_feed':
>>>> /home/lunderhage/em28xx-new/em2880-dvb.c:384: error: dereferencing
>>>> pointer to incomplete type
>>>> /home/lunderhage/em28xx-new/em2880-dvb.c:385: error: dereferencing
>>>> pointer to incomplete type
>>>> /home/lunderhage/em28xx-new/em2880-dvb.c: In function
>>>> 'em28xx_ts_bus_ctrl':
>>>> /home/lunderhage/em28xx-new/em2880-dvb.c:411: error: dereferencing
>>>> pointer to incomplete type
>>>> /home/lunderhage/em28xx-new/em2880-dvb.c: In function
>>>> 'mt352_pinnacle_init':
>>>> /home/lunderhage/em28xx-new/em2880-dvb.c:462: error: dereferencing
>>>> pointer to incomplete type
>>>> /home/lunderhage/em28xx-new/em2880-dvb.c: At top level:
>>>> /home/lunderhage/em28xx-new/em2880-dvb.c:488: error: variable
>>>> 'em2880_lgdt3303_dev' has initializer but incomplete type
>>>> /home/lunderhage/em28xx-new/em2880-dvb.c:489: error: unknown field
>>>> 'demod_address' specified in initializer
>>>> /home/lunderhage/em28xx-new/em2880-dvb.c:489: warning: excess elements
>>>> in struct initializer
>>>> /home/lunderhage/em28xx-new/em2880-dvb.c:489: warning: (near
>>>> initialization for 'em2880_lgdt3303_dev')
>>>> /home/lunderhage/em28xx-new/em2880-dvb.c:490: error: unknown field
>>>> 'demod_chip' specified in initializer
>>>> /home/lunderhage/em28xx-new/em2880-dvb.c:490: error: 'LGDT3303'
>>>> undeclared here (not in a function)
>>>> /home/lunderhage/em28xx-new/em2880-dvb.c:491: warning: excess elements
>>>> in struct initializer
>>>> /home/lunderhage/em28xx-new/em2880-dvb.c:491: warning: (near
>>>> initialization for 'em2880_lgdt3303_dev')
>>>> /home/lunderhage/em28xx-new/em2880-dvb.c: In function
>>>> 'kworld355u_i2c_gate_ctrl':
>>>> /home/lunderhage/em28xx-new/em2880-dvb.c:505: error: field 'frontend'
>>>> has incomplete type
>>>> /home/lunderhage/em28xx-new/em2880-dvb.c:511: error: dereferencing
>>>> pointer to incomplete type
>>>> /home/lunderhage/em28xx-new/em2880-dvb.c: In function
>>>> 'em28xx_set_params':
>>>> /home/lunderhage/em28xx-new/em2880-dvb.c:525: error: dereferencing
>>>> pointer to incomplete type
>>>> /home/lunderhage/em28xx-new/em2880-dvb.c:534: error: dereferencing
>>>> pointer to incomplete type
>>>> /home/lunderhage/em28xx-new/em2880-dvb.c: In function
>>>> 'em28xx_get_frequency':
>>>> /home/lunderhage/em28xx-new/em2880-dvb.c:652: error: dereferencing
>>>> pointer to incomplete type
>>>> /home/lunderhage/em28xx-new/em2880-dvb.c: In function
>>>> 'em28xx_get_bandwidth':
>>>> /home/lunderhage/em28xx-new/em2880-dvb.c:659: error: dereferencing
>>>> pointer to incomplete type
>>>> /home/lunderhage/em28xx-new/em2880-dvb.c: In function 'em28xx_dvb_init':
>>>> /home/lunderhage/em28xx-new/em2880-dvb.c:667: error: dereferencing
>>>> pointer to incomplete type
>>>> /home/lunderhage/em28xx-new/em2880-dvb.c: In function
>>>> 'em28xx_s921_init':
>>>> /home/lunderhage/em28xx-new/em2880-dvb.c:723: error: dereferencing
>>>> pointer to incomplete type
>>>> /home/lunderhage/em28xx-new/em2880-dvb.c: In function
>>>> 'em28xx_zl10353_init':
>>>> /home/lunderhage/em28xx-new/em2880-dvb.c:740: error: dereferencing
>>>> pointer to incomplete type
>>>> /home/lunderhage/em28xx-new/em2880-dvb.c: In function
>>>> 'em28xx_zl10353_sleep':
>>>> /home/lunderhage/em28xx-new/em2880-dvb.c:785: error: dereferencing
>>>> pointer to incomplete type
>>>> /home/lunderhage/em28xx-new/em2880-dvb.c: In function
>>>> 'em28xx_dvb_sleep':
>>>> /home/lunderhage/em28xx-new/em2880-dvb.c:797: error: dereferencing
>>>> pointer to incomplete type
>>>> /home/lunderhage/em28xx-new/em2880-dvb.c: In function 'em2880_dvb_init':
>>>> /home/lunderhage/em28xx-new/em2880-dvb.c:866: error: implicit
>>>> declaration of function 'dvb_attach'
>>>> /home/lunderhage/em28xx-new/em2880-dvb.c:870: warning: assignment makes
>>>> pointer from integer without a cast
>>>> /home/lunderhage/em28xx-new/em2880-dvb.c:889: warning: assignment makes
>>>> pointer from integer without a cast
>>>> /home/lunderhage/em28xx-new/em2880-dvb.c:892: warning: assignment makes
>>>> pointer from integer without a cast
>>>> /home/lunderhage/em28xx-new/em2880-dvb.c:897: warning: assignment makes
>>>> pointer from integer without a cast
>>>> /home/lunderhage/em28xx-new/em2880-dvb.c:903: error: 'lgdt330x_attach'
>>>> undeclared (first use in this function)
>>>> /home/lunderhage/em28xx-new/em2880-dvb.c:903: error: (Each undeclared
>>>> identifier is reported only once
>>>> /home/lunderhage/em28xx-new/em2880-dvb.c:903: error: for each function
>>>> it appears in.)
>>>> /home/lunderhage/em28xx-new/em2880-dvb.c:904: warning: assignment makes
>>>> pointer from integer without a cast
>>>> /home/lunderhage/em28xx-new/em2880-dvb.c:913: warning: assignment makes
>>>> pointer from integer without a cast
>>>> /home/lunderhage/em28xx-new/em2880-dvb.c:918: warning: assignment makes
>>>> pointer from integer without a cast
>>>> /home/lunderhage/em28xx-new/em2880-dvb.c:924: warning: assignment makes
>>>> pointer from integer without a cast
>>>> /home/lunderhage/em28xx-new/em2880-dvb.c:927: error: dereferencing
>>>> pointer to incomplete type
>>>> /home/lunderhage/em28xx-new/em2880-dvb.c:928: error: dereferencing
>>>> pointer to incomplete type
>>>> /home/lunderhage/em28xx-new/em2880-dvb.c:929: error: dereferencing
>>>> pointer to incomplete type
>>>> /home/lunderhage/em28xx-new/em2880-dvb.c:950: error: dereferencing
>>>> pointer to incomplete type
>>>> /home/lunderhage/em28xx-new/em2880-dvb.c:951: error: dereferencing
>>>> pointer to incomplete type
>>>> /home/lunderhage/em28xx-new/em2880-dvb.c:953: error: dereferencing
>>>> pointer to incomplete type
>>>> /home/lunderhage/em28xx-new/em2880-dvb.c:955: error: dereferencing
>>>> pointer to incomplete type
>>>> /home/lunderhage/em28xx-new/em2880-dvb.c:959: error: dereferencing
>>>> pointer to incomplete type
>>>> /home/lunderhage/em28xx-new/em2880-dvb.c:961: error: dereferencing
>>>> pointer to incomplete type
>>>> /home/lunderhage/em28xx-new/em2880-dvb.c:970: error: dereferencing
>>>> pointer to incomplete type
>>>> /home/lunderhage/em28xx-new/em2880-dvb.c:984: error: dereferencing
>>>> pointer to incomplete type
>>>> /home/lunderhage/em28xx-new/em2880-dvb.c:986: error: dereferencing
>>>> pointer to incomplete type
>>>> /home/lunderhage/em28xx-new/em2880-dvb.c:987: error: dereferencing
>>>> pointer to incomplete type
>>>> /home/lunderhage/em28xx-new/em2880-dvb.c:1005: error: dereferencing
>>>> pointer to incomplete type
>>>> /home/lunderhage/em28xx-new/em2880-dvb.c:1008: error: implicit
>>>> declaration of function 'dvb_register_adapter'
>>>> /home/lunderhage/em28xx-new/em2880-dvb.c:1026: error: implicit
>>>> declaration of function 'dvb_register_frontend'
>>>> /home/lunderhage/em28xx-new/em2880-dvb.c:1033: error: 'DMX_TS_FILTERING'
>>>> undeclared (first use in this function)
>>>> /home/lunderhage/em28xx-new/em2880-dvb.c:1034: error:
>>>> 'DMX_SECTION_FILTERING' undeclared (first use in this function)
>>>> /home/lunderhage/em28xx-new/em2880-dvb.c:1035: error:
>>>> 'DMX_MEMORY_BASED_FILTERING' undeclared (first use in this function)
>>>> /home/lunderhage/em28xx-new/em2880-dvb.c:1037: error: implicit
>>>> declaration of function 'dvb_dmx_init'
>>>> /home/lunderhage/em28xx-new/em2880-dvb.c:1048: error: implicit
>>>> declaration of function 'dvb_dmxdev_init'
>>>> /home/lunderhage/em28xx-new/em2880-dvb.c:1052: error: implicit
>>>> declaration of function 'dvb_dmxdev_release'
>>>> /home/lunderhage/em28xx-new/em2880-dvb.c:1063: error: implicit
>>>> declaration of function 'dvb_net_init'
>>>> /home/lunderhage/em28xx-new/em2880-dvb.c:1063: error: dereferencing
>>>> pointer to incomplete type
>>>> /home/lunderhage/em28xx-new/em2880-dvb.c: In function 'em2880_dvb_fini':
>>>> /home/lunderhage/em28xx-new/em2880-dvb.c:1083: error: implicit
>>>> declaration of function 'dvb_net_release'
>>>> /home/lunderhage/em28xx-new/em2880-dvb.c:1084: error: implicit
>>>> declaration of function 'dvb_unregister_frontend'
>>>> /home/lunderhage/em28xx-new/em2880-dvb.c:1085: error: implicit
>>>> declaration of function 'dvb_frontend_detach'
>>>> /home/lunderhage/em28xx-new/em2880-dvb.c:1089: error: implicit
>>>> declaration of function 'dvb_dmx_release'
>>>> /home/lunderhage/em28xx-new/em2880-dvb.c:1091: error: implicit
>>>> declaration of function 'dvb_unregister_adapter'
>>>> make[2]: *** [/home/lunderhage/em28xx-new/em2880-dvb.o] Error 1
>>>> make[1]: *** [_module_/home/lunderhage/em28xx-new] Error 2
>>>> make[1]: Leaving directory `/usr/src/linux-headers-2.6.27-7-generic'
>>
>>>> make: *** [default] Error 2
>>>> lunderhage@Lunsectop:~/em28xx-new$
>>>>
>>>> --
>>>> video4linux-list mailing list
>>>> Unsubscribe
>>>> mailto:video4linux-list-request@redhat.com?subject=unsubscribe
>>>> https://www.redhat.com/mailman/listinfo/video4linux-list
>>>>
>>>>
>>>
>>>
>>>
>>>
>>
>> --
>> video4linux-list mailing list
>> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
>> https://www.redhat.com/mailman/listinfo/video4linux-list
>>
>>
>
> --
> View this message in context: http://n2.nabble.com/Failing-to-build-em28xx-new-tp1478019p1643171.html
> Sent from the video4linux-list mailing list archive at Nabble.com.
>
>
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
>

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
