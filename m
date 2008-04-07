Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m37A6ewf004567
	for <video4linux-list@redhat.com>; Mon, 7 Apr 2008 06:06:40 -0400
Received: from mgw-mx03.nokia.com (smtp.nokia.com [192.100.122.230])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m37A6FKG018302
	for <video4linux-list@redhat.com>; Mon, 7 Apr 2008 06:06:15 -0400
Message-ID: <47F9F202.1050800@nokia.com>
Date: Mon, 07 Apr 2008 13:05:54 +0300
From: Sakari Ailus <sakari.ailus@nokia.com>
MIME-Version: 1.0
To: "ext Shah, Hardik" <hardik.shah@ti.com>
References: <010C7BAE6783F34D9AC336EE5A01A08805B4EF78@dbde01.ent.ti.com>
In-Reply-To: <010C7BAE6783F34D9AC336EE5A01A08805B4EF78@dbde01.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: v4l2-int-device
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

ext Shah, Hardik wrote:
> Hi, Is there any sample driver available based on v4l2-int-device
> interface.  I found tcm825x.c based on v4l2-int-device interface but
> it is a slave driver.  Any one having master driver as sample and
> also the application.

Hello,

OMAP 2 camera camera driver (drivers/media/video/omap24xxcam.c) on 
linux-omap tree is a v4l2-int-device master.

<URL:http://www.muru.com/linux/omap/>

-- 
Sakari Ailus
sakari.ailus@nokia.com

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
