Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAE1JHnM021599
	for <video4linux-list@redhat.com>; Thu, 13 Nov 2008 20:19:17 -0500
Received: from mail-gx0-f11.google.com (mail-gx0-f11.google.com
	[209.85.217.11])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAE1J6Y0015502
	for <video4linux-list@redhat.com>; Thu, 13 Nov 2008 20:19:06 -0500
Received: by gxk4 with SMTP id 4so518584gxk.3
	for <video4linux-list@redhat.com>; Thu, 13 Nov 2008 17:19:06 -0800 (PST)
Message-ID: <aec7e5c30811131711k1558e1d3ob55ff5477a94216b@mail.gmail.com>
Date: Fri, 14 Nov 2008 10:11:15 +0900
From: "Magnus Damm" <magnus.damm@gmail.com>
To: "Robert Jarzmik" <robert.jarzmik@free.fr>
In-Reply-To: <87y6znh6i1.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1226521783-19806-1-git-send-email-robert.jarzmik@free.fr>
	<1226521783-19806-5-git-send-email-robert.jarzmik@free.fr>
	<1226521783-19806-6-git-send-email-robert.jarzmik@free.fr>
	<1226521783-19806-7-git-send-email-robert.jarzmik@free.fr>
	<1226521783-19806-8-git-send-email-robert.jarzmik@free.fr>
	<1226521783-19806-9-git-send-email-robert.jarzmik@free.fr>
	<1226521783-19806-10-git-send-email-robert.jarzmik@free.fr>
	<Pine.LNX.4.64.0811122216520.9188@axis700.grange>
	<aec7e5c30811122346t4de9fe6eke16260e820a34864@mail.gmail.com>
	<87y6znh6i1.fsf@free.fr>
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

Hi Robert,

On Fri, Nov 14, 2008 at 2:37 AM, Robert Jarzmik <robert.jarzmik@free.fr> wrote:
> "Magnus Damm" <magnus.damm@gmail.com> writes:
>> Yeah, I'd like to have a default "pass-through" case for the SuperH
>> CEU driver as well. The host driver is totally unaware of all data
>> formats, with the exception of a few formats that can be translated
>> into NV12/NV21/NV16/NV61.
>
> For the SuperH, the "pass-through" was kept if I coded correctly. The
> translation API is not used at all, and the host driver should behave just as
> before.

That's nice, thank you. The current upstream SH Mobile CEU driver does
not need any translation, but I think your translation API may be
useful for my NV12/NV21 implementation patch posted yesterday. It
conflicts with basically everything. =)

For that patch I'd like to use pass through to support all camera
modes, but also add NVxx modes if a certain set of modes are exported
by the camera. Right now the patch is using some ugly malloc/free
operations to overload the camera mode list.

> BTW, if you have the hardware, it would be good, when the review will be
> advanced enough, to make some tests (thinking non-regression here).

I'll keep on up-porting the NV12 code and make sure that things are
working. Thanks!

/ magnus

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
