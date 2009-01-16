Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0G4vfEJ014007
	for <video4linux-list@redhat.com>; Thu, 15 Jan 2009 23:57:41 -0500
Received: from yx-out-2324.google.com (yx-out-2324.google.com [74.125.44.30])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n0G4vStG003879
	for <video4linux-list@redhat.com>; Thu, 15 Jan 2009 23:57:28 -0500
Received: by yx-out-2324.google.com with SMTP id 31so554023yxl.81
	for <video4linux-list@redhat.com>; Thu, 15 Jan 2009 20:57:28 -0800 (PST)
Message-ID: <aec7e5c30901152057o54136434v4f8875ad1b683c44@mail.gmail.com>
Date: Fri, 16 Jan 2009 13:57:27 +0900
From: "Magnus Damm" <magnus.damm@gmail.com>
To: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
In-Reply-To: <Pine.LNX.4.64.0901111924320.16531@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081210045432.3810.42700.sendpatchset@rx1.opensource.se>
	<Pine.LNX.4.64.0901111924320.16531@axis700.grange>
Cc: video4linux-list@redhat.com, Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] videobuf-dma-contig: fix USERPTR free handling
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

On Mon, Jan 12, 2009 at 3:26 AM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> On Wed, 10 Dec 2008, Magnus Damm wrote:
>
>> From: Magnus Damm <damm@igel.co.jp>
>>
>> This patch fixes a free-without-alloc bug for V4L2_MEMORY_USERPTR
>> video buffers.
>>
>> Signed-off-by: Magnus Damm <damm@igel.co.jp>
>
> Mauro, what about this patch? Is it correct? If so, it shall be applied I
> presume, as in that case it is a bug-fix.

It's a bug fix and getting it included would be great!

Thank you.

/ magnus

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
