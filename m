Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m654OstF023718
	for <video4linux-list@redhat.com>; Sat, 5 Jul 2008 00:24:54 -0400
Received: from yw-out-2324.google.com (yw-out-2324.google.com [74.125.46.29])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m654OiLF020002
	for <video4linux-list@redhat.com>; Sat, 5 Jul 2008 00:24:44 -0400
Received: by yw-out-2324.google.com with SMTP id 5so604717ywb.81
	for <video4linux-list@redhat.com>; Fri, 04 Jul 2008 21:24:41 -0700 (PDT)
Message-ID: <aec7e5c30807042124y31bf3ce3qf7ef8aa03d92a15@mail.gmail.com>
Date: Sat, 5 Jul 2008 13:24:41 +0900
From: "Magnus Damm" <magnus.damm@gmail.com>
To: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
In-Reply-To: <Pine.LNX.4.64.0807050602370.705@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080705025335.27137.98068.sendpatchset@rx1.opensource.se>
	<20080705025345.27137.74420.sendpatchset@rx1.opensource.se>
	<Pine.LNX.4.64.0807050602370.705@axis700.grange>
Cc: video4linux-list@redhat.com, paulius.zaleckas@teltonika.lt,
	linux-sh@vger.kernel.org, Mauro Carvalho Chehab <mchehab@infradead.org>,
	lethal@linux-sh.org, akpm@linux-foundation.org
Subject: Re: [PATCH 01/04] soc_camera: Move spinlocks
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

On Sat, Jul 5, 2008 at 1:19 PM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> On Sat, 5 Jul 2008, Magnus Damm wrote:
>
>> This patch moves the spinlock handling from soc_camera.c to the actual
>> camera host driver. The spinlock alloc/free callbacks are replaced with
>> code in init_videobuf().
>
> Does this mean, that you have found a possibility to port your
> spinlock-removal patch on the top of the "make videobuf independent" patch
> without any loss of functionality? This looks good on a first glance. I am
> on a holiday now (:-)), so, I unfortunately cannot review your patches
> ATM. I'll try to do this in a week, hope, this still will be in time for
> the 2.6.27 merge window.

Yes, you are correct. It was much easier than I expected. Have a good holiday!

/ magnus

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
