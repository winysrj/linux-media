Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n1ICWM7M014328
	for <video4linux-list@redhat.com>; Wed, 18 Feb 2009 07:32:22 -0500
Received: from web32102.mail.mud.yahoo.com (web32102.mail.mud.yahoo.com
	[68.142.207.116])
	by mx1.redhat.com (8.13.8/8.13.8) with SMTP id n1ICW8Nv003791
	for <video4linux-list@redhat.com>; Wed, 18 Feb 2009 07:32:09 -0500
Date: Wed, 18 Feb 2009 04:32:08 -0800 (PST)
From: Agustin <gatoguan-os@yahoo.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-ID: <577057.47261.qm@web32102.mail.mud.yahoo.com>
Content-Transfer-Encoding: 8bit
Cc: video4linux list <video4linux-list@redhat.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Arm Kernel <linux-arm-kernel@lists.arm.linux.org.uk>
Subject: PCM037: Broken build on mxc--master,
	missing I2C support (was Re: Rv: mx3-camera on current mxc kernel
	tree)
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

Hi Sascha, I am changing subject here, not sure if Russell's filters will accept this message to the list...

--- Agustin wrote:
> --- Sascha Hauer wrote:
> > On Tue, Feb 17, 2009 at 10:36:01AM -0800, Agustin wrote:
> > > I am using branch "mxc-devel" from 
> git://git.pengutronix.de/git/imx/linux-2.6
> > 
> > Please don't. Please use the mxc-master or mxc-master-flat branch instead. See
> > my mail recently posted here. Guennadis camera patches will probably fit 
> better
> > on this tree.
> 
> Well, I tried both 'mxc-master' and 'mxc-master-flat' but both seemed to have 
> broken support for PCM037. Build stopped, complaining about missing "i2c.h" 
> included from "pcm037.c". Probably the result of partial inegration of I2C 
> support, which I need to have. On the other hand, 'mxc-devel' was buiding and 
> working all right, that's why I am using it.
> 
> Will try again with 'master' branches...

I
just tried 'mxc-master', in case I missed something yesterday. I2C
support seems to be missing at least on MX3 systems. Build breaks like
this:

  CC      arch/arm/mach-mx3/devices.o
  CC      arch/arm/mach-mx3/iomux.o
  CC      arch/arm/mach-mx3/pcm037.o
arch/arm/mach-mx3/pcm037.c:42:22: error: mach/i2c.h: No such file or directory
arch/arm/mach-mx3/pcm037.c:139: error: variable 'pcm037_i2c_1_data' has initializer but incomplete type
arch/arm/mach-mx3/pcm037.c:140: error: unknown field 'bitrate' specified in initializer
arch/arm/mach-mx3/pcm037.c:140: warning: excess elements in struct initializer
arch/arm/mach-mx3/pcm037.c:140: warning: (near initialization for 'pcm037_i2c_1_data')
arch/arm/mach-mx3/pcm037.c:141: error: unknown field 'init' specified in initializer
arch/arm/mach-mx3/pcm037.c:141: warning: excess elements in struct initializer
arch/arm/mach-mx3/pcm037.c:141: warning: (near initialization for 'pcm037_i2c_1_data')
arch/arm/mach-mx3/pcm037.c:142: error: unknown field 'exit' specified in initializer
arch/arm/mach-mx3/pcm037.c:142: warning: excess elements in struct initializer
arch/arm/mach-mx3/pcm037.c:142: warning: (near initialization for 'pcm037_i2c_1_data')
make[2]: *** [arch/arm/mach-mx3/pcm037.o] Error 1
make[1]: *** [arch/arm/mach-mx3] Error 2
make[1]: Leaving directory `/home/agustin/work/mxc-master'

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
