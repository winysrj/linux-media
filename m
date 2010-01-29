Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f228.google.com ([209.85.219.228]:62586 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980Ab0A2QIS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jan 2010 11:08:18 -0500
Received: by ewy28 with SMTP id 28so278422ewy.28
        for <linux-media@vger.kernel.org>; Fri, 29 Jan 2010 08:08:15 -0800 (PST)
Message-ID: <4B6306AA.8000103@googlemail.com>
Date: Fri, 29 Jan 2010 16:02:50 +0000
From: David Henig <dhhenig@googlemail.com>
MIME-Version: 1.0
To: Francis Barber <fedora@barber-family.id.au>
CC: leandro Costantino <lcostantino@gmail.com>,
	=?ISO-8859-1?Q?N=E9meth_?= =?ISO-8859-1?Q?M=E1rton?=
	<nm127@freemail.hu>, linux-media@vger.kernel.org
Subject: Re: Make failed - standard ubuntu 9.10
References: <4B62113E.40905@googlemail.com> <4B627EAE.7020303@freemail.hu>	 <4B62A967.3010400@googlemail.com> <c2fe070d1001290430v472c8040r2a61c7904ef7234d@mail.gmail.com> <4B62F048.1010506@googlemail.com> <4B62F620.6020105@barber-family.id.au>
In-Reply-To: <4B62F620.6020105@barber-family.id.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks, I appear to have the headers and no longer have to do the 
symlink, but still getting the same error - any help gratefully 
received, or do I need to get a vanilla kernel?

CC [M]  /home/david/v4l-dvb/v4l/firedtv-1394.o
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
make[2]: Leaving directory `/usr/src/linux-headers-2.6.31-17-generic'
make[1]: *** [default] Error 2
make[1]: Leaving directory `/home/david/v4l-dvb/v4l'
make: *** [all] Error 2


Francis Barber wrote:
> On 29/01/2010 10:27 PM, David Henig wrote:
>> Thanks, eventually tip 1 fixed this. For some reason I had 
>> 2.6.31-17-generic without a .config, as I seem to be using 
>> 2.6.31-17-generic-pae. Creating a symlink to that fixed this error.
>>
>> Unfortunately still can't finish build, I get an error in 
>> firedtv-1394, as shown below. Do I need to reinstall, as I also get 
>> the following message?
>>
>> ***WARNING:*** You do not have the full kernel sources installed.
>> This does not prevent you from building the v4l-dvb tree if you have the
>> kernel headers, but the full kernel source may be required in order 
>> to use
>> make menuconfig / xconfig / qconfig.
>>
>> If you are experiencing problems building the v4l-dvb tree, please try
>> building against a vanilla kernel before reporting a bug.
>>
>> Thanks again for any help, I'm sorry I'm only a couple of months into 
>> linux, I'm just trying to do this against what I thought was a fairly 
>> standard build...
>>
>> David
>>
> Hi David,
>
> It looks like you don't have the kernel headers package installed.  In 
> Ubuntu this package is called linux-headers-generic for the generic 
> kernel, and linux-headers-server for the server kernel, etc and so forth.
>
> If you have this package you shouldn't need to any symlinking with the 
> .config, either.  I didn't have to.
>
> Regards,
> Frank.
