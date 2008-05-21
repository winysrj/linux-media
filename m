Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4L3Upgx031942
	for <video4linux-list@redhat.com>; Tue, 20 May 2008 23:30:51 -0400
Received: from akroyd.itverx.com.ve (akroyd.itverx.com.ve [67.205.93.243])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4L3UdHD015200
	for <video4linux-list@redhat.com>; Tue, 20 May 2008 23:30:39 -0400
Received: from trillian.ius.cc ([190.79.207.109])
	by akroyd.itverx.com.ve (8.13.8/8.13.8/Debian-3) with ESMTP id
	m4L3USa2014544
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <video4linux-list@redhat.com>; Wed, 21 May 2008 03:30:31 GMT
Received: from localhost (localhost [127.0.0.1])
	by trillian.ius.cc (8.13.8/8.13.8/Debian-3) with ESMTP id
	m4L3UMie010886
	for <video4linux-list@redhat.com>; Tue, 20 May 2008 23:00:23 -0430
From: Ernesto =?ISO-8859-1?Q?Hern=E1ndez-Novich?= <emhn@usb.ve>
To: video4linux-list@redhat.com
In-Reply-To: <48334494.9090505@verizonbusiness.com>
References: <4291817.1211318326884.JavaMail.root@mswamui-billy.atl.sa.earthlink.net>
	<48334494.9090505@verizonbusiness.com>
Content-Type: text/plain; charset=UTF-8
Date: Tue, 20 May 2008 22:56:33 -0430
Message-Id: <1211340394.25521.9.camel@trillian.ius.cc>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [SOLVED] Re: Problems building on Debian Etch
Reply-To: emhn@usb.ve
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

On Tue, 2008-05-20 at 15:37 -0600, Mark Paulus wrote:
> Actually, you can get 2.6.24 from etchnhalf...
> http://wiki.debian.org/EtchAndAHalf
> Has info on what to add to /etc/apt/sources.list

I ended up using 2.6.24 from Etch-and-a-half, and managed to build the
latest drivers without problems, and the card (GV-600) is working fine.
This is going to be a production server, and the customer wants to rely
on Debian's upgrades instead of having to rebuild kernels manually or
semi-automatically, that's the reason I was going for 2.6.18 (which is
the standard Debian Etch kernel).
-- 
Prof. Ernesto Hernández-Novich - MYS-220C
Geek by nature, Linux by choice, Debian of course.
If you can't aptitude it, it isn't useful or doesn't exist.
GPG Key Fingerprint = 438C 49A2 A8C7 E7D7 1500 C507 96D6 A3D6 2F4C 85E3

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
