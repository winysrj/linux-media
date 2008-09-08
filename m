Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m88Gmal4014162
	for <video4linux-list@redhat.com>; Mon, 8 Sep 2008 12:48:37 -0400
Received: from mgw-mx09.nokia.com (smtp.nokia.com [192.100.105.134])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m88GmQKv021827
	for <video4linux-list@redhat.com>; Mon, 8 Sep 2008 12:48:26 -0400
Message-ID: <48C55737.4080804@nokia.com>
Date: Mon, 08 Sep 2008 19:47:51 +0300
From: Sakari Ailus <sakari.ailus@nokia.com>
MIME-Version: 1.0
To: Linux and Kernel Video <video4linux-list@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Toivonen Tuukka Olli Artturi <tuukka.o.toivonen@nokia.com>,
	"Zutshi Vimarsh \(Nokia-D-MSW/Helsinki\)" <vimarsh.zutshi@nokia.com>
Subject: [PATCH 0/7] V4L changes for OMAP 3 camera
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

This patchset extends V4L2 interface and especially v4l2-int-if 
somewhat. The new functionality is there to support the OMAP 3 camera 
driver.

Our aim is to get these patches into v4l-dvb tree and further to Linus' 
tree. The OMAP 3 camera driver, which is dependent on these patches, is 
targeted to linux-omap tree through linux-omap@vger.kernel.org mailing 
list. It is unlikely that it would be useful (or even compile) without 
many of the changes in linux-omap tree.

The patches apply against v4l-dvb, Linus' tree or linux-omap.

Comments will be appreciated. :-)

Regards,

-- 
Sakari Ailus
sakari.ailus@nokia.com

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
