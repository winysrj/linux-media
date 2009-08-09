Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n7A0W4C1030812
	for <video4linux-list@redhat.com>; Sun, 9 Aug 2009 20:32:04 -0400
Received: from mho-01-ewr.mailhop.org (mho-01-ewr.mailhop.org [204.13.248.71])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n7A0VnQJ005149
	for <video4linux-list@redhat.com>; Sun, 9 Aug 2009 20:31:50 -0400
Received: from c-24-63-249-206.hsd1.vt.comcast.net ([24.63.249.206]
	helo=homer.edgehp.net)
	by mho-01-ewr.mailhop.org with esmtpsa (TLSv1:CAMELLIA256-SHA:256)
	(Exim 4.68) (envelope-from <DEPontius@edgehp.net>)
	id 1MaInl-000LMl-Ly
	for video4linux-list@redhat.com; Mon, 10 Aug 2009 00:31:49 +0000
Received: from [192.168.154.40] (anastasia.edgehp.net [192.168.154.40])
	by homer.edgehp.net (Postfix) with ESMTP id 2391E3AAF2
	for <video4linux-list@redhat.com>; Sun,  9 Aug 2009 16:56:37 -0400 (EDT)
Message-ID: <4A7F3813.3050101@edgehp.net>
Date: Sun, 09 Aug 2009 16:56:51 -0400
From: Dale Pontius <DEPontius@edgehp.net>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: Status of cx18 drivers, mercurial vs in-kernel
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

I've been running the cx18 drivers out of mercurial since getting my
HVR-1600 running, almost a year ago.  As I see things, the driver is
pretty mature now, and in fact I see commits for cx18 in 2.6.31 that are
some of the last I saw going into the "regular" driver in mercurial.
(I'm not counting the diagnostic work that has been going on in the last
month or two, for one particular user.)

Is it reasonable to go with the in-kernel cx18 driver when 2.6.31 goes
stable, or is there still significant value with sticking with mercurial?

Dale Pontius

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
