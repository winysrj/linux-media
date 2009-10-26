Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx10.extmail.prod.ext.phx2.redhat.com
	[10.5.110.14])
	by int-mx05.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id n9QCKmRj029872
	for <video4linux-list@redhat.com>; Mon, 26 Oct 2009 08:20:48 -0400
Received: from fileserv.snetsys.co.za (ns1.netsys.co.za [196.211.62.234])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n9QCKVJE013742
	for <video4linux-list@redhat.com>; Mon, 26 Oct 2009 08:20:36 -0400
Received: from [192.168.51.46] (nsdv64.snetsys.co.za [192.168.51.46])
	(authenticated bits=0)
	by fileserv.snetsys.co.za (8.14.2/8.14.2) with ESMTP id n9QCKRmr024104
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <video4linux-list@redhat.com>; Mon, 26 Oct 2009 14:20:28 +0200
Message-ID: <4AE5940B.3060409@netsys.co.za>
Date: Mon, 26 Oct 2009 12:20:27 +0000
From: Tiaan Wessels <tiaan@netsys.co.za>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: v4l2 programming question
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
I have a leadtek winfast 2000 tv tuner card. I have however not attached 
an antenna to it but a CCTV camera. When using the s/w that shipped with 
the card under Windows XP I can see the CCTV feed when selecting CVBS as 
the input source (as opposed to S-Video or one of the TV channels). I am 
writing a program under Linux with V4L2 to grab the frames from the CCTV 
camera but only get 'snow' as expected when no antenna is connected to 
the tuner. Can someone please point me to the correct ioctl to use to 
get the CCTV input ?
Thanks
-- 
Tiaan Wessels
Netsys International
Tel: +27 (0)12 349-2056 (Business)
+27 (0)12 349-2757 (Facsimile)
E-mail: tiaan@netsys.co.za

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
