Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:43831 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755319Ab0A2O1Z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jan 2010 09:27:25 -0500
Received: by bwz27 with SMTP id 27so1449570bwz.21
        for <linux-media@vger.kernel.org>; Fri, 29 Jan 2010 06:27:23 -0800 (PST)
Message-ID: <4B62F048.1010506@googlemail.com>
Date: Fri, 29 Jan 2010 14:27:20 +0000
From: David Henig <dhhenig@googlemail.com>
MIME-Version: 1.0
To: leandro Costantino <lcostantino@gmail.com>
CC: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>,
	linux-media@vger.kernel.org
Subject: Re: Make failed - standard ubuntu 9.10
References: <4B62113E.40905@googlemail.com> <4B627EAE.7020303@freemail.hu>	 <4B62A967.3010400@googlemail.com> <c2fe070d1001290430v472c8040r2a61c7904ef7234d@mail.gmail.com>
In-Reply-To: <c2fe070d1001290430v472c8040r2a61c7904ef7234d@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks, eventually tip 1 fixed this. For some reason I had 
2.6.31-17-generic without a .config, as I seem to be using 
2.6.31-17-generic-pae. Creating a symlink to that fixed this error.

Unfortunately still can't finish build, I get an error in firedtv-1394, 
as shown below. Do I need to reinstall, as I also get the following message?

***WARNING:*** You do not have the full kernel sources installed.
This does not prevent you from building the v4l-dvb tree if you have the
kernel headers, but the full kernel source may be required in order to use
make menuconfig / xconfig / qconfig.

If you are experiencing problems building the v4l-dvb tree, please try
building against a vanilla kernel before reporting a bug.

Thanks again for any help, I'm sorry I'm only a couple of months into 
linux, I'm just trying to do this against what I thought was a fairly 
standard build...

David

[error section]

