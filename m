Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx03.extmail.prod.ext.phx2.redhat.com
	[10.5.110.7])
	by int-mx05.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id n7KEqBkx019760
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <video4linux-list@redhat.com>; Thu, 20 Aug 2009 10:52:11 -0400
Received: from qw-out-2122.google.com (qw-out-2122.google.com [74.125.92.24])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n7KEpwGQ028482
	for <video4linux-list@redhat.com>; Thu, 20 Aug 2009 10:51:58 -0400
Received: by qw-out-2122.google.com with SMTP id 5so1470667qwi.39
	for <video4linux-list@redhat.com>; Thu, 20 Aug 2009 07:51:58 -0700 (PDT)
From: "Nilo Roberto C Paim" <nilopaim@gmail.com>
To: <video4linux-list@redhat.com>
Date: Thu, 20 Aug 2009 11:51:42 -0300
Message-ID: <002601ca21a5$c0cc10c0$42643240$@com>
MIME-Version: 1.0
Content-Language: pt-br
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Subject: How to detect USB camera disconnection?
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

 

Nilo Roberto C Paim

nilopaim@gmail.com

TinyCOBOL - Equipe de Desenvolvimento 

Porto Alegre - RS - Brasil

 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
