Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m82ArJ1p003937
	for <video4linux-list@redhat.com>; Tue, 2 Sep 2008 06:53:20 -0400
Received: from smtp-vbr9.xs4all.nl (smtp-vbr9.xs4all.nl [194.109.24.29])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m82Ar5RW015754
	for <video4linux-list@redhat.com>; Tue, 2 Sep 2008 06:53:06 -0400
Message-ID: <20191.62.70.2.252.1220352781.squirrel@webmail.xs4all.nl>
Date: Tue, 2 Sep 2008 12:53:01 +0200 (CEST)
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Sakari Ailus" <sakari.ailus@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
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

> ext Hans Verkuil wrote:
>> The diff for the Makefile shows the presence of OMAP2 drivers
>> (omap24xxcam.o and omap24xxcam-dma.o), yet these drivers are not
>> present in the master v4l-dvb repository. Why not submit these drivers
>> as well? It would be nice to have the full set. Either that or redo the
>> Kconfig and Makefile patches against the v4l-dvb master repository
>> since they currently do not apply cleanly.
>
> The patches are against the linux-omap tree. The reason they're being
> posted here is mostly for review since people understand more V4L here
> than on linux-omap list. ;)

Is the omap tree also being merged with the mainline kernel? Or is it
meant to be kept separate from the kernel?

Regards,

       Hans

>
> <URL:http://www.muru.com/linux/omap/README_OMAP_GIT>
>
> The other drivers are already part of linux-omap tree.
>
> Regards,
>
> --
> Sakari Ailus
> sakari.ailus@nokia.com
>


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