/home/david/v4l-dvb/v4l/firedtv-1394.c:21:17: error: dma.h: No such file 
or directory
/home/david/v4l-dvb/v4l/firedtv-1394.c:22:21: error: csr1212.h: No such 
file or directory
/home/david/v4l-dvb/v4l/firedtv-1394.c:23:23: error: highlevel.h: No 
such file or directory
/home/david/v4l-dvb/v4l/firedtv-1394.c:24:19: error: hosts.h: No such 
file or directory
/home/david/v4l-dvb/v4l/firedtv-1394.c:25:22: error: ieee1394.h: No such 
file or directory
/home/david/v4l-dvb/v4l/firedtv-1394.c:26:17: error: iso.h: No such file 
or directory
/home/david/v4l-dvb/v4l/firedtv-1394.c:27:21: error: nodemgr.h: No such 
file or directory
/home/david/v4l-dvb/v4l/firedtv-1394.c:40: warning: 'struct hpsb_iso' 
declared inside parameter list
/home/david/v4l-dvb/v4l/firedtv-1394.c:40: warning: its scope is only 
this definition or declaration, which is probably not what you want
/home/david/v4l-dvb/v4l/firedtv-1394.c: In function 'rawiso_activity_cb':
/home/david/v4l-dvb/v4l/firedtv-1394.c:56: error: dereferencing pointer 
to incomplete type
/home/david/v4l-dvb/v4l/firedtv-1394.c:57: error: implicit declaration 
of function 'hpsb_iso_n_ready'
/home/david/v4l-dvb/v4l/firedtv-1394.c:64: error: dereferencing pointer 
to incomplete type
/home/david/v4l-dvb/v4l/firedtv-1394.c:65: error: implicit declaration 
of function 'dma_region_i'
/home/david/v4l-dvb/v4l/firedtv-1394.c:65: error: dereferencing pointer 
to incomplete type
/home/david/v4l-dvb/v4l/firedtv-1394.c:65: error: expected expression 
before 'unsigned'
/home/david/v4l-dvb/v4l/firedtv-1394.c:66: warning: assignment makes 
pointer from integer without a cast
/home/david/v4l-dvb/v4l/firedtv-1394.c:67: error: dereferencing pointer 
to incomplete type
/home/david/v4l-dvb/v4l/firedtv-1394.c:71: error: dereferencing pointer 
to incomplete type
/home/david/v4l-dvb/v4l/firedtv-1394.c:85: error: implicit declaration 
of function 'hpsb_iso_recv_release_packets'
/home/david/v4l-dvb/v4l/firedtv-1394.c: In function 'node_of':
/home/david/v4l-dvb/v4l/firedtv-1394.c:90: error: dereferencing pointer 
to incomplete type
/home/david/v4l-dvb/v4l/firedtv-1394.c:90: warning: type defaults to 
'int' in declaration of '__mptr'
/home/david/v4l-dvb/v4l/firedtv-1394.c:90: warning: initialization from 
incompatible pointer type
/home/david/v4l-dvb/v4l/firedtv-1394.c:90: error: invalid use of 
undefined type 'struct unit_directory'
/home/david/v4l-dvb/v4l/firedtv-1394.c: In function 'node_lock':
/home/david/v4l-dvb/v4l/firedtv-1394.c:97: error: implicit declaration 
of function 'hpsb_node_lock'
/home/david/v4l-dvb/v4l/firedtv-1394.c:97: error: 'EXTCODE_COMPARE_SWAP' 
undeclared (first use in this function)
/home/david/v4l-dvb/v4l/firedtv-1394.c:97: error: (Each undeclared 
identifier is reported only once
/home/david/v4l-dvb/v4l/firedtv-1394.c:97: error: for each function it 
appears in.)
/home/david/v4l-dvb/v4l/firedtv-1394.c:98: error: 'quadlet_t' undeclared 
(first use in this function)
/home/david/v4l-dvb/v4l/firedtv-1394.c:98: error: expected expression 
before ')' token
/home/david/v4l-dvb/v4l/firedtv-1394.c: In function 'node_read':
/home/david/v4l-dvb/v4l/firedtv-1394.c:106: error: implicit declaration 
of function 'hpsb_node_read'
/home/david/v4l-dvb/v4l/firedtv-1394.c: In function 'node_write':
/home/david/v4l-dvb/v4l/firedtv-1394.c:111: error: implicit declaration 
of function 'hpsb_node_write'
/home/david/v4l-dvb/v4l/firedtv-1394.c: In function 'start_iso':
/home/david/v4l-dvb/v4l/firedtv-1394.c:122: error: implicit declaration 
of function 'hpsb_iso_recv_init'
/home/david/v4l-dvb/v4l/firedtv-1394.c:122: error: dereferencing pointer 
to incomplete type
/home/david/v4l-dvb/v4l/firedtv-1394.c:124: error: 
'HPSB_ISO_DMA_DEFAULT' undeclared (first use in this function)
/home/david/v4l-dvb/v4l/firedtv-1394.c:126: warning: assignment makes 
pointer from integer without a cast
/home/david/v4l-dvb/v4l/firedtv-1394.c:133: error: implicit declaration 
of function 'hpsb_iso_recv_start'
/home/david/v4l-dvb/v4l/firedtv-1394.c:136: error: implicit declaration 
of function 'hpsb_iso_shutdown'
/home/david/v4l-dvb/v4l/firedtv-1394.c: In function 'stop_iso':
/home/david/v4l-dvb/v4l/firedtv-1394.c:147: error: implicit declaration 
of function 'hpsb_iso_stop'
/home/david/v4l-dvb/v4l/firedtv-1394.c: At top level:
/home/david/v4l-dvb/v4l/firedtv-1394.c:162: warning: 'struct hpsb_host' 
declared inside parameter list
/home/david/v4l-dvb/v4l/firedtv-1394.c: In function 'fcp_request':
/home/david/v4l-dvb/v4l/firedtv-1394.c:175: error: dereferencing pointer 
to incomplete type
/home/david/v4l-dvb/v4l/firedtv-1394.c:176: error: dereferencing pointer 
to incomplete type
/home/david/v4l-dvb/v4l/firedtv-1394.c: In function 'node_probe':
/home/david/v4l-dvb/v4l/firedtv-1394.c:190: error: dereferencing pointer 
to incomplete type
/home/david/v4l-dvb/v4l/firedtv-1394.c:190: warning: type defaults to 
'int' in declaration of '__mptr'
/home/david/v4l-dvb/v4l/firedtv-1394.c:190: warning: initialization from 
incompatible pointer type
/home/david/v4l-dvb/v4l/firedtv-1394.c:190: error: invalid use of 
undefined type 'struct unit_directory'
/home/david/v4l-dvb/v4l/firedtv-1394.c:195: error: dereferencing pointer 
to incomplete type
/home/david/v4l-dvb/v4l/firedtv-1394.c:196: error: dereferencing pointer 
to incomplete type
/home/david/v4l-dvb/v4l/firedtv-1394.c:197: error: implicit declaration 
of function 'CSR1212_TEXTUAL_DESCRIPTOR_LEAF_DATA'
/home/david/v4l-dvb/v4l/firedtv-1394.c:197: error: dereferencing pointer 
to incomplete type
/home/david/v4l-dvb/v4l/firedtv-1394.c:197: warning: assignment makes 
pointer from integer without a cast
/home/david/v4l-dvb/v4l/firedtv-1394.c: At top level:
/home/david/v4l-dvb/v4l/firedtv-1394.c:256: warning: 'struct 
unit_directory' declared inside parameter list
/home/david/v4l-dvb/v4l/firedtv-1394.c: In function 'node_update':
/home/david/v4l-dvb/v4l/firedtv-1394.c:258: error: dereferencing pointer 
to incomplete type
/home/david/v4l-dvb/v4l/firedtv-1394.c: At top level:
/home/david/v4l-dvb/v4l/firedtv-1394.c:266: error: variable 
'fdtv_driver' has initializer but incomplete type
/home/david/v4l-dvb/v4l/firedtv-1394.c:267: error: unknown field 'name' 
specified in initializer
/home/david/v4l-dvb/v4l/firedtv-1394.c:267: warning: excess elements in 
struct initializer
/home/david/v4l-dvb/v4l/firedtv-1394.c:267: warning: (near 
initialization for 'fdtv_driver')
/home/david/v4l-dvb/v4l/firedtv-1394.c:268: error: unknown field 
'id_table' specified in initializer
/home/david/v4l-dvb/v4l/firedtv-1394.c:268: warning: excess elements in 
struct initializer
/home/david/v4l-dvb/v4l/firedtv-1394.c:268: warning: (near 
initialization for 'fdtv_driver')
/home/david/v4l-dvb/v4l/firedtv-1394.c:269: error: unknown field 
'update' specified in initializer
/home/david/v4l-dvb/v4l/firedtv-1394.c:269: warning: excess elements in 
struct initializer
/home/david/v4l-dvb/v4l/firedtv-1394.c:269: warning: (near 
initialization for 'fdtv_driver')
/home/david/v4l-dvb/v4l/firedtv-1394.c:270: error: unknown field 
'driver' specified in initializer
/home/david/v4l-dvb/v4l/firedtv-1394.c:270: error: extra brace group at 
end of initializer
/home/david/v4l-dvb/v4l/firedtv-1394.c:270: error: (near initialization 
for 'fdtv_driver')
/home/david/v4l-dvb/v4l/firedtv-1394.c:273: warning: excess elements in 
struct initializer
/home/david/v4l-dvb/v4l/firedtv-1394.c:273: warning: (near 
initialization for 'fdtv_driver')
/home/david/v4l-dvb/v4l/firedtv-1394.c:276: error: variable 
'fdtv_highlevel' has initializer but incomplete type
/home/david/v4l-dvb/v4l/firedtv-1394.c:277: error: unknown field 'name' 
specified in initializer
/home/david/v4l-dvb/v4l/firedtv-1394.c:277: warning: excess elements in 
struct initializer
/home/david/v4l-dvb/v4l/firedtv-1394.c:277: warning: (near 
initialization for 'fdtv_highlevel')
/home/david/v4l-dvb/v4l/firedtv-1394.c:278: error: unknown field 
'fcp_request' specified in initializer
/home/david/v4l-dvb/v4l/firedtv-1394.c:278: warning: excess elements in 
struct initializer
/home/david/v4l-dvb/v4l/firedtv-1394.c:278: warning: (near 
initialization for 'fdtv_highlevel')
/home/david/v4l-dvb/v4l/firedtv-1394.c: In function 'fdtv_1394_init':
/home/david/v4l-dvb/v4l/firedtv-1394.c:285: error: implicit declaration 
of function 'hpsb_register_highlevel'
/home/david/v4l-dvb/v4l/firedtv-1394.c:286: error: implicit declaration 
of function 'hpsb_register_protocol'
/home/david/v4l-dvb/v4l/firedtv-1394.c:289: error: implicit declaration 
of function 'hpsb_unregister_highlevel'
/home/david/v4l-dvb/v4l/firedtv-1394.c: In function 'fdtv_1394_exit':
/home/david/v4l-dvb/v4l/firedtv-1394.c:296: error: implicit declaration 
of function 'hpsb_unregister_protocol'
make[3]: *** [/home/david/v4l-dvb/v4l/firedtv-1394.o] Error 1
make[2]: *** [_module_/home/david/v4l-dvb/v4l] Error 2
make[2]: Leaving directory `/usr/src/linux-headers-2.6.31-17-generic-pae'
make[1]: *** [default] Error 2
make[1]: Leaving directory `/home/david/v4l-dvb/v4l'
make: *** [all] Error 2


