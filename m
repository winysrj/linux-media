Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n6H4xbCt009743
	for <video4linux-list@redhat.com>; Fri, 17 Jul 2009 00:59:37 -0400
Received: from postfix.xen.seddon.ca (seddon.ca [203.209.212.18])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n6H4xL23000395
	for <video4linux-list@redhat.com>; Fri, 17 Jul 2009 00:59:24 -0400
Received: from [127.0.0.1] (unknown [172.16.100.140])
	by postfix.xen.seddon.ca (Postfix) with ESMTP id F3986C154
	for <video4linux-list@redhat.com>; Fri, 17 Jul 2009 04:59:19 +0000 (UTC)
Message-ID: <4A600529.90301@freegate.net.au>
Date: Fri, 17 Jul 2009 14:59:21 +1000
From: Solomon Sokolovsky <solomons@freegate.net.au>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Setting LOF1 and LOF2 values in LinuxTV frontend0 - KNC One
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

Usinga Redhat with dvbutils and a KNC PCI DVB-S Card.

All was fine for a long time... Now I change Satellite dishes and the 
LNB is different.

How do I set the LOF1,LOF2, Switch Setting.  Seems this needs to be 
parsed into frontend0 via frontend.h.

Currently not locking onto frequencies as has wrong setting for LNB!

Can anyone help?

Cheers
Sol

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
