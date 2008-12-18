Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBI9HMRm007167
	for <video4linux-list@redhat.com>; Thu, 18 Dec 2008 04:17:22 -0500
Received: from co203.xi-lite.net (co203.xi-lite.net [149.6.83.203])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBI9H5Ip032042
	for <video4linux-list@redhat.com>; Thu, 18 Dec 2008 04:17:05 -0500
Message-ID: <494A150F.6010602@parrot.com>
Date: Thu, 18 Dec 2008 10:17:03 +0100
From: Matthieu CASTET <matthieu.castet@parrot.com>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: soc-camera : add new flags
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

I am trying to use soc-camera for our camera IP.

Our IP allow to chose if the synchronization is done according to  ITU-R
BT601 or ITU-R BT656.
Can new flag be added to negotiate the synchronization standard between
host and sensor.

Our IP also allow to select if the data on the bus is transmitted on the
CbYCrY order or YCbYCr order.
Can new flag be added to negotiate the synchronization standard between
host and sensor.


Thanks


Matthieu

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
