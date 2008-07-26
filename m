Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6Q2pD1i032298
	for <video4linux-list@redhat.com>; Fri, 25 Jul 2008 22:51:13 -0400
Received: from arroyo.ext.ti.com (arroyo.ext.ti.com [192.94.94.40])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6Q2p1oJ000957
	for <video4linux-list@redhat.com>; Fri, 25 Jul 2008 22:51:01 -0400
From: "Jalori, Mohit" <mjalori@ti.com>
To: John <john.maximus@gmail.com>, "video4linux-list@redhat.com"
	<video4linux-list@redhat.com>
Date: Fri, 25 Jul 2008 21:50:50 -0500
Message-ID: <8AA5EFF14ED6C44DB31DA963D1E78F0DB58C686C@dlee02.ent.ti.com>
References: <3634de740807172215v52a624ga09449e81bb684fe@mail.gmail.com>
In-Reply-To: <3634de740807172215v52a624ga09449e81bb684fe@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: 
Subject: RE: omap3 camera patches
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

> -----Original Message-----
> From: John [mailto:john.maximus@gmail.com]
> Sent: Friday, July 18, 2008 12:15 AM
> To: video4linux-list@redhat.com
> Subject: omap3 camera patches
>
> Hello,
>    looking at the OMAP3 camera patches posted sometime back.
>    I manually applied these patches on a existing OMAP3 2.6.22 kernel.
>    am trying to port an existing SOC micron driver to OMAP3 on a
> custom board.
>    am not seeing any interrupts.
>
>   Is anyone using the current camera patches for OMAP3. Is this
> working?
>
>   Are there any existing sensor drivers that use these patches. I find
> there are no sensor
>   driver for OMAP3.

I have sent the sensor and lens driver patches. They are also based on 2.6.26. I verified these by applying the original 16 patches and then these 4 new ones.

>
>
> Regards,
>
> John

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
