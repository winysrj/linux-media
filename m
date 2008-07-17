Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6HDUQvG029919
	for <video4linux-list@redhat.com>; Thu, 17 Jul 2008 09:30:26 -0400
Received: from nlpi025.prodigy.net (nlpi025.sbcis.sbc.com [207.115.36.54])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6HDUFRW013130
	for <video4linux-list@redhat.com>; Thu, 17 Jul 2008 09:30:15 -0400
Received: from [192.168.0.201] (adsl-75-4-159-178.dsl.emhril.sbcglobal.net
	[75.4.159.178]) (authenticated bits=0)
	by nlpi025.prodigy.net (8.13.8 smtpauth/dk/8.13.8) with ESMTP id
	m6HDU3Ns021158
	for <video4linux-list@redhat.com>; Thu, 17 Jul 2008 08:30:09 -0500
Message-ID: <487F495A.10806@xnet.com>
Date: Thu, 17 Jul 2008 08:30:02 -0500
From: stuart <stuart@xnet.com>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Kworld 120 tuner - what should I expect?
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


Hi...

I just installed a Kworld 120 (the successor to the Kworld 115 & 110 
ATSC tuners) into a Debian mythtv box.  I am using a recent (several 
days old) version of v4l (pulled using Hg).

Things appear to be running, however I still can not tune in any ATSC 
stations (another mythtv box split off the same antenna is receiving 
over a dozen ATSC stations).  I have not even tried to get the Kworld 
120 NTSC tuner working.

As Kworld 120 support is new, I was wondering what to expect. There have 
been threads pointing out this new and very different version of Kworld 
tuners has to be rebooted in order to switch between tuning ATSC and 
NTSC signals.  I wonder if that is still true.  And, if anything, what 
else I should expect.

Also, what are the best tools to configure & test this type of hardware 
and how do you use them?  Running through mythtv-setup every iteration 
does take time.

...thanks




--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
