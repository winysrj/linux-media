Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB36p4pS020202
	for <video4linux-list@redhat.com>; Wed, 3 Dec 2008 01:51:04 -0500
Received: from qb-out-0506.google.com (qb-out-0506.google.com [72.14.204.232])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB36mU9d002976
	for <video4linux-list@redhat.com>; Wed, 3 Dec 2008 01:48:30 -0500
Received: by qb-out-0506.google.com with SMTP id e12so5832548qbe.1
	for <video4linux-list@redhat.com>; Tue, 02 Dec 2008 22:48:30 -0800 (PST)
Message-ID: <5d5443650812022248p28f42ce4n513dceb18adadeab@mail.gmail.com>
Date: Wed, 3 Dec 2008 12:18:29 +0530
From: "Trilok Soni" <soni.trilok@gmail.com>
To: "Hiremath, Vaibhav" <hvaibhav@ti.com>
In-Reply-To: <19F8576C6E063C45BE387C64729E739403E90E6D27@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200812011357.09474.hverkuil@xs4all.nl>
	<19F8576C6E063C45BE387C64729E739403E90E6D27@dbde02.ent.ti.com>
Cc: Sakari Ailus <sakari.ailus@nokia.com>,
	"linux-omap@vger.kernel.org Mailing List" <linux-omap@vger.kernel.org>,
	"video4linux-list@redhat.com" <video4linux-list@redhat.com>
Subject: Re: [PATCH] Add OMAP2 camera driver
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
> [Hiremath, Vaibhav] How about making a separate directory for OMAP, which will contain OMAP1/2/3 specific drivers?
>

I really don't want omap directory for OMAP1 and OMAP2 atleast. Even
in my next patches for OMAP1 camera controller I am going to  remove
"omap/" directory existing on linux-omap git history. For omap1 it is
just two files camera_core.c and omap16xxcam.c, so no need of
directory here. Even going further I am going to merge camera_core and
omap16xxcam into one file, as I don't see code for any other omap1
platform like omap15xxcam.

I don't know about OMAP3 ISP code, some one from TI should refresh
those patches.


-- 
---Trilok Soni
http://triloksoni.wordpress.com
http://www.linkedin.com/in/triloksoni

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
