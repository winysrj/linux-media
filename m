Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1E10ap1017731
	for <video4linux-list@redhat.com>; Wed, 13 Feb 2008 20:00:36 -0500
Received: from mailout05.sul.t-online.com (mailout05.sul.t-online.de
	[194.25.134.82])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1E10EPm032109
	for <video4linux-list@redhat.com>; Wed, 13 Feb 2008 20:00:14 -0500
Message-ID: <47B392A5.2030908@t-online.de>
Date: Thu, 14 Feb 2008 02:00:21 +0100
From: Hartmut Hackmann <hartmut.hackmann@t-online.de>
MIME-Version: 1.0
To: LInux DVB <linux-dvb@linuxtv.org>,
	Linux and Kernel Video <video4linux-list@redhat.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: 
Subject: Mdeion / Creatix CTX948 DVB-S driver is ready for testing
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

Hi, folks

In my personal repository:
  http://linuxtv.org/hg/~hhackmann/v4l-dvb-experimental/
you will find a driver that supports this card, DVB-T and DVB-S

It might also work for
- one section of the MD8800
- similar boards based on saa713x, tda10086, tda826x, isl6405

The board will show up as MD8800. According to Hermann, the configurations
for analog TV and DVB-T are identical.
If you want to use the board with DVB-S, you will need to load the
saa7134-dvb module with the option "use_frontend=1". The default 0 is
DVB-T. For those who got the board from a second source: don't forget
to connect the 12v (the floppy supply) connector.

I don't have a dish, so i depend on your reports. To get the MD8800
running, i need a volunteer who does the testing for me. He should be able
to apply patches, compile the driver and read kernel logs.

Good luck
  Hartmut

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
