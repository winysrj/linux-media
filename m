Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBF4fjM3005119
	for <video4linux-list@redhat.com>; Sun, 14 Dec 2008 23:41:45 -0500
Received: from comal.ext.ti.com (comal.ext.ti.com [198.47.26.152])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBF4fSxl018958
	for <video4linux-list@redhat.com>; Sun, 14 Dec 2008 23:41:29 -0500
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Devin Heitmueller <devin.heitmueller@gmail.com>, V4L
	<video4linux-list@redhat.com>
Date: Mon, 15 Dec 2008 10:11:17 +0530
Message-ID: <19F8576C6E063C45BE387C64729E739403ECC737F6@dbde02.ent.ti.com>
In-Reply-To: <412bdbff0812141701j3ee744daq49f47da9150124f4@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: 
Subject: RE: Template for a new driver
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



Thanks,
Vaibhav Hiremath

> -----Original Message-----
> From: video4linux-list-bounces@redhat.com [mailto:video4linux-list-
> bounces@redhat.com] On Behalf Of Devin Heitmueller
> Sent: Monday, December 15, 2008 6:31 AM
> To: V4L
> Subject: Template for a new driver
> 
> Hello,
> 
> I am writing a new driver for a video decoder, and wanted to ask if
> there was any particular driver people would suggest as a model to
> look at for new drivers.  For example, I am not completely familiar
> with which interfaces are deprecated, and want to make sure I use a
> driver as a template that reflects the latest standards/conventions.
> 
> Suggestions welcome.
> 
[Hiremath, Vaibhav] I would suggest using new sub-device framework which recently Hans has submitted, since all other frameworks are going to be deprecated.
Please refer to the mail-chain for more info - 

http://marc.info/?l=linux-video&m=122756460125873&w=2

http://marc.info/?l=linux-video&m=122808129216519&w=2


> Thanks in advance,
> 
> Devin
> 
> --
> Devin J. Heitmueller
> http://www.devinheitmueller.com
> AIM: devinheitmueller
> 
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-
> request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
