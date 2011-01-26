Return-path: <mchehab@pedra>
Received: from mx1.redhat.com (ext-mx03.extmail.prod.ext.phx2.redhat.com
	[10.5.110.7])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id p0QJd0xl006062
	for <video4linux-list@redhat.com>; Wed, 26 Jan 2011 14:39:00 -0500
Received: from soapstone1.mail.cornell.edu (soapstone1.mail.cornell.edu
	[128.253.83.143])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id p0QJclVf012489
	for <video4linux-list@redhat.com>; Wed, 26 Jan 2011 14:38:48 -0500
Received: from exchange.cornell.edu ([10.16.197.26])
	by soapstone1.mail.cornell.edu (8.14.4/8.14.4) with ESMTP id
	p0QJcn0Y009988
	for <video4linux-list@redhat.com>; Wed, 26 Jan 2011 14:38:49 -0500 (EST)
From: Devin Bougie <devin.bougie@cornell.edu>
To: "video4linux-list@redhat.com" <video4linux-list@redhat.com>
Date: Wed, 26 Jan 2011 14:38:45 -0500
Subject: Re: xawtv crashes with Sensoray 611 on RHEL5
Message-ID: <835A8D82-5E54-4958-98A0-F7647EA93317@cornell.edu>
References: <3A916790-1E8D-4460-90B6-CF92D9F517F5@cornell.edu>
In-Reply-To: <3A916790-1E8D-4460-90B6-CF92D9F517F5@cornell.edu>
Content-Language: en-US
MIME-Version: 1.0
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: video4linux-list-bounces@redhat.com
Sender: <mchehab@pedra>
List-ID: <video4linux-list@redhat.com>

Hello,

The crashes previously described only appear when running a 64-bit build of xawtv on 64-bit RHEL5.  Every time we tried to run a 32-bit build on the 64-bit system, the entire system hung.  However, we do not have any trouble running a 32-bit build of xawtv on 32-bit RHEL5.

Any suggestions for running xawtv on 64-bit RHEL5 would be greatly appreciated.

Sincerely,
Devin

On Jan 13, 2011, at 2:57 PM, Devin Bougie wrote:

