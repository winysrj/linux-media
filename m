Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m38LnZJX022071
	for <video4linux-list@redhat.com>; Tue, 8 Apr 2008 17:49:35 -0400
Received: from ciao.gmane.org (main.gmane.org [80.91.229.2])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m38LnKNT029169
	for <video4linux-list@redhat.com>; Tue, 8 Apr 2008 17:49:21 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1JjLgq-0008Q3-7k
	for video4linux-list@redhat.com; Tue, 08 Apr 2008 21:49:16 +0000
Received: from c9346dce.virtua.com.br ([201.52.109.206])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <video4linux-list@redhat.com>; Tue, 08 Apr 2008 21:49:16 +0000
Received: from fragabr by c9346dce.virtua.com.br with local (Gmexim 0.1
	(Debian)) id 1AlnuQ-0007hv-00
	for <video4linux-list@redhat.com>; Tue, 08 Apr 2008 21:49:16 +0000
To: video4linux-list@redhat.com
From: =?ISO-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>
Date: Tue, 8 Apr 2008 17:05:32 -0300
Message-ID: <20080408170532.360ba496@tux.abusar.org.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: Linux Driver Project status report and V4L
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

http://lwn.net/Articles/276973/

	An interesting excerpt:

"As for video input devices, there is an active Linux developer
community in this area, but they seem to be hampered by a different
development model (Mecurial trees outside of the main kernel source),
and a lack of full-time developers, not to mention a high degree of
inter-personal conflicts that seem quite strange to outsiders.  Support
for a large majority of these devices is slowly trickling into the main
kernel tree, the most important being the USB Video class driver, which
will support almost all new USB video devices in the future, thereby
removing the major problem most users will face when purchasing a new
video device".

	***

	I agree. With the future inclusion of USB Video class driver,
V4L will get a boost by supporting many yet not officialy supported
devices (lots of webcams for instance). Of course they bring new
challenges, but it will be a good thing, I think.

	Thanks everybody for the great work.

-- 
Linux 2.6.24: Arr Matey! A Hairy Bilge Rat!
http://u-br.net


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
