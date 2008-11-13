Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mADHcA8Z003953
	for <video4linux-list@redhat.com>; Thu, 13 Nov 2008 12:38:10 -0500
Received: from smtp6-g19.free.fr (smtp6-g19.free.fr [212.27.42.36])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mADHbwkl001852
	for <video4linux-list@redhat.com>; Thu, 13 Nov 2008 12:37:58 -0500
To: "Magnus Damm" <magnus.damm@gmail.com>
References: <1226521783-19806-1-git-send-email-robert.jarzmik@free.fr>
	<1226521783-19806-3-git-send-email-robert.jarzmik@free.fr>
	<1226521783-19806-4-git-send-email-robert.jarzmik@free.fr>
	<1226521783-19806-5-git-send-email-robert.jarzmik@free.fr>
	<1226521783-19806-6-git-send-email-robert.jarzmik@free.fr>
	<1226521783-19806-7-git-send-email-robert.jarzmik@free.fr>
	<1226521783-19806-8-git-send-email-robert.jarzmik@free.fr>
	<1226521783-19806-9-git-send-email-robert.jarzmik@free.fr>
	<1226521783-19806-10-git-send-email-robert.jarzmik@free.fr>
	<Pine.LNX.4.64.0811122216520.9188@axis700.grange>
	<aec7e5c30811122346t4de9fe6eke16260e820a34864@mail.gmail.com>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Thu, 13 Nov 2008 18:37:26 +0100
In-Reply-To: <aec7e5c30811122346t4de9fe6eke16260e820a34864@mail.gmail.com>
	(Magnus Damm's message of "Thu\, 13 Nov 2008 16\:46\:54 +0900")
Message-ID: <87y6znh6i1.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: video4linux-list@redhat.com, Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 09/13] pxa_camera: use the translation framework
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

"Magnus Damm" <magnus.damm@gmail.com> writes:

> Hi guys,
>
> Yeah, I'd like to have a default "pass-through" case for the SuperH
> CEU driver as well. The host driver is totally unaware of all data
> formats, with the exception of a few formats that can be translated
> into NV12/NV21/NV16/NV61.

For the SuperH, the "pass-through" was kept if I coded correctly. The
translation API is not used at all, and the host driver should behave just as
before.

BTW, if you have the hardware, it would be good, when the review will be
advanced enough, to make some tests (thinking non-regression here).

--
Robert

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
