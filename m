Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n1JBaI0q017475
	for <video4linux-list@redhat.com>; Thu, 19 Feb 2009 06:36:18 -0500
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.170])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n1JBa9vh004480
	for <video4linux-list@redhat.com>; Thu, 19 Feb 2009 06:36:09 -0500
Received: by wf-out-1314.google.com with SMTP id 25so371726wfc.6
	for <video4linux-list@redhat.com>; Thu, 19 Feb 2009 03:36:08 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 19 Feb 2009 11:36:08 +0000
Message-ID: <83b2c1480902190336x761a27bkb17d962ed0f56e3f@mail.gmail.com>
From: Sumanth V <sumanth.v@allaboutif.com>
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: Setting up a channel.conf file for DVB-S2
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

Hi all,

   I have a DVB-S2 card which i set it up recently. I am trying to generate
a "channel.conf" file, but its failing. The command i use is "scan" since i
am using debian.

   when ever i run the command "scan" on a file i get this error

   scanning Intelsat-68.5E
   using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
   initial transponder 4034000 V 19559000 3
   >>> tune to: 4034:v:0:19559
    __tune_to_transponder:1483: ERROR: Setting frontend parameters failed:
22 Invalid argument
    >>> tune to: 4034:v:0:19559
    __tune_to_transponder:1483: ERROR: Setting frontend parameters failed:
22 Invalid argument
    ERROR: initial tuning failed
    dumping lists (0 services)
    Done.

     The content of the file which i am scanning is
     # Intelsat-68.5E SDT info service transponder
     # freq pol sr fec
     S 4034000 V 19559000 3/4


     Why do i get this error??
     What are the steps to generate a channel.conf file???


    Thanks
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
