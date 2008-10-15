Return-path: <video4linux-list-bounces@redhat.com>
Date: Wed, 15 Oct 2008 06:33:03 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Message-ID: <20081015033303.GC4710@cs181140183.pp.htv.fi>
References: <20081014183936.GB4710@cs181140183.pp.htv.fi>
	<Pine.LNX.4.64.0810142335400.10458@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0810142335400.10458@axis700.grange>
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

On Tue, Oct 14, 2008 at 11:53:37PM +0200, Guennadi Liakhovetski wrote:
> Fix Migo-R compile breakage caused by incomplete merge.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> 
> ---
> 
> Hi Adrian,

Hi Guennadi,

> please see, if the patch below fixes it. Completely untested. Magnus, 
> could you please verify if it also works (of course, if it at least 
> compiles:-)) If it doesn't, please fix it along these lines, if it suits 
> your needs.
>...

it does compile.

I cannot verify whether it also works.

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
