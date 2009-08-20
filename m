Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx05.extmail.prod.ext.phx2.redhat.com
	[10.5.110.9])
	by int-mx08.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id n7KGsr10014178
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <video4linux-list@redhat.com>; Thu, 20 Aug 2009 12:54:53 -0400
Received: from qw-out-2122.google.com (qw-out-2122.google.com [74.125.92.24])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n7KGsfRD029810
	for <video4linux-list@redhat.com>; Thu, 20 Aug 2009 12:54:41 -0400
Received: by qw-out-2122.google.com with SMTP id 5so16215qwi.39
	for <video4linux-list@redhat.com>; Thu, 20 Aug 2009 09:54:41 -0700 (PDT)
From: "Nilo Roberto C Paim" <nilopaim@gmail.com>
To: <video4linux-list@redhat.com>
Date: Thu, 20 Aug 2009 13:54:26 -0300
Message-ID: <004a01ca21b6$e3cabe80$ab603b80$@com>
MIME-Version: 1.0
Content-Language: pt-br
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Subject: ENC: How to detect USB camera disconnection?
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

Hi, all.

 

I've a Vimicro USB cam that I'm constantly pooling for taking snapshots
using an application made by me. How can I programmatically detect when the
cam is disconnected?

 

It seems to me that V4L "thinks" that the cam is still there, even with the
cable disconnected.

 

Any hints?

 

--- >  I'd forgot to say: the driver I'm using is gspca, last version. Works
like a charm. My problem is related to cable's cam disconnected.

 

 

Nilo Roberto C Paim

nilopaim@gmail.com

TinyCOBOL - Equipe de Desenvolvimento 

Porto Alegre - RS - Brasil

 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
