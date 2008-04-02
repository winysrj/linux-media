Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3213c4a013058
	for <video4linux-list@redhat.com>; Tue, 1 Apr 2008 21:03:38 -0400
Received: from rv-out-0910.google.com (rv-out-0910.google.com [209.85.198.186])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3213RhB002075
	for <video4linux-list@redhat.com>; Tue, 1 Apr 2008 21:03:28 -0400
Received: by rv-out-0910.google.com with SMTP id k15so1384252rvb.51
	for <video4linux-list@redhat.com>; Tue, 01 Apr 2008 18:03:27 -0700 (PDT)
Message-ID: <998e4a820804011803p1c96c980u2b32a50bc04ea9ad@mail.gmail.com>
Date: Wed, 2 Apr 2008 09:03:27 +0800
From: "=?GB2312?B?t+v2zg==?=" <fengxin215@gmail.com>
To: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
In-Reply-To: <Pine.LNX.4.64.0804020000590.10163@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Disposition: inline
References: <998e4a820804010143w79ff1513x9ba0945576cfad9a@mail.gmail.com>
	<Pine.LNX.4.64.0804020000590.10163@axis700.grange>
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: some question for "soc_camera V4L2 interface for directly
	connected cameras"
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

thanks for your mail.I'm a beginner.Maybe some question is easy,but I
get your help,I'm very happy.

ÔÚ 08-4-2£¬Guennadi Liakhovetski<g.liakhovetski@gmx.de> Ð´µÀ£º
> On Tue, 1 Apr 2008, ·ëöÎ wrote:
>
>  > I use a driver that is "soc_camera V4L2 interface for directly
>  > connected cameras".but I have some problems:
>  > 1¡¢is this driver for linux-2.6.24?
>  > 2¡¢I want to know how can I get arch/arm/mach-pxa/devices.c.
>
>
> Best just clone the v4l-dvb/devel tree, it contains the newest state of
>  the driver.

How can I get  v4l-dvb/devel tree? Is your soc_camera driver based on
v4l-dvb/devel tree?

>  > 3¡¢the function mt9v022_probe(struct i2c_client *client) in mt9v022.c
>  > does not execute,why?

> As for every (new style) i2c driver, you need to register them from your
>  platform code. See arch/arm/mach-pxa/pcm990-baseboard.c and look for i2c
>  devices there, specifically for mt9v022, if this is what you need.

Maybe my kernel linux-2.6.24 have no arch/arm/mach-pxa/pcm990-baseboard.c.
can I get full patch for soc_camera.

Thanks
fengxin

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