> Hello,
>
> We are trying to use two Sensoray 611 frame grabbers in a 64-bit RHEL5 system. Initially, things seem to work properly after adding the following to /etc/modprobe.conf:
>
> options bttv card=73,73
>
> We are testing the card with xawtv. We can start xawtv and view the input from each card. However, whenever trying to change any settings or do anything with the image (such as take a snapshot), xawtv crashes.
>
> Any suggestions for addressing this would be greatly appreciated.  I have included some details below, but please let me know if I can provide any more information.
>
> Many thanks,
> Devin
>
> PS. Here is the dmesg output from boot:
> ------
> [dab66@lnx177-p1 ~]% dmesg |grep bttv
> bttv: driver version 0.9.16 loaded
> bttv: using 8 buffers with 2080k (520 pages) each for capture
> bttv: Bt8xx card found (0).
> bttv0: Bt878 (rev 17) at 0000:05:04.0, irq: 169, latency: 64, mmio: 0xd0003000
> bttv0: subsystem: 6000:0611 (UNKNOWN)
> bttv0: using: Sensoray 311 [card=73,insmod option]
> bttv0: gpio: en=00000000, out=00000000 in=00ff7fff [init]
> bttv0: using tuner=-1
> bttv0: i2c: checking for MSP34xx @ 0x80... not found
> bttv0: i2c: checking for TDA9875 @ 0xb0... not found
> bttv0: i2c: checking for TDA7432 @ 0x8a... not found
> bttv0: i2c: checking for TDA9887 @ 0x86... not found
> bttv0: registered device video0
> bttv0: registered device vbi0
> bttv: Bt8xx card found (1).
> bttv1: Bt878 (rev 17) at 0000:05:05.0, irq: 177, latency: 64, mmio: 0xd0001000
> bttv1: subsystem: 6000:0611 (UNKNOWN)
> bttv1: using: Sensoray 311 [card=73,insmod option]
> bttv1: gpio: en=00000000, out=00000000 in=00ff7fff [init]
> bttv1: using tuner=-1
> bttv1: i2c: checking for MSP34xx @ 0x80... not found
> bttv1: i2c: checking for TDA9875 @ 0xb0... not found
> bttv1: i2c: checking for TDA7432 @ 0x8a... not found
> bttv1: i2c: checking for TDA9887 @ 0x86... not found
> bttv1: registered device video1
> bttv1: registered device vbi1
> ------
>
> And, here is an example crash dump from xawtv.
> ------[dab66@lnx177-p1 ~]% xawtv -remote -device /dev/video0
> This is xawtv-3.95, running on Linux/x86_64 (2.6.18-194.17.4.el5)
> Warning: Cannot convert string "-*-ledfixed-medium-r-*--39-*-*-*-c-*-*-*" to type FontStruct
> *** glibc detected *** xawtv: double free or corruption (!prev): 0x000000001794a3b0 ***
> ======= Backtrace: =========
> /lib64/libc.so.6[0x3f9a67230f]
> /lib64/libc.so.6(cfree+0x4b)[0x3f9a67276b]
> /usr/lib64/nvidia/tls/libnvidia-tls.so.260.19.29[0x3fa44008bb]
> ======= Memory map: ========
> 00400000-0043c000 r-xp 00000000 08:02 290574 /usr/bin/xawtv
> 0063c000-00645000 rw-p 0003c000 08:02 290574 /usr/bin/xawtv
> 00645000-0064b000 rw-p 00645000 00:00 0
> 00844000-00850000 rw-p 00044000 08:02 290574 /usr/bin/xawtv
> 1774c000-17a64000 rw-p 1774c000 00:00 0 [heap]
> 3f99600000-3f9960d000 r-xp 00000000 08:02 1718052 /lib64/ld-2.5.so
> 3f9960d000-3f9960e000 -wxp 0000d000 08:02 1718052 /lib64/ld-2.5.so
> 3f9960e000-3f9961c000 r-xp 0000e000 08:02 1718052 /lib64/ld-2.5.so
> 3f9981b000-3f9981c000 r--p 0001b000 08:02 1718052 /lib64/ld-2.5.so
> 3f9981c000-3f9981d000 rw-p 0001c000 08:02 1718052 /lib64/ld-2.5.so
> 3f99a00000-3f99a17000 r-xp 00000000 08:02 269900 /usr/lib64/libXmu.so.6.2.0
> 3f99a17000-3f99c16000 ---p 00017000 08:02 269900 /usr/lib64/libXmu.so.6.2.0
> 3f99c16000-3f99c18000 rw-p 00016000 08:02 269900 /usr/lib64/libXmu.so.6.2.0
> 3f99e00000-3f99e10000 r-xp 00000000 08:02 269912 /usr/lib64/libXpm.so.4.11.0
> 3f99e10000-3f9a010000 ---p 00010000 08:02 269912 /usr/lib64/libXpm.so.4.11.0
> 3f9a010000-3f9a011000 rw-p 00010000 08:02 269912 /usr/lib64/libXpm.so.4.11.0
> 3f9a200000-3f9a262000 r-xp 00000000 08:02 270036 /usr/lib64/libXaw7.so.7.0.0
> 3f9a262000-3f9a461000 ---p 00062000 08:02 270036 /usr/lib64/libXaw7.so.7.0.0
> 3f9a461000-3f9a46c000 rw-p 00061000 08:02 270036 /usr/lib64/libXaw7.so.7.0.0
> 3f9a600000-3f9a74e000 r-xp 00000000 08:02 1718059 /lib64/libc-2.5.so
> 3f9a74e000-3f9a94d000 ---p 0014e000 08:02 1718059 /lib64/libc-2.5.so
> 3f9a94d000-3f9a951000 r--p 0014d000 08:02 1718059 /lib64/libc-2.5.so
> 3f9a951000-3f9a952000 rw-p 00151000 08:02 1718059 /lib64/libc-2.5.so
> 3f9a952000-3f9a957000 rw-p 3f9a952000 00:00 0
> 3f9aa00000-3f9aa82000 r-xp 00000000 08:02 1718069 /lib64/libm-2.5.so
> 3f9aa82000-3f9ac81000 ---p 00082000 08:02 1718069 /lib64/libm-2.5.so
> 3f9ac81000-3f9ac82000 r--p 00081000 08:02 1718069 /lib64/libm-2.5.so
> 3f9ac82000-3f9ac83000 rw-p 00082000 08:02 1718069 /lib64/libm-2.5.so
> 3f9ae00000-3f9ae02000 r-xp 00000000 08:02 1718063 /lib64/libdl-2.5.so
> 3f9ae02000-3f9b002000 ---p 00002000 08:02 1718063 /lib64/libdl-2.5.so
> 3f9b002000-3f9b003000 r--p 00002000 08:02 1718063 /lib64/libdl-2.5.so
> 3f9b003000-3f9b004000 rw-p 00003000 08:02 1718063 /lib64/libdl-2.5.so
> 3f9b200000-3f9b216000 r-xp 00000000 08:02 1718065 /lib64/libpthread-2.5.so
> 3f9b216000-3f9b415000 ---p 00016000 08:02 1718065 /lib64/libpthread-2.5.so
> 3f9b415000-3f9b416000 r--p 00015000 08:02 1718065 /lib64/libpthread-2.5.so
> 3f9b416000-3f9b417000 rw-p 00016000 08:02 1718065 /lib64/libpthread-2.5.so
> 3f9b417000-3f9b41b000 rw-p 3f9b417000 00:00 0
> 3f9b600000-3f9b614000 r-xp 00000000 08:02 273492 /usr/lib64/libz.so.1.2.3
> 3f9b614000-3f9b813000 ---p 00014000 08:02 273492 /usr/lib64/libz.so.1.2.3
> 3f9b813000-3f9b814000 rw-p 00013000 08:02 273492 /usr/lib64/libz.so.1.2.3
> 3f9ba00000-3f9ba05000 r-xp 00000000 08:02 266928 /usr/lib64/libXdmcp.so.6.0.0
> 3f9ba05000-3f9bc04000 ---p 00005000 08:02 266928 /usr/lib64/libXdmcp.so.6.0.0
> 3f9bc04000-3f9bc05000 rw-p 00004000 08:02 266928 /usr/lib64/libXdmcp.so.6.0.0
> 3f9be00000-3f9be02000 r-xp 00000000 08:02 266664 /usr/lib64/libXau.so.6.0.0
> 3f9be02000-3f9c001000 ---p 00002000 08:02 266664 /usr/lib64/libXau.so.6.0.0
> 3f9c001000-3f9c002000 rw-p 00001000 08:02 266664 /usr/lib64/libXau.so.6.0.0
> 3f9c200000-3f9c305000 r-xp 00000000 08:02 267695 /usr/lib64/libX11.so.6.2.0
> 3f9c305000-3f9c505000 ---p 00105000 08:02 267695 /usr/lib64/libX11.so.6.2.0
> 3f9c505000-3f9c50c000 rw-p 00105000 08:02 267695 /usr/lib64/libX11.so.6.2.0
> 3f9c600000-3f9c610000 r-xp 00000000 08:02 269898 /usr/lib64/libXext.so.6.4.0
> 3f9c610000-3f9c810000 ---p 00010000 08:02 269898 /usr/lib64/libXext.so.6.4.0
> 3f9c810000-3f9c811000 rw-p 00010000 08:02 269898 /usr/lib64/libXext.so.6.4.0
> 3f9ca00000-3f9ca7f000 r-xp 00000000 08:02 270001 /usr/lib64/libfreetype.so.6.3.10
> 3f9ca7f000-3f9cc7f000 ---p 0007f000 08:02 270001 /usr/lib64/libfreetype.so.6.3.10
> 3f9cc7f000-3f9cc84000 rw-p 0007f000 08:02 270001 /usr/lib64/libfreetype.so.6.3.10
> 3f9ce00000-3f9ce20000 r-xp 00000000 08:02 1718073 /lib64/libexpat.so.0.5.0
> 3f9ce20000-3f9d01f000 ---p 00020000 08:02 1718073 /lib64/libexpat.so.0.5.0
> 3f9d01f000-3f9d022000 rw-p 0001f000 08:02 1718073 /lib64/libexpat.so.0.5.0
> 3f9d200000-3f9d209000 r-xp 00000000 08:02 269892 /usr/lib64/libXrender.so.1.3.0
> 3f9d209000-3f9d408000 ---p 00009000 08:02 269892 /usr/lib64/libXrender.so.1.3.0
> 3f9d408000-3f9d409000 rw-p 00008000 08:02 269892 /usr/lib64/libXrender.so.1.3.0
> 3f9d600000-3f9d623000 r-xp 00000000 08:02 267943 /usr/lib64/libpng12.so.0.10.0
> 3f9d623000-3f9d823000 ---p 00023000 08:02 267943 /usr/lib64/libpng12.so.0.10.0
> 3f9d823000-3f9d824000 rw-p 00023000 08:02 267943 /usr/lib64/libpng12.so.0.10.0
> 3f9da00000-3f9da29000 r-xp 00000000 08:02 2402283 /usr/lib64/libfontconfig.so.1.1.0
> 3f9da29000-3f9dc29000 ---p 00029000 08:02 2402283 /usr/lib64/libfontconfig.so.1.1.0
> 3f9dc29000-3f9dc33000 rw-p 00029000 08:02 2402283 /usr/lib64/libfontconfig.so.1.1.0
> 3f9dc33000-3f9dc34000 rw-p 3f9dc33000 00:00 0
> 3f9de00000-3f9de02000 r-xp 00000000 08:02 270034 /usr/lib64/libXinerama.so.1.0.0
> 3f9de02000-3f9e001000 ---p 00002000 08:02 270034 /usr/lib64/libXinerama.so.1.0.0
> 3f9e001000-3f9e002000 rw-p 00001000 08:02 270034 /usr/lib64/libXinerama.so.1.0.0
> 3f9e200000-3f9e203000 r-xp 00000000 08:02 269896 /usr/lib64/libXrandr.so.2.0.0
> 3f9e203000-3f9e402000 ---p 00003000 08:02 269896 /usr/lib64/libXrandr.so.2.0.0
> 3f9e402000-3f9e403000 rw-p 00002000 08:02 269896 /usr/lib64/libXrandr.so.2.0.0
> 3f9e600000-3f9e656000 r-xp 00000000 08:02 283514 /usr/lib64/libncursesw.so.5.5
> 3f9e656000-3f9e856000 ---p 00056000 08:02 283514 /usr/lib64/libncursesw.so.5.5
> 3f9e856000-3f9e864000 rw-p 00056000 08:02 283514 /usr/lib64/libncursesw.so.5.5
> 3f9e864000-3f9e865000 rw-p 3f9e864000 00:00 0
> 3f9ea00000-3f9ea05000 r-xp 00000000 08:02 270022 /usr/lib64/libXxf86dga.so.1.0.0
> 3f9ea05000-3f9ec05000 ---p 00005000 08:02 270022 /usr/lib64/libXxf86dga.so.1.0.0
> 3f9ec05000-3f9ec06000 rw-p 00005000 08:02 270022 /usr/lib64/libXxf86dga.so.1.0.0
> 3f9ee00000-3f9ee07000 r-xp 00000000 08:02 1718091 /lib64/librt-2.5.so
> 3f9ee07000-3f9f007000 ---p 00007000 08:02 1718091 /lib64/librt-2.5.so
> 3f9f007000-3f9f008000 r--p 00007000 08:02 1718091 /lib64/librt-2.5.so
> 3f9f008000-3f9f009000 rw-p 00008000 08:02 1718091 /lib64/librt-2.5.so
> 3f9f200000-3f9f209000 r-xp 00000000 08:02 266534 /usr/lib64/libSM.so.6.0.0
> 3f9f209000-3f9f409000 ---p 00009000 08:02 266534 /usr/lib64/libSM.so.6.0.0
> 3f9f409000-3f9f40a000 rw-p 00009000 08:02 266534 /usr/lib64/libSM.so.6.0.0
> 3f9f600000-3f9f621000 r-xp 00000000 08:02 2402282 /usr/lib64/libjpeg.so.62.0.0
> 3f9f621000-3f9f820000 ---p 00021000 08:02 2402282 /usr/lib64/libjpeg.so.62.0.0
> 3f9f820000-3f9f821000 rw-p 00020000 08:02 2402282 /usr/lib64/libjpeg.so.62.0.0
> 3f9fa00000-3f9fa17000 r-xp 00000000 08:02 273172 /usr/lib64/libICE.so.6.3.0
> 3f9fa17000-3f9fc16000 ---p 00017000 08:02 273172 /usr/lib64/libICE.so.6.3.0
> 3f9fc16000-3f9fc18000 rw-p 00016000 08:02 273172 /usr/lib64/libICE.so.6.3.0
> 3f9fc18000-3f9fc1b000 rw-p 3f9fc18000 00:00 0
> 3f9fe00000-3f9fe04000 r-xp 00000000 08:02 291348 /usr/lib64/libXv.so.1.0.0
> 3f9fe04000-3fa0004000 ---p 00004000 08:02 291348 /usr/lib64/libXv.so.1.0.0
> 3fa0004000-3fa0005000 rw-p 00004000 08:02 291348 /usr/lib64/libXv.so.1.0.0
> 3fa0200000-3fa0204000 r-xp 00000000 08:02 278908 /usr/lib64/liblirc_client.so.0.0.0
> 3fa0204000-3fa0403000 ---p 00004000 08:02 278908 /usr/lib64/liblirc_client.so.0.0.0
> 3fa0403000-3fa0404000 rw-p 00003000 08:02 278908 /usr/lib64/liblirc_client.so.0.0.0
> 3fa0600000-3fa066c000 r-xp 00000000 08:02 280698 /usr/lib64/libzvbi.so.0.13.1
> 3fa066c000-3fa086c000 ---p 0006c000 08:02 280698 /usr/lib64/libzvbi.so.0.13.1
> 3fa086c000-3fa087f000 rw-p 0006c000 08:02 280698 /usr/lib64/libzvbi.so.0.13.1
> 3fa087f000-3fa0880000 rw-p 3fa087f000 00:00 0
> 3fa3800000-3fa3813000 r-xp 00000000 08:02 273071 /usr/lib64/libXft.so.2.1.2
> 3fa3813000-3fa3a12000 ---p 00013000 08:02 273071 /usr/lib64/libXft.so.2.1.2
> 3fa3a12000-3fa3a13000 rw-p 00012000 08:02 273071 /usr/lib64/libXft.so.2.1.2
> 3fa4400000-3fa4401000 r-xp 00000000 08:02 421953 /usr/lib64/nvidia/tls/libnvidia-tls.so.260.19.29
> 3fa4401000-3fa4601000 ---p 00001000 08:02 421953 /usr/lib64/nvidia/tls/libnvidia-tls.so.260.19.29
> 3fa4601000-3fa4602000 rw-p 00001000 08:02 421953 /usr/lib64/nvidia/tls/libnvidia-tls.so.260.19.29
> 3fa4c00000-3fa4cb7000 r-xp 00000000 08:02 2402254 /usr/lib64/nvidia/libGL.so.260.19.29
> 3fa4cb7000-3fa4eb7000 ---p 000b7000 08:02 2402254 /usr/lib64/nvidia/libGL.so.260.19.29
> 3fa4eb7000-3fa4eef000 rwxp 000b7000 08:02 2402254 /usr/lib64/nvidia/libGL.so.260.19.29
> 3fa4eef000-3fa4f05000 rwxp 3fa4eef000 00:00 0
> 3fa7c00000-3fa7cd6000 r-xp 00000000 08:02 1718099 /lib64/libasound.so.2.0.0
> 3fa7cd6000-3fa7ed5000 ---p 000d6000 08:02 1718099 /lib64/libasound.so.2.0.0
> 3fa7ed5000-3fa7edd000 rw-p 000d5000 08:02 1718099 /lib64/libasound.so.2.0.0
> 3fa9800000-3faabf9000 r-xp 00000000 08:02 2402253 /usr/lib64/nvidia/libnvidia-glcore.so.260.19.29
> 3faabf9000-3faadf9000 ---p 013f9000 08:02 2402253 /usr/lib64/nvidia/libnvidia-glcore.so.260.19.29
> 3faadf9000-3fab3d6000 rwxp 013f9000 08:02 2402253 /usr/lib64/nvidia/libnvidia-glcore.so.260.19.29
> 3fab3d6000-3fab3ec000 rwxp 3fab3d6000 00:00 0
> 3fae400000-3fae45b000 r-xp 00000000 08:02 290522 /usr/lib64/libXt.so.6.0.0
> 3fae45b000-3fae65a000 ---p 0005b000 08:02 290522 /usr/lib64/libXt.so.6.0.0
> 3fae65a000-3fae660000 rw-p 0005a000 08:02 290522 /usr/lib64/libXt.so.6.0.0
> 3fae660000-3fae661000 rw-p 3fae660000 00:00 0
> 3faec00000-3faec05000 r-xp 00000000 08:02 270092 /usr/lib64/libXxf86vm.so.1.0.0
> 3faec05000-3faee04000 ---p 00005000 08:02 270092 /usr/lib64/libXxf86vm.so.1.0.0
> 3faee04000-3faee05000 rw-p 00004000 08:02 270092 /usr/lib64/libXxf86vm.so.1.0.0
> 2aae8f148000-2aae8f149000 rw-p 2aae8f148000 00:00 0
> 2aae8f174000-2aae8f1c4000 rw-p 2aae8f174000 00:00 0
> 2aae8f1ef000-2aae8f1f9000 r-xp 00000000 08:02 1718074 /lib64/libnss_files-2.5.so
> 2aae8f1f9000-2aae8f3f8000 ---p 0000a000 08:02 1718074 /lib64/libnss_files-2.5.so
> 2aae8f3f8000-2aae8f3f9000 r--p 00009000 08:02 1718074 /lib64/libnss_files-2.5.so
> 2aae8f3f9000-2aae8f3fa000 rw-p 0000a000 08:02 1718074 /lib64/libnss_files-2.5.so
> 2aae8f3fa000-2aae929cb000 r--p 00000000 08:02 2366575 /usr/lib/locale/locale-archive
> 2aae929cb000-2aae929d2000 r--s 00000000 08:02 362360 /usr/lib64/gconv/gconv-modules.cache
> 2aae929d2000-2aae929d3000 r-xp 00000000 08:02 298397 /usr/lib64/xawtv/bilinear.so
> 2aae929d3000-2aae92bd2000 ---p 00001000 08:02 298397 /usr/lib64/xawtv/bilinear.so
> 2aae92bd2000-2aae92bd3000 rw-p 00000000 08:02 298397 /usr/lib64/xawtv/bilinear.so
> 2aae92bd3000-2aae92bd6000 r-xp 00000000 08:02 298398 /usr/lib64/xawtv/conv-mjpeg.so
> 2aae92bd6000-2aae92dd5000 ---p 00003000 08:02 298398 /usr/lib64/xawtv/conv-mjpeg.so
> 2aae92dd5000-2aae92dd6000 rw-p 00002000 08:02 298398 /usr/lib64/xawtv/conv-mjpeg.so
> 2aae92dd6000-2aae92dd7000 r-xp 00000000 08:02 298399 /usr/lib64/xawtv/cubic.so
> 2aae92dd7000-2aae92fd6000 ---p 00001000 08:02 298399 /usr/lib64/xawtv/cubic.so
> 2aae92fd6000-2aae92fd7000 rw-p 00000000 08:02 298399 /usr/lib64/xawtv/cubic.so
> 2aae92fd7000-2aae92fe0000 r-xp 00000000 08:02 298400 /usr/lib64/xawtv/drv0-v4l2.so
> 2aae92fe0000-2aae931df000 ---p 00009000 08:02 298400 /usr/lib64/xawtv/drv0-v4l2.so
> 2aae931df000-2aae931f6000 rw-p 00008000 08:02 298400 /usr/lib64/xawtv/drv0-v4l2.so
> 2aae931f6000-2aae931fd000 r-xp 00000000 08:02 298401 /usr/lib64/xawtv/drv1-v4l.so
> 2aae931fd000-2aae933fc000 ---p 00007000 08:02 298401 /usr/lib64/xawtv/drv1-v4l.so
> 2aae933fc000-2aae93406000 rw-p 00006000 08:02 298401 /usr/lib64/xawtv/drv1-v4l.so
> 2aae93406000-2aae93407000 r-xp 00000000 08:02 298402 /usr/lib64/xawtv/flt-disor.so
> 2aae93407000-2aae93607000 ---p 00001000 08:02 298402 /usr/lib64/xawtv/flt-disor.so
> 2aae93607000-2aae93608000 rw-p 00001000 08:02 298402 /usr/lib64/xawtv/flt-disor.so
> 2aae93608000-2aae93609000 r-xp 00000000 08:02 298403 /usr/lib64/xawtv/flt-gamma.so
> 2aae93609000-2aae93809000 ---p 00001000 08:02 298403 /usr/lib64/xawtv/flt-gamma.so
> 2aae93809000-2aae9380a000 rw-p 00001000 08:02 298403 /usr/lib64/xawtv/flt-gamma.so
> 2aae9380a000-2aae9380b000 r-xp 00000000 08:02 298404 /usr/lib64/xawtv/flt-invert.so
> 2aae9380b000-2aae93a0a000 ---p 00001000 08:02 298404 /usr/lib64/xawtv/flt-invert.so
> 2aae93a0a000-2aae93a0b000 rw-p 00000000 08:02 298404 /usr/lib64/xawtv/flt-invert.so
> 2aae93a0b000-2aae93a0d000 r-xp 00000000 08:02 298405 /usr/lib64/xawtv/flt-smooth.so
> 2aae93a0d000-2aae93c0c000 ---p 00002000 08:02 298405 /usr/lib64/xawtv/flt-smooth.so
> 2aae93c0c000-2aae93c0d000 rw-p 00001000 08:02 298405 /usr/lib64/xawtv/flt-smooth.so
> 2aae93c0d000-2aae93c0e000 r-xp 00000000 08:02 298406 /usr/lib64/xawtv/linear-blend.so
> 2aae93c0e000-2aae93e0d000 ---p 00001000 08:02 298406 /usr/lib64/xawtv/linear-blend.so
> 2aae93e0d000-2aae93e0e000 rw-p 00000000 08:02 298406 /usr/lib64/xawtv/linear-blend.so
> 2aae93e0e000-2aae93e0f000 r-xp 00000000 08:02 298407 /usr/lib64/xawtv/linedoubler.so
> 2aae93e0f000-2aae9400e000 ---p 00001000 08:02 298407 /usr/lib64/xawtv/linedoubler.so
> 2aae9400e000-2aae9400f000 rw-p 00000000 08:02 298407 /usr/lib64/xawtv/linedoubler.so
> 2aae9400f000-2aae94011000 r-xp 00000000 08:02 298408 /usr/lib64/xawtv/read-avi.so
> 2aae94011000-2aae94211000 ---p 00002000 08:02 298408 /usr/lib64/xawtv/read-avi.so
> 2aae94211000-2aae94212000 rw-p 00002000 08:02 298408 /usr/lib64/xawtv/read-avi.so
> 2aae94212000-2aae94214000 r-xp 00000000 08:02 298409 /usr/lib64/xawtv/read-dv.so
> 2aae94214000-2aae94413000 ---p 00002000 08:02 298409 /usr/lib64/xawtv/read-dv.so
> 2aae94413000-2aae94414000 rw-p 00001000 08:02 298409 /usr/lib64/xawtv/read-dv.so
> 2aae9443f000-2aae9445a000 r-xp 00000000 08:02 268841 /usr/lib64/libdv.so.4.0.2
> 2aae9445a000-2aae9465a000 ---p 0001b000 08:02 268841 /usr/lib64/libdv.so.4.0.2
> 2aae9465a000-2aae9465d000 rw-p 0001b000 08:02 268841 /usr/lib64/libdv.so.4.0.2
> 2aae9465d000-2aae9466a000 rw-p 2aae9465d000 00:00 0
> 2aae9466a000-2aae9466d000 r-xp 00000000 08:02 298410 /usr/lib64/xawtv/snd-oss.so
> 2aae9466d000-2aae9486d000 ---p 00003000 08:02 298410 /usr/lib64/xawtv/snd-oss.so
> 2aae9486d000-2aae9486e000 rw-p 00003000 08:02 298410 /usr/lib64/xawtv/snd-oss.so
> 2aae9486e000-2aae94871000 r-xp 00000000 08:02 298411 /usr/lib64/xawtv/write-avi.so
> 2aae94871000-2aae94a70000 ---p 00003000 08:02 298411 /usr/lib64/xawtv/write-avi.so
> 2aae94a70000-2aae94a71000 rw-p 00002000 08:02 298411 /usr/lib64/xawtv/write-avi.so
> 2aae94a71000-2aae94a73000 r-xp 00000000 08:02 298412 /usr/lib64/xawtv/write-dv.so
> 2aae94a73000-2aae94c72000 ---p 00002000 08:02 298412 /usr/lib64/xawtv/write-dv.so
> 2aae94c72000-2aae94c73000 rw-p 00001000 08:02 298412 /usr/lib64/xawtv/write-dv.so
> 2aae94c9e000-2aae94ca7000 r-xp 00000000 08:02 270032 /usr/lib64/libXcursor.so.1.0.2
> 2aae94ca7000-2aae94ea7000 ---p 00009000 08:02 270032 /usr/lib64/libXcursor.so.1.0.2
> 2aae94ea7000-2aae94ea8000 rw-p 00009000 08:02 270032 /usr/lib64/libXcursor.so.1.0.2
> 2aae94ea8000-2aae94ead000 r-xp 00000000 08:02 269908 /usr/lib64/libXfixes.so.3.1.0
> 2aae94ead000-2aae950ac000 ---p 00005000 08:02 269908 /usr/lib64/libXfixes.so.3.1.0
> 2aae950ac000-2aae950ad000 rw-p 00004000 08:02 269908 /usr/lib64/libXfixes.so.3.1.0
> 2aae950ad000-2aae95179000 rw-p 2aae950ad000 00:00 0
> 2aae95204000-2aae95240000 rw-p 2aae95204000 00:00 0
> 2aae95240000-2aae9524d000 r-xp 00000000 08:02 1718075 /lib64/libgcc_s-4.1.2-20080825.so.1
> 2aae9524d000-2aae9544d000 ---p 0000d000 08:02 1718075 /lib64/libgcc_s-4.1.2-20080825.so.1
> 2aae9544d000-2aae9544e000 rw-p 0000d000 08:02 1718075 /lib64/libgcc_s-4.1.2-20080825.so.1
> 7fffa53a1000-7fffa53b6000 rw-p 7ffffffe9000 00:00 0 [stack]
> ffffffffff600000-ffffffffffe00000 ---p 00000000 00:00 0 [vdso]
> Aborted
> ------
>
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
