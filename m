Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBN901CP023284
	for <video4linux-list@redhat.com>; Tue, 23 Dec 2008 04:00:01 -0500
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.174])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBN8w6MF032449
	for <video4linux-list@redhat.com>; Tue, 23 Dec 2008 03:58:06 -0500
Received: by wf-out-1314.google.com with SMTP id 25so2441504wfc.6
	for <video4linux-list@redhat.com>; Tue, 23 Dec 2008 00:58:06 -0800 (PST)
Message-ID: <5d5443650812230058j1d316ef6w9397437798a3984a@mail.gmail.com>
Date: Tue, 23 Dec 2008 14:28:06 +0530
From: "Trilok Soni" <soni.trilok@gmail.com>
To: "Hiremath, Vaibhav" <hvaibhav@ti.com>
In-Reply-To: <19F8576C6E063C45BE387C64729E739403E90E768D@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5d5443650812070140w423d6fe9ua2f0ff9d2974bbd7@mail.gmail.com>
	<19F8576C6E063C45BE387C64729E739403E90E768D@dbde02.ent.ti.com>
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

Hi Vaibhav,

>
>
> [Hiremath, Vaibhav] I just had quick walk through of code and I think you may want to take look at the review comments received for TVP514x driver (Especially for I2C).
>

I will not go for smbus_read/write APIs as of now. I will look at rest
of the comments.

-- 
---Trilok Soni
http://triloksoni.wordpress.com
http://www.linkedin.com/in/triloksoni

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
