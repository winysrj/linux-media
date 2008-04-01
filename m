Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m31M50we003459
	for <video4linux-list@redhat.com>; Tue, 1 Apr 2008 18:05:00 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m31M4he9025538
	for <video4linux-list@redhat.com>; Tue, 1 Apr 2008 18:04:43 -0400
Date: Wed, 2 Apr 2008 00:04:40 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: =?GB2312?B?t+v2zg==?= <fengxin215@gmail.com>
In-Reply-To: <998e4a820804010143w79ff1513x9ba0945576cfad9a@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0804020000590.10163@axis700.grange>
References: <998e4a820804010143w79ff1513x9ba0945576cfad9a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=GB2312
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

On Tue, 1 Apr 2008, 結�� wrote:

> I use a driver that is "soc_camera V4L2 interface for directly
> connected cameras".but I have some problems:
> 1、is this driver for linux-2.6.24?
> 2、I want to know how can I get arch/arm/mach-pxa/devices.c.

Best just clone the v4l-dvb/devel tree, it contains the newest state of 
the driver.

> 3、the function mt9v022_probe(struct i2c_client *client) in mt9v022.c
> does not execute,why?

As for every (new style) i2c driver, you need to register them from your 
platform code. See arch/arm/mach-pxa/pcm990-baseboard.c and look for i2c 
devices there, specifically for mt9v022, if this is what you need.

Thanks
Guennadi
---
Guennadi Liakhovetski

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
