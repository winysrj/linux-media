Return-path: <video4linux-list-bounces@redhat.com>
Date: Tue, 14 Oct 2008 21:39:36 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Stefan Herbrechtsmeier <hbmeier@hni.uni-paderborn.de>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@redhat.com>, lethal@linux-sh.org
Message-ID: <20081014183936.GB4710@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Cc: Magnus Damm <damm@igel.co.jp>, video4linux-list@redhat.com,
	linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org
Subject: sh/boards/mach-migor/setup.c build error
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

Commit 81034663159f39d005316b5c139038459cd16721
(V4L/DVB (8687): soc-camera: Move .power and .reset from
 soc_camera host to sensor driver) causes the following build error:

<--  snip  -->

...
  CC      arch/sh/boards/mach-migor/setup.o
arch/sh/boards/mach-migor/setup.c:408: error: unknown field 'enable_camera' specified in initializer
arch/sh/boards/mach-migor/setup.c:408: warning: excess elements in struct initializer
arch/sh/boards/mach-migor/setup.c:408: warning: (near initialization for 'sh_mobile_ceu_info')
arch/sh/boards/mach-migor/setup.c:409: error: unknown field 'disable_camera' specified in initializer
arch/sh/boards/mach-migor/setup.c:409: warning: excess elements in struct initializer
arch/sh/boards/mach-migor/setup.c:409: warning: (near initialization for 'sh_mobile_ceu_info')
make[2]: *** [arch/sh/boards/mach-migor/setup.o] Error 1

<--  snip  -->


cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
