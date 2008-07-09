Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m699YjdY028750
	for <video4linux-list@redhat.com>; Wed, 9 Jul 2008 05:34:45 -0400
Received: from yx-out-2324.google.com (yx-out-2324.google.com [74.125.44.29])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m699YZlj003958
	for <video4linux-list@redhat.com>; Wed, 9 Jul 2008 05:34:35 -0400
Received: by yx-out-2324.google.com with SMTP id 3so697201yxj.81
	for <video4linux-list@redhat.com>; Wed, 09 Jul 2008 02:34:35 -0700 (PDT)
Message-ID: <aec7e5c30807090133k476c0a48h4b8aec66459ee78d@mail.gmail.com>
Date: Wed, 9 Jul 2008 17:33:44 +0900
From: "Magnus Damm" <magnus.damm@gmail.com>
To: "Laurent Pinchart" <laurent.pinchart@skynet.be>
In-Reply-To: <200807081642.34261.laurent.pinchart@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080705025335.27137.98068.sendpatchset@rx1.opensource.se>
	<20080705025405.27137.16206.sendpatchset@rx1.opensource.se>
	<48737AA3.3080902@teltonika.lt>
	<200807081642.34261.laurent.pinchart@skynet.be>
Cc: video4linux-list@redhat.com,
	Paulius Zaleckas <paulius.zaleckas@teltonika.lt>, linux-sh@vger.kernel.org
Subject: Re: [PATCH 03/04] videobuf: Add physically contiguous queue code V2
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

On Tue, Jul 8, 2008 at 11:42 PM, Laurent Pinchart
<laurent.pinchart@skynet.be> wrote:
> On Tuesday 08 July 2008, Paulius Zaleckas wrote:
>> Magnus Damm wrote:
>> > This is V2 of the physically contiguous videobuf queues patch.
>> > Useful for hardware such as the SuperH Mobile CEU which doesn't
>> > support scatter gatter bus mastering.
>>
>> spelling gatther :)
>
> gather would be even better :-)

Heh, maybe so, but even better would be if videobuf-dma-sg.c and
videobuf-vmalloc.c used the same spelling... =)

/ magnus

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
