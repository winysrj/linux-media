Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m457a76Z003708
	for <video4linux-list@redhat.com>; Mon, 5 May 2008 03:36:07 -0400
Received: from moutng.kundenserver.de (moutng.kundenserver.de
	[212.227.126.188])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m457ZrEU009147
	for <video4linux-list@redhat.com>; Mon, 5 May 2008 03:35:54 -0400
From: Arne Caspari <arne@unicap-imaging.org>
To: video4linux-list@redhat.com
Content-Type: text/plain
Date: Mon, 05 May 2008 09:35:47 +0200
Message-Id: <1209972947.7502.0.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: RAW/Bayer format FOURCCs
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

I am looking for the correct FOURCC to use for a RAW Bayer format: RGGB
16 bit. 

In the v4l2 specification, there is V4L2_PIX_FMT_SBGGR8 ( 'BA81' ) for
BGGR 8 bit and V4L2_PIX_FMT_SBGGR16 ( 'BA82' ) for BGGR 16 bit. I do not
really see a pattern in the FOURCC assignment here. Does anybody know
what the correct FOURCC should look like? 


Thanks, 

-- 
Arne Caspari    --    unicap-imaging

http://www.unicap-imaging.org

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
