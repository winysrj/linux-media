Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9UJU7F8004785
	for <video4linux-list@redhat.com>; Thu, 30 Oct 2008 15:30:07 -0400
Received: from unifiedpaging.messagenetsystems.com
	(www.digitalsignage.messagenetsystems.com [24.123.23.170] (may
	be forged))
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9UJTIWU021149
	for <video4linux-list@redhat.com>; Thu, 30 Oct 2008 15:29:19 -0400
Message-ID: <490A0B3D.70108@messagenetsystems.com>
Date: Thu, 30 Oct 2008 15:30:05 -0400
From: Robert Vincent Krakora <rob.krakora@messagenetsystems.com>
MIME-Version: 1.0
To: video4linux-list@redhat.com, geisj@messagenetsystems.com
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: 
Subject: mplayer, v4l2 and closed captioning scan lines (how do I crop the
 display image properly to get rid of these)
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

Hello,

How does one crop an mplayer output display to prevent the displaying 
all 525 NTSC scan lines?  The row 11 line 21 closed caption scan lines 
are particularly annoying.  I am using mplayer, v4l and HVR950 
(em28xx-based).  Thanks in advance.

Best Regards,

-- 
Rob Krakora
Software Engineer
MessageNet Systems
101 East Carmel Dr. Suite 105
Carmel, IN 46032
(317)566-1677 Ext. 206
(317)663-0808 Fax

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
