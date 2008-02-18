Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1IL0Gfv011100
	for <video4linux-list@redhat.com>; Mon, 18 Feb 2008 16:00:16 -0500
Received: from mailout06.sul.t-online.com (mailout06.sul.t-online.de
	[194.25.134.19])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1IKxg8q012664
	for <video4linux-list@redhat.com>; Mon, 18 Feb 2008 15:59:42 -0500
Message-ID: <47B9F1C2.3050309@t-online.de>
Date: Mon, 18 Feb 2008 21:59:46 +0100
From: Hartmut Hackmann <hartmut.hackmann@t-online.de>
MIME-Version: 1.0
To: tux@schweikarts-vom-dach.de
References: <200801051252.18108.tux@schweikarts-vom-dach.de>
In-Reply-To: <200801051252.18108.tux@schweikarts-vom-dach.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: DVB-S on quad TV tuner card from Medion PC MD8800
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

Hi

Tux schrieb:
> Hello,
> 
> what is the status of the DVB-S Part of the TV Card. Is it now possible to 
> select the frontend for this card with a kernel option ?
> I have downloaded the actual version of the sources and have had look into 
> saa7134-dvb.c. There is only the DVB-T part supported. When do you think
> it possible to watch TV with DVB-S with this card ?
> 
> best regards
> 
One DVB-S section of the board should be working now.
You need to get the most recent driver from http://www.linuxtv.org/hg/v4l-dvb
To get DVB-S, you nned to load the saa7134-dvb module with the option
use_frontend=1.
You get the other section working, i need a tester who has the card in a pc
it was sold with ( since it is NOT a regular PCI card)

best regards
  Hartmut

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
