Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB1F048D015444
	for <video4linux-list@redhat.com>; Mon, 1 Dec 2008 10:00:04 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mB1ExpNk023525
	for <video4linux-list@redhat.com>; Mon, 1 Dec 2008 09:59:51 -0500
Date: Mon, 1 Dec 2008 16:00:00 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
In-Reply-To: <20081201124313.4d233311@pedra.chehab.org>
Message-ID: <Pine.LNX.4.64.0812011551460.3915@axis700.grange>
References: <Pine.LNX.4.64.0812011412050.3915@axis700.grange>
	<20081201124313.4d233311@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
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

On Mon, 1 Dec 2008, Mauro Carvalho Chehab wrote:

> On Mon, 1 Dec 2008 14:22:17 +0100 (CET)
> Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> 
> > Hi Mauro,
> > 
> > I have a series of two patches, of which the first _amends_ a pxa-header, 
> > creates a header under drivers/media/video/, and changes pxa_camera.c to 
> > include the new header:
> > 
> >  arch/arm/mach-pxa/include/mach/pxa-regs.h |   95 -----------------------------
> >  drivers/media/video/pxa_camera.c          |    2 +
> >  drivers/media/video/pxa_camera.h          |   95 +++++++++++++++++++++++++++++
> >  3 files changed, 97 insertions(+), 95 deletions(-)
> >  create mode 100644 drivers/media/video/pxa_camera.h
> > 
> > and the second one is based on the first: it only touches files under 
> > drivers/media/video, but needs results of the first one:
> > 
> >  drivers/media/video/pxa_camera.c |  204 ++++++++++++++++++++++++++++++--------
> >  drivers/media/video/pxa_camera.h |   95 ------------------
> >  2 files changed, 162 insertions(+), 137 deletions(-)
> >  delete mode 100644 drivers/media/video/pxa_camera.h
> > 
> > (yes, it deletes drivers/media/video/pxa_camera.h again... No, I don't 
> > like it either)
> 
> Argh! Why inserting the header file just to delete on the next patch?

Yeah... good question. At first Eric has done everything in one patch: 
moved defines like

-#define CICR0		__REG(0x50000000)
-#define CICR1		__REG(0x50000004)

away from arch/arm/mach-pxa/include/mach/pxa-regs.h thus cleaning it up, 
and replaced them with

+#define CICR0		(0x0000)
+#define CICR1		(0x0004)

because in the same patch he switch pxa_camera.c from IO-style register 
access like

	CICR0 = x;

to memmapped IO. So, I asked him to split that patch into two, also to 
make a clean separation between the ARM and the v4l parts. And this is 
what he came up with - a header file that is created only to be removed 
with the next patch. Whereas I hoped he would just first move defines to 
pxa_camera.c as is, and then replace them _there_ with offsets... But I 
didn't consider this too bad of a problem to ask him about yet another 
revision... If you disagree - we can probably still do this.

> > I acked the first one and it is going to be merged over the ARM tree, the 
> > second one we should merge ourselves.
> > 
> > Shall we wait until the first one is in "next", so we can resync with it 
> > and then push the second one or how would you prefer to do this?
> 
> For sure we need to wait for the first one to be at -next. Then, we should
> apply it, with a meta tag "kernel-sync:", to not break the compilation of
> v4l/dvb tree[1], and apply the second one.
> 
> [1] The meta-tag will sign to my scripts to discard the patch, not exporting it to -git.

Yep... I'll ask him to let me know when the first patch gets in.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
