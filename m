Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n775OflJ014493
	for <video4linux-list@redhat.com>; Fri, 7 Aug 2009 01:24:41 -0400
Received: from mail-qy0-f201.google.com (mail-qy0-f201.google.com
	[209.85.221.201])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n775OSkL023400
	for <video4linux-list@redhat.com>; Fri, 7 Aug 2009 01:24:28 -0400
Received: by qyk39 with SMTP id 39so1352557qyk.23
	for <video4linux-list@redhat.com>; Thu, 06 Aug 2009 22:24:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <uy6pxephb.wl%morimoto.kuninori@renesas.com>
References: <uy6pxephb.wl%morimoto.kuninori@renesas.com>
Date: Fri, 7 Aug 2009 14:24:28 +0900
Message-ID: <aec7e5c30908062224t618d8b30pfdb6e7e9b2d6b64@mail.gmail.com>
From: Magnus Damm <magnus.damm@gmail.com>
To: Kuninori Morimoto <morimoto.kuninori@renesas.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: V4L-Linux <video4linux-list@redhat.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 1/2 v2] sh_mobile_ceu: add soft reset function
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

Hi Morimoto-san,

Thanks for your work on this.

On Thu, Aug 6, 2009 at 9:49 AM, Kuninori
Morimoto<morimoto.kuninori@renesas.com> wrote:
>
> Signed-off-by: Kuninori Morimoto <morimoto.kuninori@renesas.com>
> ---
> v1 -> v2
>
> o it use msleep
> o it judge in_atomic or not
>
> it judge in_atomic because sh_mobile_ceu_soft_reset
> will also be called from atomic.

If the time required for soft reset is short enough then you probably
want to use udelay() instead. And if soft delay takes long time then
you don't want to do it from interrupt context anyway. Please update
the patch after summer vacation.

Cheers,

/ magnus

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
