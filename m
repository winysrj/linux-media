Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9F83lrG005894
	for <video4linux-list@redhat.com>; Wed, 15 Oct 2008 04:03:47 -0400
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.171])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9F837Sl030027
	for <video4linux-list@redhat.com>; Wed, 15 Oct 2008 04:03:10 -0400
Received: by wf-out-1314.google.com with SMTP id 25so2544979wfc.6
	for <video4linux-list@redhat.com>; Wed, 15 Oct 2008 01:03:07 -0700 (PDT)
Message-ID: <aec7e5c30810150103p7ed810ccyc815ad578d64feac@mail.gmail.com>
Date: Wed, 15 Oct 2008 17:03:07 +0900
From: "Magnus Damm" <magnus.damm@gmail.com>
To: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
In-Reply-To: <Pine.LNX.4.64.0810150836100.3896@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081014183936.GB4710@cs181140183.pp.htv.fi>
	<Pine.LNX.4.64.0810142335400.10458@axis700.grange>
	<20081015033303.GC4710@cs181140183.pp.htv.fi>
	<20081015052026.GC20183@cs181140183.pp.htv.fi>
	<aec7e5c30810142328n1563163bw636b8baf1a47ad8b@mail.gmail.com>
	<Pine.LNX.4.64.0810150836100.3896@axis700.grange>
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

Hi Guennadi,

On Wed, Oct 15, 2008 at 3:41 PM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> Hi Magnus
>
> On Wed, 15 Oct 2008, Magnus Damm wrote:
>
>> Thanks for working on fixing the breakage. I'd prefer to wait a bit
>> since there are quite a few pinmux patches queued up that may break if
>> we merge a fix right now. I can fix it up later on.
>
> no, I would not leave the kernel in a non-compilable state even if just
> for one board. Please, test a new version of the patch below. And yes, You
> will have to rebase your patches, sorry. Another thing, could you also,
> please, add a license / copyright header to
> include/media/soc_camera_platform.h?

I'm not asking you to keep the board broken forever. It's just a
question of in which order the trees are getting merged. Again, I'd
rather see that this fix is put _on_top_ of the patches that are
already queued up in the SuperH tree. Merging it before doesn't help
anything in my opinion - especially since the change should go though
the SuperH tree anyway.

Feel free to add any header you like. =)

/ magnus

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
