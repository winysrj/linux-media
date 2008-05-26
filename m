Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4Q1YOi5019776
	for <video4linux-list@redhat.com>; Sun, 25 May 2008 21:34:24 -0400
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.234])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4Q1YAKh017290
	for <video4linux-list@redhat.com>; Sun, 25 May 2008 21:34:10 -0400
Received: by rv-out-0506.google.com with SMTP id f6so1984041rvb.51
	for <video4linux-list@redhat.com>; Sun, 25 May 2008 18:34:09 -0700 (PDT)
Message-ID: <f50b38640805251834x6894f13du22ea670ae99aa614@mail.gmail.com>
Date: Sun, 25 May 2008 21:34:09 -0400
From: "Jason Pontious" <jpontious@gmail.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: Kworld 115 Analog Input Selection
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

I have been attempting to understand how the rf input is selected for analog
on the Kworld 115.  I'm currently using 2.6.24 kernel (Ubuntu 8.04). Mine is
currently setup as follows

RF Input 1: ATSC/Analog
RF Input 2: QAM

I would like to move the analog to the same input as the QAM.

Would it be possible for this to be configurable?  Not changeable on the fly
but set up as an option passed into the module?

I have found this in tuner-simple.c which seems to show that there are 4
possible inputs.  But where is this actually initialized to one or the
other.  Is it just a simple switch somewhere I can change and recompile the
module?

case TUNER_PHILIPS_TUV1236D
<http://www.gelato.unsw.edu.au/lxr/ident?i=TUNER_PHILIPS_TUV1236D>:
 <http://www.gelato.unsw.edu.au/lxr/source/drivers/media/video/tuner-simple.c#L259>
             */* 0x40 -> ATSC antenna input 1 */*
 <http://www.gelato.unsw.edu.au/lxr/source/drivers/media/video/tuner-simple.c#L260>
             */* 0x48 -> ATSC antenna input 2 */*
 <http://www.gelato.unsw.edu.au/lxr/source/drivers/media/video/tuner-simple.c#L261>
             */* 0x00 -> NTSC antenna input 1 */*
 <http://www.gelato.unsw.edu.au/lxr/source/drivers/media/video/tuner-simple.c#L262>
             */* 0x08 -> NTSC antenna input 2 */*



Thanks for any help you can provide.
Jason Pontious
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
