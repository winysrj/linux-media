Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx09.extmail.prod.ext.phx2.redhat.com
	[10.5.110.13])
	by int-mx03.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id n88N5xrw031621
	for <video4linux-list@redhat.com>; Tue, 8 Sep 2009 19:05:59 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx1.redhat.com (8.13.8/8.13.8) with SMTP id n88N5htP030207
	for <video4linux-list@redhat.com>; Tue, 8 Sep 2009 19:05:44 -0400
Date: Wed, 9 Sep 2009 01:05:47 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Kuninori Morimoto <morimoto.kuninori@renesas.com>
In-Reply-To: <uy6opvhjp.wl%morimoto.kuninori@renesas.com>
Message-ID: <Pine.LNX.4.64.0909090045040.3423@axis700.grange>
References: <ueiqiw6mn.wl%morimoto.kuninori@renesas.com>
	<Pine.LNX.4.64.0909080931160.4550@axis700.grange>
	<u1vmhx20t.wl%morimoto.kuninori@renesas.com>
	<Pine.LNX.4.64.0909081057570.4550@axis700.grange>
	<uzl95vjum.wl%morimoto.kuninori@renesas.com>
	<Pine.LNX.4.64.0909081214040.4550@axis700.grange>
	<uy6opvhjp.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: V4L-Linux <video4linux-list@redhat.com>
Subject: Re: [PATCH 1/4] soc-camera: tw9910: hsync_ctrl can control from
 platform
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

On Tue, 8 Sep 2009, Kuninori Morimoto wrote:

> 
> Dear Guennadi
> 
> > What problem are you getting? Not sure if there has been an issue, in any 
> > case it would be better, if you could base on v4l2-linux-next plus my 
> > imagebus patches. In that state tw9910 should work.
> 
> I tried v4l2-linux-next/master.
> 
> my tw9910 (MigoR) say
> 
> v4l2: select timeout,
> v4l2: select timeout,
> v4l2: select timeout...
> 
> and I can find green screen.

Ok, I just checked out

git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-next.git

as of commit 4d0f480e360a58fc089c2a2f1279945d3c0e79e3, built for migor and 
tested tw9910 with mplayer:

mplayer tv:// -tv \
driver=v4l2:width=720:height=576:device=/dev/video1:norm=PAL:outfmt=nv12 \
-zoom -x 320 -y 240 -vo fbdev

- worked as expected. This is some patched mplayer, but you certainly have 
something to test with too.

> does your imagebus patches = 
> 
> [PATCH 0/3] image-bus API
> [PATCH 1/3] v4l: Add a 10-bit monochrome and missing 8- and 10-bit Bayer fourcc codes
> [PATCH 2/3] v4l: add an image-bus API for configuring v4l2 subdev pixel and frame formats
> [PATCH 3/3] soc-camera: convert to the new imagebus API
> 
> correct ?

Yes, sent to the list exactly a week ago - on the 2nd of September.

> I got these patches, and try like this.
> 
> # git fetch v4l2-linux-next
> # git checkout v4l2-linux-next/master
> # git am -3 ${PATH}/*.patch
> 
> Applying: v4l: Add a 10-bit monochrome and missing 8- and 10-bit Bayer fourcc codes
> Applying: v4l: add an image-bus API for configuring v4l2 subdev pixel and frame formats
> error: patch failed: include/media/v4l2-subdev.h:225
> error: include/media/v4l2-subdev.h: patch does not apply
> fatal: sha1 information is lacking or useless (include/media/v4l2-subdev.h).
> Repository lacks necessary blobs to fall back on 3-way merge.
> Cannot fall back to three-way merge.
> Patch failed at 0002.
> When you have resolved this problem run "git am -3 --resolved".
> If you would prefer to skip this patch, instead run "git am -3 --skip".
> To restore the original branch and stop patching run "git am -3 --abort".

Well, yes, the patches do not apply again. I do not know your schedule. 
Would it be ok, if we wait until these image-bus patches get reviewed and, 
hopefully, applied, or, maybe I put a patch series again on a server, 
including these three patches, after rebasing them on some downloadable 
tree, so, you could base your patches on that? Cannot promise this would 
happen very soon though. Or you can fix up my patches on the current 
v4l-next yourself - it shouldn't be too difficult.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
