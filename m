Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9VJQ01I007736
	for <video4linux-list@redhat.com>; Fri, 31 Oct 2008 15:26:00 -0400
Received: from QMTA01.emeryville.ca.mail.comcast.net
	(qmta01.emeryville.ca.mail.comcast.net [76.96.30.16])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9VJPdgg006524
	for <video4linux-list@redhat.com>; Fri, 31 Oct 2008 15:25:40 -0400
Message-ID: <490B5BB9.6090209@personnelware.com>
Date: Fri, 31 Oct 2008 14:25:45 -0500
From: Carl Karsten <carl@personnelware.com>
MIME-Version: 1.0
To: video4linux-list@redhat.com
References: <490A09EA.2080300@personnelware.com>
In-Reply-To: <490A09EA.2080300@personnelware.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: fixed: v4l-dvb/v4l/av7110.c:698: error: implicit declaration of
 function 'swahw32'
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

(02:18:13 PM) CarlFK: hg clone http://linuxtv.org/hg/v4l-dvb a few days ago.
(02:21:09 PM) mkrufky: hg pull -u
(02:24:03 PM) CarlFK: thanks - looks like it fixed the problem I was having a
few days ago
(02:24:15 PM) mkrufky: :-) you're welcome

Carl K

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
