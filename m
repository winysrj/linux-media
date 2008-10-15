Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9F8uAOD029641
	for <video4linux-list@redhat.com>; Wed, 15 Oct 2008 04:56:10 -0400
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.226])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9F8tvRQ024779
	for <video4linux-list@redhat.com>; Wed, 15 Oct 2008 04:55:57 -0400
Received: by rv-out-0506.google.com with SMTP id f6so2606596rvb.51
	for <video4linux-list@redhat.com>; Wed, 15 Oct 2008 01:55:56 -0700 (PDT)
Message-ID: <aec7e5c30810150155q244834c0i65b2f3b927ba2d37@mail.gmail.com>
Date: Wed, 15 Oct 2008 17:55:56 +0900
From: "Magnus Damm" <magnus.damm@gmail.com>
To: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
In-Reply-To: <Pine.LNX.4.64.0810151011450.3896@axis700.grange>
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
	<aec7e5c30810150103p7ed810ccyc815ad578d64feac@mail.gmail.com>
	<Pine.LNX.4.64.0810151011450.3896@axis700.grange>
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

On Wed, Oct 15, 2008 at 5:26 PM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> On Wed, 15 Oct 2008, Magnus Damm wrote:
>> On Wed, Oct 15, 2008 at 3:41 PM, Guennadi Liakhovetski
>> <g.liakhovetski@gmx.de> wrote:
>> > On Wed, 15 Oct 2008, Magnus Damm wrote:
>> >
>> >> Thanks for working on fixing the breakage. I'd prefer to wait a bit
>> >> since there are quite a few pinmux patches queued up that may break if
>> >> we merge a fix right now. I can fix it up later on.
>> >
>> > no, I would not leave the kernel in a non-compilable state even if just
>> > for one board. Please, test a new version of the patch below. And yes, You
>> > will have to rebase your patches, sorry. Another thing, could you also,
>> > please, add a license / copyright header to
>> > include/media/soc_camera_platform.h?
>>
>> I'm not asking you to keep the board broken forever. It's just a
>> question of in which order the trees are getting merged. Again, I'd
>> rather see that this fix is put _on_top_ of the patches that are
>> already queued up in the SuperH tree. Merging it before doesn't help
>> anything in my opinion - especially since the change should go though
>> the SuperH tree anyway.
>
> I think, compilation-breakage fixes should have higher priority than
> further enhancements. Think about bisection. If you now first commit
> several more patches, you make the interval where the tree is not
> compilable longer, and thus the probabiliy that someone hits it in their
> git.bisect higher. That's why I think any compilation breakage should be
> fixed ASAP. And which changes do you mean specifically? This one:
>
> http://marc.info/?l=linux-sh&m=122346619318532&w=2
>
> Yes, indeed they conflict, but it is trivial to fix. So, I would prefer to
> close the compile-breakage window ASAP, and then trivially update that one
> your patch. Let's see what others say. And as for through which tree it
> should go, if you insist the sh-part going through the sh-tree, then it
> has to be split into two parts - video and sh. Thus extending the
> breakage-window by one commit...

Yeah, that one plus a patch for the smc91x platform data and another
one for mmc (which needs updating anyway). So maybe it's not such a
big deal. And I see your point with closing the window ASAP to do
damage control. Otoh I wonder how big difference it will be extending
the breakage window with one commit - there must be zillions of
commits in after the breakage already.

Paul, any strong feelings regarding merging things though the SuperH tree?

>> Feel free to add any header you like. =)
>
> Thanks, but no thanks:-) I cannot add your copyright, at least not without
> your explicit agreement (I think). So, I'd prefer you submit a patch for
> that.

I wonder if it's a large enough bit sequence to actually copyright. =)
But sure, I'll do that.

Is this .29 material, or will there be a second v4l round with trivial
driver changes for .28?

I've already posted some vivi patches and two simple patches for the
sh_mobile_ceu driver - sorry about the timing - and i have one more
sh_mobile_ceu patch outstanding. Also, I think one of my coworkers may
post a soc_camera driver for ov772x chips soon too.

Is there any chance that can get included in .28?

Thank you!

/ magnus

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
