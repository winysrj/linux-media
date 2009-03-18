Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n2IBLaAr017745
	for <video4linux-list@redhat.com>; Wed, 18 Mar 2009 07:21:36 -0400
Received: from web23207.mail.ird.yahoo.com (web23207.mail.ird.yahoo.com
	[217.146.189.62])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id n2IBLFAK001522
	for <video4linux-list@redhat.com>; Wed, 18 Mar 2009 07:21:15 -0400
Message-ID: <86003.81918.qm@web23207.mail.ird.yahoo.com>
Date: Wed, 18 Mar 2009 11:21:15 +0000 (GMT)
From: Intercambio Archivos <carloscasbas@yahoo.es>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Subject: Bad capture sequence
Reply-To: carloscasbas@yahoo.es
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

I have got a problem with V4L2 API and em28xx driver.
I use streaming I/O and memory mapping buffers. My application use a set of=
 4 buffers. In dequeued buffers, sequence number in v4l2_buffer structure (=
captured) is the same in 8 consecutive=A0 buffers.
If I use a 8 buffers set, the sequence number is the same in 16 consecutive=
 buffers,
If I use a 16 buffers set, the sequence number is the same in 32 consecutiv=
e buffers, etc.

bytesused number in v4l2_buffer structure is always the same.

Thanks
Carlos.
=0A=0A=0A      
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
