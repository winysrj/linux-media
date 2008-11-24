Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAO8xrRC018087
	for <video4linux-list@redhat.com>; Mon, 24 Nov 2008 03:59:53 -0500
Received: from bear.ext.ti.com (bear.ext.ti.com [192.94.94.41])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAO8xa55017349
	for <video4linux-list@redhat.com>; Mon, 24 Nov 2008 03:59:36 -0500
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Trilok Soni <soni.trilok@gmail.com>, Hans Verkuil <hverkuil@xs4all.nl>
Date: Mon, 24 Nov 2008 14:29:16 +0530
Message-ID: <19F8576C6E063C45BE387C64729E739403E8E6804A@dbde02.ent.ti.com>
In-Reply-To: <5d5443650811240043g37402af2l4a3da662621dd1e8@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: "video4linux-list@redhat.com" <video4linux-list@redhat.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>
Subject: RE: [PATCH 2/2] TVP514x V4L int device driver support
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

Hans,

Thanks,
Vaibhav Hiremath

> -----Original Message-----
> From: linux-omap-owner@vger.kernel.org [mailto:linux-omap-
> owner@vger.kernel.org] On Behalf Of Trilok Soni
> Sent: Monday, November 24, 2008 2:13 PM
> To: Hans Verkuil
> Cc: video4linux-list@redhat.com; linux-omap@vger.kernel.org;
> davinci-linux-open-source@linux.davincidsp.com
> Subject: Re: [PATCH 2/2] TVP514x V4L int device driver support
> 
> Hi Hans,
> 
> >
> > The v4l2-int-device.h stuff should never have been added. Ditto
> for
> > parts of the soc-camera framework that duplicates v4l2-int-
> device.h. My
> > new v4l2_subdev support will replace the three methods of using
> i2c
> > devices (or similar) that are currently in use. It's exactly to
> reduce
> > the confusion that I'm working on this.
> >
> > It's been discussed before on the v4l mailinglist and the relevant
> > developers are aware of this. It's almost finished, just need to
> track
> > down a single remaining oops.
> 
> Right, I will wait for your updates.
> 
> I am planning to send omap24xxcam and ov9640 drivers (now deleted)
> available from linux-omap tree after syncing them with latest
> linux-2.6.x tree, and the whole driver and the sensor is written
> using
> v4l2-int-device framework. I am going to send it anyway, so that it
> can have some review comments.
> 
[Hiremath, Vaibhav] Is your current development accessible through linuxtv.org? Can you share it with us, so that we can have a look into it? Which driver you are migrating to new interface (which I can refer to as a sample)?
Again I would like to know, how are we handling current drivers (soc-camera and v4l2-int)?

> --
> ---Trilok Soni
> http://triloksoni.wordpress.com
> http://www.linkedin.com/in/triloksoni
> --
> To unsubscribe from this list: send the line "unsubscribe linux-
> omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
