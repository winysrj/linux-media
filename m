Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9F6TDbO032622
	for <video4linux-list@redhat.com>; Wed, 15 Oct 2008 02:29:13 -0400
Received: from mail-gx0-f15.google.com (mail-gx0-f15.google.com
	[209.85.217.15])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9F6SqL5019931
	for <video4linux-list@redhat.com>; Wed, 15 Oct 2008 02:28:52 -0400
Received: by gxk8 with SMTP id 8so5426390gxk.3
	for <video4linux-list@redhat.com>; Tue, 14 Oct 2008 23:28:52 -0700 (PDT)
Message-ID: <aec7e5c30810142328n1563163bw636b8baf1a47ad8b@mail.gmail.com>
Date: Wed, 15 Oct 2008 15:28:51 +0900
From: "Magnus Damm" <magnus.damm@gmail.com>
To: "Adrian Bunk" <bunk@kernel.org>
In-Reply-To: <20081015052026.GC20183@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081014183936.GB4710@cs181140183.pp.htv.fi>
	<Pine.LNX.4.64.0810142335400.10458@axis700.grange>
	<20081015033303.GC4710@cs181140183.pp.htv.fi>
	<20081015052026.GC20183@cs181140183.pp.htv.fi>
Cc: video4linux-list@redhat.com, Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
	lethal@linux-sh.org, Magnus Damm <damm@igel.co.jp>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
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

On Wed, Oct 15, 2008 at 2:20 PM, Adrian Bunk <bunk@kernel.org> wrote:
> On Wed, Oct 15, 2008 at 06:33:03AM +0300, Adrian Bunk wrote:
>> On Tue, Oct 14, 2008 at 11:53:37PM +0200, Guennadi Liakhovetski wrote:
>> > Fix Migo-R compile breakage caused by incomplete merge.
>> >
>> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
>> >
>> > ---
>> >
>> > Hi Adrian,
>>
>> Hi Guennadi,
>>
>> > please see, if the patch below fixes it. Completely untested. Magnus,
>> > could you please verify if it also works (of course, if it at least
>> > compiles:-)) If it doesn't, please fix it along these lines, if it suits
>> > your needs.
>> >...
>>
>> it does compile.
>>...
>
> But it causes compile breakage elsewhere:
>
> <--  snip  -->

Hi guys,

Thanks for working on fixing the breakage. I'd prefer to wait a bit
since there are quite a few pinmux patches queued up that may break if
we merge a fix right now. I can fix it up later on.

Thanks,

/ magnus

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
