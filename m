Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smeagol.cambrium.nl ([217.19.16.145] ident=qmailr)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jelledejong@powercraft.nl>) id 1JUrH1-0001d1-3Z
	for linux-dvb@linuxtv.org; Thu, 28 Feb 2008 23:30:43 +0100
Message-ID: <47C7360E.9030908@powercraft.nl>
Date: Thu, 28 Feb 2008 23:30:38 +0100
From: Jelle de Jong <jelledejong@powercraft.nl>
MIME-Version: 1.0
To: Markus Rechberger <mrechberger@gmail.com>
References: <47C7329F.7030705@powercraft.nl>	
	<d9def9db0802281421v698df05eq52a1978c69d80df2@mail.gmail.com>	
	<47C73457.1030901@powercraft.nl>
	<d9def9db0802281425i5b487f43ub90b263a63e40a01@mail.gmail.com>
In-Reply-To: <d9def9db0802281425i5b487f43ub90b263a63e40a01@mail.gmail.com>
Content-Type: multipart/mixed; boundary="------------070209030904060600010202"
Cc: linux-dvb <linux-dvb@linuxtv.org>, em28xx@mcentral.de
Subject: Re: [linux-dvb] Going though hell here,
 please provide how to for Pinnacle PCTV Hybrid Pro Stick 330e
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--------------070209030904060600010202
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Markus Rechberger wrote:
> On 2/28/08, Jelle de Jong <jelledejong@powercraft.nl> wrote:
>> Markus Rechberger wrote:
>>> On 2/28/08, Jelle de Jong <jelledejong@powercraft.nl> wrote:
>>>> This message contains the following attachment(s):
>>>> Pinnacle PCTV Hybrid Pro Stick 330e.txt
>>>>
>>>> Spent my hole day trying to get a dvd-t device up and running, this is
>>>> device number two I tried.
>>>>
>>>> Can somebody please tell me how to get this device working on:
>>>>
>>>> 2.6.24-1-686 debian sid and 2.6.22-14-generic ubuntu
>>>>
>>>> I have to get some sleep now, because this is getting on my health and
>>>> that does not happen often....
>>>>
>>> Jelle, it's really easy to install it actually.
>>> http://www.mail-archive.com/em28xx%40mcentral.de/msg00750.html
>>>
>>> this is the correct "howto" for it.
>>>
>>> You need the linux kernel sources for your kernel, if you experience
>>> any problems just post them to the em28xx ML.
>>>
>>> Markus
>> Hi Markus,
>>
>> I tried that two times,
>>
>> The seconds build blows up in my face, I need specified dependecies to
>> be able to compile the seconds driver...
>>
> 
> there are not so many dependencies, just submit the errors you get.
> 
> Markus

Here you go, lets see I will try it for 40 more minutes with your help

Kind regards,

Jelle

--------------070209030904060600010202
Content-Type: text/plain;
 name="error-log.txt"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline;
 filename="error-log.txt"

jelle@xubutu-en12000e:~$ hg clone http://mcentral.de/hg/~mrec/em28xx-userspace2
destination directory: em28xx-userspace2
requesting all changes
adding changesets
adding manifests
adding file changes
added 21 changesets with 65 changes to 20 files
18 files updated, 0 files merged, 0 files removed, 0 files unresolved
jelle@xubutu-en12000e:~$ cd em28xx-userspace2
jelle@xubutu-en12000e:~/em28xx-userspace2$ sudo ./build.sh
if [ -f ../userspace-drivers/kernel/Module.symvers ]; then \
        grep v4l_dvb_stub_attach ../userspace-drivers/kernel/Module.symvers > Module.symvers; \
        fi
