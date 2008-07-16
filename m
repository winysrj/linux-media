Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6GMCRaC025681
	for <video4linux-list@redhat.com>; Wed, 16 Jul 2008 18:12:27 -0400
Received: from cicero1.cybercity.dk (cicero1.cybercity.dk [212.242.40.4])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6GMCFXw010628
	for <video4linux-list@redhat.com>; Wed, 16 Jul 2008 18:12:16 -0400
Received: from jakob.b4net.dk (port157.ds1-taa.adsl.cybercity.dk
	[212.242.111.226])
	by cicero1.cybercity.dk (Postfix) with ESMTP id 12B82427D9F
	for <video4linux-list@redhat.com>;
	Thu, 17 Jul 2008 00:12:14 +0200 (CEST)
Received: from [10.0.0.16] (unknown [10.0.0.16])
	by jakob.b4net.dk (Postfix) with ESMTP id 89871131800E
	for <video4linux-list@redhat.com>;
	Thu, 17 Jul 2008 00:12:08 +0200 (CEST)
Message-ID: <487E7238.7030003@b4net.dk>
Date: Thu, 17 Jul 2008 00:12:08 +0200
From: Per Baekgaard <baekgaard@b4net.dk>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Seeking help for a 713x based card
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

I have a card of unknown (to me) brand that identifies itself as a 
1131:7133 (chipset) with 1a7f:2004 rev d1 as the subsystem ID/revision.

The card is unfortunately glued (!) inside a LCD enclosure, and I am not 
able to see any further identifications on it.

Google'ing the SVID/SSID hints that it could be a PAL derivative of an 
Encore ENLTV-FM card. When asked, Encore basically just said that the 
closest match would appear to be ENLTV-FM and that there is no support 
for linux and asked me to look at sourceforge.net ;-)

I am able to get it partially running by using "options saa7134 card=107 
tuner=54" (or card 3), but it appears that changing channel via tvtime 
or myth  fails roughly half the time and simply causes it to return an 
invalid (or empty) video stream. Indeed, in myth, it sometimes crashes 
the application.

I am also not able to capture any sound from the card, although 
saa7134_alsa gets loaded as expected.


How do I debug this, and get the driver to recognise the card properly?

Or any good hints at what the card may be? Would the i2c reveal any 
further hints?


Thanks in advance,


-- Per.
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
