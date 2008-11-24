Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAO8hfl7012045
	for <video4linux-list@redhat.com>; Mon, 24 Nov 2008 03:43:41 -0500
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.175])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAO8fZFm010414
	for <video4linux-list@redhat.com>; Mon, 24 Nov 2008 03:43:29 -0500
Received: by wf-out-1314.google.com with SMTP id 25so2064151wfc.6
	for <video4linux-list@redhat.com>; Mon, 24 Nov 2008 00:43:29 -0800 (PST)
Message-ID: <5d5443650811240043g37402af2l4a3da662621dd1e8@mail.gmail.com>
Date: Mon, 24 Nov 2008 14:13:29 +0530
From: "Trilok Soni" <soni.trilok@gmail.com>
To: "Hans Verkuil" <hverkuil@xs4all.nl>
In-Reply-To: <200811240904.12758.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <hvaibhav@ti.com> <200811232300.40530.hverkuil@xs4all.nl>
	<5d5443650811232216x6c9a77a4p2945f87e1ab65a67@mail.gmail.com>
	<200811240904.12758.hverkuil@xs4all.nl>
Cc: video4linux-list@redhat.com, linux-omap@vger.kernel.org,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>
Subject: Re: [PATCH 2/2] TVP514x V4L int device driver support
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

Hi Hans,

>
> The v4l2-int-device.h stuff should never have been added. Ditto for
> parts of the soc-camera framework that duplicates v4l2-int-device.h. My
> new v4l2_subdev support will replace the three methods of using i2c
> devices (or similar) that are currently in use. It's exactly to reduce
> the confusion that I'm working on this.
>
> It's been discussed before on the v4l mailinglist and the relevant
> developers are aware of this. It's almost finished, just need to track
> down a single remaining oops.

Right, I will wait for your updates.

I am planning to send omap24xxcam and ov9640 drivers (now deleted)
available from linux-omap tree after syncing them with latest
linux-2.6.x tree, and the whole driver and the sensor is written using
v4l2-int-device framework. I am going to send it anyway, so that it
can have some review comments.

-- 
---Trilok Soni
http://triloksoni.wordpress.com
http://www.linkedin.com/in/triloksoni

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
