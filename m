Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB1Cq2Fj027565
	for <video4linux-list@redhat.com>; Mon, 1 Dec 2008 07:52:03 -0500
Received: from yx-out-2324.google.com (yx-out-2324.google.com [74.125.44.30])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB1CplC1008334
	for <video4linux-list@redhat.com>; Mon, 1 Dec 2008 07:51:47 -0500
Received: by yx-out-2324.google.com with SMTP id 31so894020yxl.81
	for <video4linux-list@redhat.com>; Mon, 01 Dec 2008 04:51:47 -0800 (PST)
Message-ID: <5d5443650812010451o321e76e6s2681b3486e7c3c24@mail.gmail.com>
Date: Mon, 1 Dec 2008 18:21:46 +0530
From: "Trilok Soni" <soni.trilok@gmail.com>
To: "Hans Verkuil" <hverkuil@xs4all.nl>
In-Reply-To: <200812011334.41306.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5d5443650811280216r450c6f02v3fb0db2e1580594a@mail.gmail.com>
	<200812011334.41306.hverkuil@xs4all.nl>
Cc: v4l <video4linux-list@redhat.com>,
	"linux-omap@vger.kernel.org Mailing List" <linux-omap@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@nokia.com>
Subject: Re: [PATCH] Add Omnivision OV9640 sensor support.
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
> I reviewed this sensor driver and it's fine except for one thing:
> setting the default registers from outside the driver. This is a really
> bad idea. I2C drivers should be self-contained. I've made the same
> comment in the tvp514x driver review which I'm copying below (with some
> small edits):

I knew that you are going to comment on that, and I agree on those
points. I will pull in that register initialization to the driver.

>
> I noticed that the tcm825x.c driver takes exactly the same wrong
> approach, BTW.

Yes, because ov9640 was the first sensor driver on OMAP2 ;)

-- 
---Trilok Soni
http://triloksoni.wordpress.com
http://www.linkedin.com/in/triloksoni

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
