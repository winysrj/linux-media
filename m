Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB54fRXZ022502
	for <video4linux-list@redhat.com>; Thu, 4 Dec 2008 23:41:27 -0500
Received: from si01.xit.com.hk (si01.xit.com.hk [202.67.236.24])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB54fCPt004115
	for <video4linux-list@redhat.com>; Thu, 4 Dec 2008 23:41:13 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
	by si01.xit.com.hk (Postfix) with ESMTP id 7F72EC706F
	for <video4linux-list@redhat.com>; Fri,  5 Dec 2008 12:41:10 +0800 (HKT)
Received: from si01.xit.com.hk ([127.0.0.1])
	by localhost (si01.xit.com.hk [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CbLXbJYERvcC for <video4linux-list@redhat.com>;
	Fri,  5 Dec 2008 12:41:09 +0800 (HKT)
Received: from [192.168.128.30] (pcd255137.netvigator.com [203.218.45.137])
	by si01.xit.com.hk (Postfix) with ESMTP id 88EDFC7069
	for <video4linux-list@redhat.com>; Fri,  5 Dec 2008 12:41:09 +0800 (HKT)
Message-ID: <4938B0FE.3010108@xit.com.hk>
Date: Fri, 05 Dec 2008 12:41:34 +0800
From: Chris Ruehl <v4l@xit.com.hk>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: HVR-4000 need to switch 19/14V
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

Dear All,

I run a HVR 4000 in Hong Kong and try to make it run with ALIGA2 on a 
'so called' cheap Sat in my rented flat.
Problem:
When I run the scan <myaligaconfig> no result come out.
I double check with my dreambox - its working
different between dreambox<>HVR4000 dreambox set 19V on the LNB HVR only 
17,8V.

I google around a bit and found a thread where someone set a extra bit 
in the registry (win32) to make the
card set to 19/14V.

Can someone give me a hint which register affected here on the cx88??? 
code -  to make it possible for me
testing/patching.

thank  you.
Chris

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
