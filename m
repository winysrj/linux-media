Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2RHBYRn005105
	for <video4linux-list@redhat.com>; Thu, 27 Mar 2008 13:11:35 -0400
Received: from web31303.mail.mud.yahoo.com (web31303.mail.mud.yahoo.com
	[68.142.198.98])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m2RHBMCf014012
	for <video4linux-list@redhat.com>; Thu, 27 Mar 2008 13:11:23 -0400
Date: Thu, 27 Mar 2008 13:11:16 -0400 (EDT)
From: Azdine Trachi <azdine_trachi@yahoo.ca>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Message-ID: <697162.37449.qm@web31303.mail.mud.yahoo.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Subject: NTSC digitized raw data using HD 5500 card
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


I have some  questions regarding the card HD 5500 card. 
My problem is with the analog capture. The card is installed and works for both digital and analog TV. 
What am looking for is to capture digitized raw data ( sampled at 4 Fsc=14.3 MHz).
In other words, I want to make the decoder of this card bypass the the built-in Y/C separation block (Comb filtering, Notch filtering ....etc).
My question  : is it possible to do this? 
Because my objective is to get a digitized raw data (NTSC-M) even if the sampling frequency is 8 Fsc MHz or 27 MHz. I need this data for further processing (Synch and color burst detection, Y/C separation and deinterlacing will be done in software (MATLAB)). In this case what will be the file extension of this raw data?  will it be .raw?

I am using Xawtv (Streamer) for capturing. Please send me your help.



       
---------------------------------
Be smarter than spam. See how smart SpamGuard is at giving junk email the boot with the All-new Yahoo! Mail 
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
