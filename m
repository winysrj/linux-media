Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4MDP4tB006135
	for <video4linux-list@redhat.com>; Thu, 22 May 2008 09:25:05 -0400
Received: from ciao.gmane.org (main.gmane.org [80.91.229.2])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4MDOqWD022965
	for <video4linux-list@redhat.com>; Thu, 22 May 2008 09:24:53 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1JzAmm-0007dq-CE
	for video4linux-list@redhat.com; Thu, 22 May 2008 13:24:48 +0000
Received: from 82-135-208-232.static.zebra.lt ([82.135.208.232])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <video4linux-list@redhat.com>; Thu, 22 May 2008 13:24:48 +0000
Received: from augulis.darius by 82-135-208-232.static.zebra.lt with local
	(Gmexim 0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <video4linux-list@redhat.com>; Thu, 22 May 2008 13:24:48 +0000
To: video4linux-list@redhat.com
From: Darius <augulis.darius@gmail.com>
Date: Thu, 22 May 2008 16:19:15 +0300
Message-ID: <g13s6k$a2c$1@ger.gmane.org>
References: <g09j17$3m9$1@ger.gmane.org>	<Pine.LNX.4.64.0805122030310.5526@axis700.grange>	<g0bjtj$b0d$1@ger.gmane.org>	<Pine.LNX.4.64.0805132212530.4988@axis700.grange>	<g0hhpt$jfp$1@ger.gmane.org>
	<Pine.LNX.4.64.0805152121210.14292@axis700.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-13; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <Pine.LNX.4.64.0805152121210.14292@axis700.grange>
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

Guennadi Liakhovetski wrote:
> On Thu, 15 May 2008, Darius wrote:
> 
>> Guennadi, can you please describe more detailed struct soc_camera_device
>> structure? All these members xmin, ymin, etc...
> 
> The main point is, that the unit is 1 pixel. The rest is pretty much 
> implementation specific. Just see your datasheet and select some natural 
> values for allowed frame sizes and location. As the struct declaration 
> says:
> 
> 	unsigned short width;		/* Current window */
> 	unsigned short height;		/* sizes */
> 	unsigned short x_min;		/* Camera capabilities */
> 	unsigned short y_min;
> 	unsigned short x_current;	/* Current window location */
> 	unsigned short y_current;
> 

where they are used? as I can see, in *_try_fmt_cap() and *__set_fmt_cap() you are using hard coded constants.
in video_probe you are setting this structure, but these values are never used?

> The vales below are again min and max allowed values.
> 
> 	unsigned short width_min;
> 	unsigned short width_max;
> 	unsigned short height_min;
> 	unsigned short height_max;

should they be used in *_try_fmt_cap() function to inform v4l2 driver about sensor posibilities?
now in *_try_fmt_cap() you are using hard coded constants. values from soc_camera_device *icd struct are not used?

btw, can you tell something about frame rate setting? how to implement that? for example, I want from user space adjust frame rate (4, 15, 25, 30fps...).
Should I pass these setting to sensor driver via *_set_fmt_cap()?

Thanks,

Darius.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
