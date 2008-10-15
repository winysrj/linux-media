Return-path: <video4linux-list-bounces@redhat.com>
Date: Wed, 15 Oct 2008 08:20:26 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Message-ID: <20081015052026.GC20183@cs181140183.pp.htv.fi>
References: <20081014183936.GB4710@cs181140183.pp.htv.fi>
	<Pine.LNX.4.64.0810142335400.10458@axis700.grange>
	<20081015033303.GC4710@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081015033303.GC4710@cs181140183.pp.htv.fi>
Cc: video4linux-list@redhat.com, Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
	lethal@linux-sh.org, Magnus Damm <damm@igel.co.jp>
Subject: Re: [PATCH] soc-camera: fix compile breakage on SH
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

On Wed, Oct 15, 2008 at 06:33:03AM +0300, Adrian Bunk wrote:
> On Tue, Oct 14, 2008 at 11:53:37PM +0200, Guennadi Liakhovetski wrote:
> > Fix Migo-R compile breakage caused by incomplete merge.
> > 
> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > 
> > ---
> > 
> > Hi Adrian,
> 
> Hi Guennadi,
> 
> > please see, if the patch below fixes it. Completely untested. Magnus, 
> > could you please verify if it also works (of course, if it at least 
> > compiles:-)) If it doesn't, please fix it along these lines, if it suits 
> > your needs.
> >...
> 
> it does compile.
>...

But it causes compile breakage elsewhere:

<--  snip  -->

...
  CC      drivers/media/video/soc_camera_platform.o
drivers/media/video/soc_camera_platform.c: In function ‘soc_camera_platform_init’:
drivers/media/video/soc_camera_platform.c:49: error: ‘struct soc_camera_platform_info’ has no member named ‘power’
drivers/media/video/soc_camera_platform.c:50: error: ‘struct soc_camera_platform_info’ has no member named ‘power’
drivers/media/video/soc_camera_platform.c: In function ‘soc_camera_platform_release’:
drivers/media/video/soc_camera_platform.c:59: error: ‘struct soc_camera_platform_info’ has no member named ‘power’
drivers/media/video/soc_camera_platform.c:60: error: ‘struct soc_camera_platform_info’ has no member named ‘power’
make[4]: *** [drivers/media/video/soc_camera_platform.o] Error 1

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
