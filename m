Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5NDWBVm001265
	for <video4linux-list@redhat.com>; Mon, 23 Jun 2008 09:32:11 -0400
Received: from vds19s01.yellis.net (ns1019.yellis.net [213.246.41.159])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5NDVWG2017142
	for <video4linux-list@redhat.com>; Mon, 23 Jun 2008 09:31:33 -0400
Received: from goliath.anevia.com (cac94-10-88-170-236-224.fbx.proxad.net
	[88.170.236.224])
	by vds19s01.yellis.net (Postfix) with ESMTP id 175F82FA8A3
	for <video4linux-list@redhat.com>;
	Mon, 23 Jun 2008 15:31:42 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by goliath.anevia.com (Postfix) with ESMTP id 83E801300047
	for <video4linux-list@redhat.com>;
	Mon, 23 Jun 2008 15:31:31 +0200 (CEST)
Received: from goliath.anevia.com ([127.0.0.1])
	by localhost (goliath.anevia.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yq57I2nxoG2R for <video4linux-list@redhat.com>;
	Mon, 23 Jun 2008 15:31:25 +0200 (CEST)
Received: from [10.0.1.25] (fcand.anevia.com [10.0.1.25])
	by goliath.anevia.com (Postfix) with ESMTP id ABD991300042
	for <video4linux-list@redhat.com>;
	Mon, 23 Jun 2008 15:31:25 +0200 (CEST)
Message-ID: <485FA5A8.9000103@anevia.com>
Date: Mon, 23 Jun 2008 15:31:20 +0200
From: Frederic CAND <frederic.cand@anevia.com>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: [HVR 1300] secam bg
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

dear all
I could not make secam b/g work on my hvr 1300
ioctl returns -1, error "Invalid argument"
I know my card is able to handle this tv norm since it's working fine
(video and sound are ok) under windows
anyone could confirm it isn't working ? any idea why, and how to make it 
work ?
-- 
CAND Frederic
Product Manager
ANEVIA

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
