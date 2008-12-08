Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB84PWM6026135
	for <video4linux-list@redhat.com>; Sun, 7 Dec 2008 23:25:32 -0500
Received: from bear.ext.ti.com (bear.ext.ti.com [192.94.94.41])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB84PCF8030675
	for <video4linux-list@redhat.com>; Sun, 7 Dec 2008 23:25:12 -0500
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Trilok Soni <soni.trilok@gmail.com>, Hans Verkuil <hverkuil@xs4all.nl>
Date: Mon, 8 Dec 2008 09:54:58 +0530
Message-ID: <19F8576C6E063C45BE387C64729E739403E90E768D@dbde02.ent.ti.com>
In-Reply-To: <5d5443650812070140w423d6fe9ua2f0ff9d2974bbd7@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: v4l <video4linux-list@redhat.com>, "linux-omap@vger.kernel.org Mailing
	List" <linux-omap@vger.kernel.org>, Sakari Ailus <sakari.ailus@nokia.com>
Subject: RE: [PATCH] Add Omnivision OV9640 sensor support.
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

Hi Soni,

Thanks,
Vaibhav Hiremath

> -----Original Message-----
> From: linux-omap-owner@vger.kernel.org [mailto:linux-omap-
> owner@vger.kernel.org] On Behalf Of Trilok Soni
> Sent: Sunday, December 07, 2008 3:11 PM
> To: Hans Verkuil
> Cc: v4l; linux-omap@vger.kernel.org Mailing List; Sakari Ailus
> Subject: Re: [PATCH] Add Omnivision OV9640 sensor support.
> 
> Hi Hans,
> 
> On Mon, Dec 1, 2008 at 6:21 PM, Trilok Soni <soni.trilok@gmail.com>
> wrote:
> > Hi Hans,
> >
> >>
> >> I reviewed this sensor driver and it's fine except for one thing:
> >> setting the default registers from outside the driver. This is a
> really
> >> bad idea. I2C drivers should be self-contained. I've made the
> same
> >> comment in the tvp514x driver review which I'm copying below
> (with some
> >> small edits):
> >
> > I knew that you are going to comment on that, and I agree on those
> > points. I will pull in that register initialization to the driver.
> >
> 
> Attached the updated ov9640 sensor patch.
> 


[Hiremath, Vaibhav] I just had quick walk through of code and I think you may want to take look at the review comments received for TVP514x driver (Especially for I2C).

> --
> ---Trilok Soni
> http://triloksoni.wordpress.com
> http://www.linkedin.com/in/triloksoni

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