leandro Costantino wrote:
> Its looking for .config file inside the kernel source.
>
> /lib/modules/2.6.31-17-generic/build/.config
>   1) check that /build is a symlink to /usr/src/kernel-path-source
>   2) IF there is something like /proc/config  , copy it to
> /usr/src/kernel-path-source/.config
>       IF NOT, then you could try doing a make oldconfig ....
>
> I really dont know that the ubuntu packages includes inside, so, those
> are my 2 cents...
>
> 2010/1/29 David Henig <dhhenig@googlemail.com>:
>   
>> Thanks, I've been trying to follow the wiki, but getting this error. The
>> main kernel packages seem to all be installed, but perhaps something less
>> obvious is missing - hard to tell without a definitive list of dependencies.
>> Help would be much appreciated!
>>
>> David
>>
>> Németh Márton wrote:
>>     
>>> David Henig wrote:
>>>
>>>       
>>>> Please can someone assist, not sure what the cause of the below is? This
>>>> is my second attempt to get linux tv to work, I suspect it's a basic level
>>>> error - sorry I'm fairly new to Linux... output below, I'm running a fairly
>>>> standard ubuntu 9.10 setup.
>>>>
>>>> make[1]: Entering directory `/home/david/v4l-dvb/v4l'
>>>> Updating/Creating .config
>>>> Preparing to compile for kernel version 2.6.31
>>>> File not found: /lib/modules/2.6.31-17-generic/build/.config at
>>>> ./scripts/make_kconfig.pl line 32, <IN> line 4.
>>>> make[1]: *** No rule to make target `.myconfig', needed by
>>>> `config-compat.h'. Stop.
>>>> make[1]: Leaving directory `/home/david/v4l-dvb/v4l'
>>>> make: *** [all] Error 2
>>>>
>>>>         
>>> I think you don't have the kernel development files installed.
>>>
>>> The recommended reading would be:
>>>
>>> http://linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-DVB_Device_Drivers
>>>
>>> Regards,
>>>
>>>        Márton Németh
>>>
>>>       
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>     
