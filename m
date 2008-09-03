Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m835eM0T025322
	for <video4linux-list@redhat.com>; Wed, 3 Sep 2008 01:40:22 -0400
Received: from mgw-mx03.nokia.com (smtp.nokia.com [192.100.122.230])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m835eBvF030400
	for <video4linux-list@redhat.com>; Wed, 3 Sep 2008 01:40:11 -0400
Message-ID: <48BE237B.2040001@nokia.com>
Date: Wed, 03 Sep 2008 08:41:15 +0300
From: Sakari Ailus <sakari.ailus@nokia.com>
MIME-Version: 1.0
To: ext Hans Verkuil <hverkuil@xs4all.nl>
References: <20191.62.70.2.252.1220352781.squirrel@webmail.xs4all.nl>
In-Reply-To: <20191.62.70.2.252.1220352781.squirrel@webmail.xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH 12/15] OMAP3 camera driver: Add Sensor and Lens Driver.
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

ext Hans Verkuil wrote:
>> ext Hans Verkuil wrote:
>>> The diff for the Makefile shows the presence of OMAP2 drivers
>>> (omap24xxcam.o and omap24xxcam-dma.o), yet these drivers are not
>>> present in the master v4l-dvb repository. Why not submit these drivers
>>> as well? It would be nice to have the full set. Either that or redo the
>>> Kconfig and Makefile patches against the v4l-dvb master repository
>>> since they currently do not apply cleanly.
>> The patches are against the linux-omap tree. The reason they're being
>> posted here is mostly for review since people understand more V4L here
>> than on linux-omap list. ;)
> 
> Is the omap tree also being merged with the mainline kernel? Or is it
> meant to be kept separate from the kernel?

I guess it's not meant to be kept separate.

-- 
Sakari Ailus
sakari.ailus@nokia.com

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