make -C /lib/modules/2.6.22-14-generic/build SUBDIRS=/home/jelle/em28xx-userspace2 modules
make[1]: Entering directory `/usr/src/linux-headers-2.6.22-14-generic'
  CC [M]  /home/jelle/em28xx-userspace2/em2880-dvb.o
In file included from /home/jelle/em28xx-userspace2/em2880-dvb.c:33:
/home/jelle/em28xx-userspace2/em28xx.h:33:20: error: dmxdev.h: No such file or directory
/home/jelle/em28xx-userspace2/em28xx.h:34:23: error: dvb_demux.h: No such file or directory
/home/jelle/em28xx-userspace2/em28xx.h:35:21: error: dvb_net.h: No such file or directory
/home/jelle/em28xx-userspace2/em28xx.h:36:26: error: dvb_frontend.h: No such file or directory
In file included from /home/jelle/em28xx-userspace2/em28xx.h:45,
                 from /home/jelle/em28xx-userspace2/em2880-dvb.c:33:
/home/jelle/em28xx-userspace2/em28xx-compat.h:4: warning: ‘struct dvb_frontend’ declared inside parameter list
/home/jelle/em28xx-userspace2/em28xx-compat.h:4: warning: its scope is only this definition or declaration, which is probably not what you want
In file included from /home/jelle/em28xx-userspace2/em28xx.h:46,
                 from /home/jelle/em28xx-userspace2/em2880-dvb.c:33:
include/linux/media-stub.h:362: error: field ‘frontend’ has incomplete type
In file included from /home/jelle/em28xx-userspace2/em2880-dvb.c:33:
/home/jelle/em28xx-userspace2/em28xx.h:397: error: field ‘demux’ has incomplete type
/home/jelle/em28xx-userspace2/em28xx.h:405: error: field ‘adapter’ has incomplete type
/home/jelle/em28xx-userspace2/em28xx.h:408: error: field ‘dmxdev’ has incomplete type
/home/jelle/em28xx-userspace2/em28xx.h:410: error: field ‘dvbnet’ has incomplete type
/home/jelle/em28xx-userspace2/em2880-dvb.c:41:21: error: zl10353.h: No such file or directory
/home/jelle/em28xx-userspace2/em2880-dvb.c:46:19: error: mt352.h: No such file or directory
/home/jelle/em28xx-userspace2/em2880-dvb.c:47:22: error: lgdt330x.h: No such file or directory
/home/jelle/em28xx-userspace2/em2880-dvb.c:48:20: error: mt2060.h: No such file or directory
/home/jelle/em28xx-userspace2/em2880-dvb.c: In function ‘em2880_complete_irq’:
/home/jelle/em28xx-userspace2/em2880-dvb.c:101: warning: implicit declaration of function ‘dvb_dmx_swfilter’
/home/jelle/em28xx-userspace2/em2880-dvb.c: At top level:
/home/jelle/em28xx-userspace2/em2880-dvb.c:197: warning: ‘struct dvb_demux_feed’ declared inside parameter list
/home/jelle/em28xx-userspace2/em2880-dvb.c: In function ‘em2880_start_feed’:
/home/jelle/em28xx-userspace2/em2880-dvb.c:199: error: dereferencing pointer to incomplete type
/home/jelle/em28xx-userspace2/em2880-dvb.c:200: error: dereferencing pointer to incomplete type
/home/jelle/em28xx-userspace2/em2880-dvb.c: At top level:
/home/jelle/em28xx-userspace2/em2880-dvb.c:214: warning: ‘struct dvb_demux_feed’ declared inside parameter list
/home/jelle/em28xx-userspace2/em2880-dvb.c: In function ‘em2880_stop_feed’:
/home/jelle/em28xx-userspace2/em2880-dvb.c:216: error: dereferencing pointer to incomplete type
/home/jelle/em28xx-userspace2/em2880-dvb.c:217: error: dereferencing pointer to incomplete type
/home/jelle/em28xx-userspace2/em2880-dvb.c: In function ‘em2880_zl10353_init’:
/home/jelle/em28xx-userspace2/em2880-dvb.c:266: error: dereferencing pointer to incomplete type
/home/jelle/em28xx-userspace2/em2880-dvb.c: In function ‘em2880_zl103530_pinnacle_init’:
/home/jelle/em28xx-userspace2/em2880-dvb.c:333: error: dereferencing pointer to incomplete type
/home/jelle/em28xx-userspace2/em2880-dvb.c: In function ‘em2880_mt352_init’:
/home/jelle/em28xx-userspace2/em2880-dvb.c:375: error: dereferencing pointer to incomplete type
/home/jelle/em28xx-userspace2/em2880-dvb.c: At top level:
/home/jelle/em28xx-userspace2/em2880-dvb.c:383: error: variable ‘em2880_zl10353_dev’ has initializer but incomplete type
/home/jelle/em28xx-userspace2/em2880-dvb.c:384: error: unknown field ‘demod_address’ specified in initializer
/home/jelle/em28xx-userspace2/em2880-dvb.c:384: warning: excess elements in struct initializer
/home/jelle/em28xx-userspace2/em2880-dvb.c:384: warning: (near initialization for ‘em2880_zl10353_dev’)
/home/jelle/em28xx-userspace2/em2880-dvb.c:385: error: unknown field ‘no_tuner’ specified in initializer
/home/jelle/em28xx-userspace2/em2880-dvb.c:385: warning: excess elements in struct initializer
/home/jelle/em28xx-userspace2/em2880-dvb.c:385: warning: (near initialization for ‘em2880_zl10353_dev’)
/home/jelle/em28xx-userspace2/em2880-dvb.c:394: error: variable ‘em2880_pinnacle_pctvstick_dev’ has initializer but incomplete type
/home/jelle/em28xx-userspace2/em2880-dvb.c:395: error: unknown field ‘demod_address’ specified in initializer
/home/jelle/em28xx-userspace2/em2880-dvb.c:395: warning: excess elements in struct initializer
/home/jelle/em28xx-userspace2/em2880-dvb.c:395: warning: (near initialization for ‘em2880_pinnacle_pctvstick_dev’)
/home/jelle/em28xx-userspace2/em2880-dvb.c:396: error: unknown field ‘no_tuner’ specified in initializer
/home/jelle/em28xx-userspace2/em2880-dvb.c:396: warning: excess elements in struct initializer
/home/jelle/em28xx-userspace2/em2880-dvb.c:396: warning: (near initialization for ‘em2880_pinnacle_pctvstick_dev’)
/home/jelle/em28xx-userspace2/em2880-dvb.c:406: error: variable ‘em2880_mt352_dev’ has initializer but incomplete type
/home/jelle/em28xx-userspace2/em2880-dvb.c:407: error: unknown field ‘demod_address’ specified in initializer
/home/jelle/em28xx-userspace2/em2880-dvb.c:407: warning: excess elements in struct initializer
/home/jelle/em28xx-userspace2/em2880-dvb.c:407: warning: (near initialization for ‘em2880_mt352_dev’)
/home/jelle/em28xx-userspace2/em2880-dvb.c:411: error: unknown field ‘no_tuner’ specified in initializer
/home/jelle/em28xx-userspace2/em2880-dvb.c:411: warning: excess elements in struct initializer
/home/jelle/em28xx-userspace2/em2880-dvb.c:411: warning: (near initialization for ‘em2880_mt352_dev’)
/home/jelle/em28xx-userspace2/em2880-dvb.c:414: error: variable ‘em2880_lgdt3303_dev’ has initializer but incomplete type
/home/jelle/em28xx-userspace2/em2880-dvb.c:415: error: unknown field ‘demod_address’ specified in initializer
/home/jelle/em28xx-userspace2/em2880-dvb.c:415: warning: excess elements in struct initializer
/home/jelle/em28xx-userspace2/em2880-dvb.c:415: warning: (near initialization for ‘em2880_lgdt3303_dev’)
/home/jelle/em28xx-userspace2/em2880-dvb.c:416: error: unknown field ‘demod_chip’ specified in initializer
/home/jelle/em28xx-userspace2/em2880-dvb.c:416: error: ‘LGDT3303’ undeclared here (not in a function)
/home/jelle/em28xx-userspace2/em2880-dvb.c:416: warning: excess elements in struct initializer
/home/jelle/em28xx-userspace2/em2880-dvb.c:416: warning: (near initialization for ‘em2880_lgdt3303_dev’)
/home/jelle/em28xx-userspace2/em2880-dvb.c:429: error: variable ‘em2870_mt2060_config’ has initializer but incomplete type
/home/jelle/em28xx-userspace2/em2880-dvb.c:430: error: unknown field ‘i2c_address’ specified in initializer
/home/jelle/em28xx-userspace2/em2880-dvb.c:430: warning: excess elements in struct initializer
/home/jelle/em28xx-userspace2/em2880-dvb.c:430: warning: (near initialization for ‘em2870_mt2060_config’)
/home/jelle/em28xx-userspace2/em2880-dvb.c: In function ‘em2880_get_status’:
/home/jelle/em28xx-userspace2/em2880-dvb.c:479: error: dereferencing pointer to incomplete type
/home/jelle/em28xx-userspace2/em2880-dvb.c:479: warning: type defaults to ‘int’ in declaration of ‘type name’
/home/jelle/em28xx-userspace2/em2880-dvb.c:479: error: request for member ‘list_head’ in something not a structure or union
/home/jelle/em28xx-userspace2/em2880-dvb.c:479: warning: type defaults to ‘int’ in declaration of ‘__mptr’
/home/jelle/em28xx-userspace2/em2880-dvb.c:479: error: dereferencing pointer to incomplete type
/home/jelle/em28xx-userspace2/em2880-dvb.c:479: error: dereferencing pointer to incomplete type
/home/jelle/em28xx-userspace2/em2880-dvb.c:479: warning: type defaults to ‘int’ in declaration of ‘type name’
/home/jelle/em28xx-userspace2/em2880-dvb.c:479: error: request for member ‘list_head’ in something not a structure or union
/home/jelle/em28xx-userspace2/em2880-dvb.c:479: warning: type defaults to ‘int’ in declaration of ‘type name’
/home/jelle/em28xx-userspace2/em2880-dvb.c:479: error: dereferencing pointer to incomplete type
/home/jelle/em28xx-userspace2/em2880-dvb.c:479: error: dereferencing pointer to incomplete type
/home/jelle/em28xx-userspace2/em2880-dvb.c:479: error: dereferencing pointer to incomplete type
/home/jelle/em28xx-userspace2/em2880-dvb.c:479: warning: type defaults to ‘int’ in declaration of ‘type name’
/home/jelle/em28xx-userspace2/em2880-dvb.c:479: error: request for member ‘list_head’ in something not a structure or union
/home/jelle/em28xx-userspace2/em2880-dvb.c:479: warning: type defaults to ‘int’ in declaration of ‘__mptr’
/home/jelle/em28xx-userspace2/em2880-dvb.c:479: error: dereferencing pointer to incomplete type
/home/jelle/em28xx-userspace2/em2880-dvb.c:479: error: dereferencing pointer to incomplete type
/home/jelle/em28xx-userspace2/em2880-dvb.c:479: error: dereferencing pointer to incomplete type
/home/jelle/em28xx-userspace2/em2880-dvb.c:479: warning: type defaults to ‘int’ in declaration of ‘type name’
/home/jelle/em28xx-userspace2/em2880-dvb.c:479: error: request for member ‘list_head’ in something not a structure or union
/home/jelle/em28xx-userspace2/em2880-dvb.c:479: warning: type defaults to ‘int’ in declaration of ‘type name’
/home/jelle/em28xx-userspace2/em2880-dvb.c:480: error: dereferencing pointer to incomplete type
/home/jelle/em28xx-userspace2/em2880-dvb.c:481: error: ‘DVB_DEVICE_FRONTEND’ undeclared (first use in this function)
/home/jelle/em28xx-userspace2/em2880-dvb.c:481: error: (Each undeclared identifier is reported only once
/home/jelle/em28xx-userspace2/em2880-dvb.c:481: error: for each function it appears in.)
/home/jelle/em28xx-userspace2/em2880-dvb.c:482: error: dereferencing pointer to incomplete type
/home/jelle/em28xx-userspace2/em2880-dvb.c:483: warning: passing argument 1 of ‘dvb_frontend_eventstatus’ from incompatible pointer type
/home/jelle/em28xx-userspace2/em2880-dvb.c:487: error: ‘DVB_DEVICE_DEMUX’ undeclared (first use in this function)
/home/jelle/em28xx-userspace2/em2880-dvb.c:488: error: dereferencing pointer to incomplete type
/home/jelle/em28xx-userspace2/em2880-dvb.c:490: error: ‘DVB_DEVICE_DVR’ undeclared (first use in this function)
/home/jelle/em28xx-userspace2/em2880-dvb.c:491: error: dereferencing pointer to incomplete type
/home/jelle/em28xx-userspace2/em2880-dvb.c:493: error: ‘DVB_DEVICE_NET’ undeclared (first use in this function)
/home/jelle/em28xx-userspace2/em2880-dvb.c:494: error: dereferencing pointer to incomplete type
/home/jelle/em28xx-userspace2/em2880-dvb.c: In function ‘em28xx_ts_bus_ctrl’:
/home/jelle/em28xx-userspace2/em2880-dvb.c:555: error: dereferencing pointer to incomplete type
/home/jelle/em28xx-userspace2/em2880-dvb.c: In function ‘em2880_dvb_init’:
/home/jelle/em28xx-userspace2/em2880-dvb.c:613: warning: implicit declaration of function ‘dvb_attach’
/home/jelle/em28xx-userspace2/em2880-dvb.c:613: warning: assignment makes pointer from integer without a cast
/home/jelle/em28xx-userspace2/em2880-dvb.c:646: error: ‘zl10353_attach’ undeclared (first use in this function)
/home/jelle/em28xx-userspace2/em2880-dvb.c:646: warning: assignment makes pointer from integer without a cast
/home/jelle/em28xx-userspace2/em2880-dvb.c:648: error: dereferencing pointer to incomplete type
/home/jelle/em28xx-userspace2/em2880-dvb.c:649: error: dereferencing pointer to incomplete type
/home/jelle/em28xx-userspace2/em2880-dvb.c:650: error: ‘mt2060_attach’ undeclared (first use in this function)
/home/jelle/em28xx-userspace2/em2880-dvb.c:690: error: ‘lgdt330x_attach’ undeclared (first use in this function)
/home/jelle/em28xx-userspace2/em2880-dvb.c:690: warning: assignment makes pointer from integer without a cast
/home/jelle/em28xx-userspace2/em2880-dvb.c:699: error: dereferencing pointer to incomplete type
/home/jelle/em28xx-userspace2/em2880-dvb.c:700: error: dereferencing pointer to incomplete type
/home/jelle/em28xx-userspace2/em2880-dvb.c:701: error: dereferencing pointer to incomplete type
/home/jelle/em28xx-userspace2/em2880-dvb.c:728: warning: assignment makes pointer from integer without a cast
/home/jelle/em28xx-userspace2/em2880-dvb.c:781: warning: assignment makes pointer from integer without a cast
/home/jelle/em28xx-userspace2/em2880-dvb.c:826: warning: assignment makes pointer from integer without a cast
/home/jelle/em28xx-userspace2/em2880-dvb.c:835: error: dereferencing pointer to incomplete type
/home/jelle/em28xx-userspace2/em2880-dvb.c:836: error: dereferencing pointer to incomplete type
/home/jelle/em28xx-userspace2/em2880-dvb.c:837: error: dereferencing pointer to incomplete type
/home/jelle/em28xx-userspace2/em2880-dvb.c:853: error: ‘mt352_attach’ undeclared (first use in this function)
/home/jelle/em28xx-userspace2/em2880-dvb.c:853: warning: assignment makes pointer from integer without a cast
/home/jelle/em28xx-userspace2/em2880-dvb.c:865: error: dereferencing pointer to incomplete type
/home/jelle/em28xx-userspace2/em2880-dvb.c:866: error: dereferencing pointer to incomplete type
/home/jelle/em28xx-userspace2/em2880-dvb.c:872: error: dereferencing pointer to incomplete type
/home/jelle/em28xx-userspace2/em2880-dvb.c:877: warning: implicit declaration of function ‘dvb_register_adapter’
/home/jelle/em28xx-userspace2/em2880-dvb.c:880: warning: implicit declaration of function ‘dvb_register_frontend’
/home/jelle/em28xx-userspace2/em2880-dvb.c:887: error: ‘DMX_TS_FILTERING’ undeclared (first use in this function)
/home/jelle/em28xx-userspace2/em2880-dvb.c:887: error: ‘DMX_SECTION_FILTERING’ undeclared (first use in this function)
/home/jelle/em28xx-userspace2/em2880-dvb.c:887: error: ‘DMX_MEMORY_BASED_FILTERING’ undeclared (first use in this function)
/home/jelle/em28xx-userspace2/em2880-dvb.c:888: warning: implicit declaration of function ‘dvb_dmx_init’
/home/jelle/em28xx-userspace2/em2880-dvb.c:897: warning: implicit declaration of function ‘dvb_dmxdev_init’
/home/jelle/em28xx-userspace2/em2880-dvb.c: In function ‘em2880_dvb_fini’:
/home/jelle/em28xx-userspace2/em2880-dvb.c:927: warning: implicit declaration of function ‘dvb_unregister_frontend’
/home/jelle/em28xx-userspace2/em2880-dvb.c:928: warning: implicit declaration of function ‘dvb_frontend_detach’
/home/jelle/em28xx-userspace2/em2880-dvb.c:931: warning: implicit declaration of function ‘dvb_dmxdev_release’
/home/jelle/em28xx-userspace2/em2880-dvb.c:932: warning: implicit declaration of function ‘dvb_dmx_release’
/home/jelle/em28xx-userspace2/em2880-dvb.c:934: warning: implicit declaration of function ‘dvb_unregister_adapter’
make[2]: *** [/home/jelle/em28xx-userspace2/em2880-dvb.o] Error 1
make[1]: *** [_module_/home/jelle/em28xx-userspace2] Error 2
make[1]: Leaving directory `/usr/src/linux-headers-2.6.22-14-generic'
make: *** [default] Error 2
rm -rf /lib/modules/2.6.22-14-generic/kernel/drivers/media/video/em28xx/em28xx.ko ; \
        make INSTALL_MOD_PATH= INSTALL_MOD_DIR=kernel/drivers/media/video/em28xx \
                -C /lib/modules/2.6.22-14-generic/build M=/home/jelle/em28xx-userspace2 modules_install
make[1]: Entering directory `/usr/src/linux-headers-2.6.22-14-generic'
  DEPMOD  2.6.22-14-generic
make[1]: Leaving directory `/usr/src/linux-headers-2.6.22-14-generic'
depmod -a
jelle@xubutu-en12000e:~/em28xx-userspace2$


--------------070209030904060600010202
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------070209030904060600010202--
