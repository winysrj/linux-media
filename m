Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB1EhWoc003473
	for <video4linux-list@redhat.com>; Mon, 1 Dec 2008 09:43:33 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB1EhKxc012782
	for <video4linux-list@redhat.com>; Mon, 1 Dec 2008 09:43:20 -0500
Date: Mon, 1 Dec 2008 12:43:13 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Message-ID: <20081201124313.4d233311@pedra.chehab.org>
In-Reply-To: <Pine.LNX.4.64.0812011412050.3915@axis700.grange>
References: <Pine.LNX.4.64.0812011412050.3915@axis700.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: Patches, affecting directories not in hg/linux
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

On Mon, 1 Dec 2008 14:22:17 +0100 (CET)
Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:

> Hi Mauro,
> 
> I have a series of two patches, of which the first _amends_ a pxa-header, 
> creates a header under drivers/media/video/, and changes pxa_camera.c to 
> include the new header:
> 
>  arch/arm/mach-pxa/include/mach/pxa-regs.h |   95 -----------------------------
>  drivers/media/video/pxa_camera.c          |    2 +
>  drivers/media/video/pxa_camera.h          |   95 +++++++++++++++++++++++++++++
>  3 files changed, 97 insertions(+), 95 deletions(-)
>  create mode 100644 drivers/media/video/pxa_camera.h
> 
> and the second one is based on the first: it only touches files under 
> drivers/media/video, but needs results of the first one:
> 
>  drivers/media/video/pxa_camera.c |  204 ++++++++++++++++++++++++++++++--------
>  drivers/media/video/pxa_camera.h |   95 ------------------
>  2 files changed, 162 insertions(+), 137 deletions(-)
>  delete mode 100644 drivers/media/video/pxa_camera.h
> 
> (yes, it deletes drivers/media/video/pxa_camera.h again... No, I don't 
> like it either)

Argh! Why inserting the header file just to delete on the next patch?

> I acked the first one and it is going to be merged over the ARM tree, the 
> second one we should merge ourselves.
> 
> Shall we wait until the first one is in "next", so we can resync with it 
> and then push the second one or how would you prefer to do this?

For sure we need to wait for the first one to be at -next. Then, we should
apply it, with a meta tag "kernel-sync:", to not break the compilation of
v4l/dvb tree[1], and apply the second one.

[1] The meta-tag will sign to my scripts to discard the patch, not exporting it to -git.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
