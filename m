Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4FJddR6020313
	for <video4linux-list@redhat.com>; Thu, 15 May 2008 15:39:39 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m4FJdQWp022751
	for <video4linux-list@redhat.com>; Thu, 15 May 2008 15:39:27 -0400
Date: Thu, 15 May 2008 21:39:18 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Darius <augulis.darius@gmail.com>
In-Reply-To: <g0hhpt$jfp$1@ger.gmane.org>
Message-ID: <Pine.LNX.4.64.0805152121210.14292@axis700.grange>
References: <g09j17$3m9$1@ger.gmane.org>
	<Pine.LNX.4.64.0805122030310.5526@axis700.grange>
	<g0bjtj$b0d$1@ger.gmane.org>
	<Pine.LNX.4.64.0805132212530.4988@axis700.grange>
	<g0hhpt$jfp$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com
Subject: Re: question about SoC Camera driver (Micron)
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

On Thu, 15 May 2008, Darius wrote:

> Guennadi, can you please describe more detailed struct soc_camera_device
> structure? All these members xmin, ymin, etc...

The main point is, that the unit is 1 pixel. The rest is pretty much 
implementation specific. Just see your datasheet and select some natural 
values for allowed frame sizes and location. As the struct declaration 
says:

	unsigned short width;		/* Current window */
	unsigned short height;		/* sizes */
	unsigned short x_min;		/* Camera capabilities */
	unsigned short y_min;
	unsigned short x_current;	/* Current window location */
	unsigned short y_current;

The vales below are again min and max allowed values.

	unsigned short width_min;
	unsigned short width_max;
	unsigned short height_min;
	unsigned short height_max;

This is just to skip a few lines at the top, in case they are always 
corrupted, as was the case with Micron cameras. Soon there should be ab 
extra x_skip_left parameter.

	unsigned short y_skip_top;	/* Lines to skip at the top */

These are current gain and exposure values again. I selected them scaled 
to some more or less natural for humans ranges. See arrays of struct 
v4l2_queryctrl in mt9m001.c and mt9v022.c for examples

	unsigned short gain;
	unsigned short exposure;

> Also soc_camera_data_format structure has member depht. Should this member fit
> sensor bus bit count or pixel format depht in videodev2.h?
> Because most pixel formats are 16 bit and camera sensor interface in most
> cases is 8 bit.

This is pixel format bit-depth, as provided by the sensor.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
