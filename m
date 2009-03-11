Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n2BKPiDE011275
	for <video4linux-list@redhat.com>; Wed, 11 Mar 2009 16:25:44 -0400
Received: from insvr08.insite.com.br (insvr08.insite.com.br [66.135.42.188])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n2BKPLat026809
	for <video4linux-list@redhat.com>; Wed, 11 Mar 2009 16:25:21 -0400
Received: from sk.insite.com.br (sk.insite.com.br [66.135.32.93])
	by insvr08.insite.com.br (Postfix) with ESMTP id B628015E807B
	for <video4linux-list@redhat.com>; Wed, 11 Mar 2009 17:25:20 -0300 (BRT)
Received: from [201.82.105.195] (port=7491 helo=juba.localnet)
	by sk.insite.com.br with esmtps (TLSv1:AES256-SHA:256) (Exim 4.69)
	(envelope-from <diniz@wimobilis.com.br>) id 1LhUzQ-0004Rt-86
	for video4linux-list@redhat.com; Wed, 11 Mar 2009 17:25:20 -0300
From: Rafael Diniz <diniz@wimobilis.com.br>
To: video4linux-list@redhat.com
Date: Wed, 11 Mar 2009 17:25:30 -0300
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903111725.30972.diniz@wimobilis.com.br>
Subject: loopback dvb device
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

Hello people,
I'd like to use a software called redbutton to extract the Data Carousel of a 
Transport Stream file. But it only works w/ a real DVB tuner.
Are there any way to create a DVB loopback device like the v4l vloopback 
software that plays a TS file?

Thanks,
Rafael Diniz

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
