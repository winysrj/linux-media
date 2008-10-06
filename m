Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m96B8ICK002921
	for <video4linux-list@redhat.com>; Mon, 6 Oct 2008 07:08:18 -0400
Received: from mgw-mx09.nokia.com (smtp.nokia.com [192.100.105.134])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m96B87NZ007920
	for <video4linux-list@redhat.com>; Mon, 6 Oct 2008 07:08:08 -0400
Message-ID: <48E9F178.50507@nokia.com>
Date: Mon, 06 Oct 2008 14:07:36 +0300
From: Sakari Ailus <sakari.ailus@nokia.com>
MIME-Version: 1.0
To: Linux and Kernel Video <video4linux-list@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "Zutshi Vimarsh \(Nokia-D-MSW/Helsinki\)" <vimarsh.zutshi@nokia.com>,
	Toivonen Tuukka Olli Artturi <tuukka.o.toivonen@nokia.com>,
	"Nagalla, Hari" <hnagalla@ti.com>
Subject: [PATCH 0/6] V4L changes for OMAP 3 camera, try 2
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

Hi,

I've made some changes to the patchset I sent some time ago.

As suggested by Laurent Pinchart, VIDIOC_G_PRIV_MEM is no more. 
According to suggestion from Hans, I have also added more comments to 
the patch that changes how vidioc_int_s_power works.

The patches apply against v4l-dvb, Linus' tree or linux-omap.

Regards,

-- 
Sakari Ailus
sakari.ailus@nokia.com


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
