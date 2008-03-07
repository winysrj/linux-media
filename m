Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m271EDbb010445
	for <video4linux-list@redhat.com>; Thu, 6 Mar 2008 20:14:13 -0500
Received: from gaimboi.tmr.com (mail.tmr.com [64.65.253.246])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m271DagZ020052
	for <video4linux-list@redhat.com>; Thu, 6 Mar 2008 20:13:37 -0500
Received: from [127.0.0.1] (gaimboi.tmr.com [127.0.0.1])
	by gaimboi.tmr.com (8.12.8/8.12.8) with ESMTP id m271ISAv001249
	for <video4linux-list@redhat.com>; Thu, 6 Mar 2008 20:18:28 -0500
Message-ID: <47D097E4.9050209@tmr.com>
Date: Thu, 06 Mar 2008 20:18:28 -0500
From: Bill Davidsen <davidsen@tmr.com>
MIME-Version: 1.0
To: video4linux M/L <video4linux-list@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Audio issues with ATI HDTV Wonder
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

On all the systems which could reasonably be used for TV capture here, a 
Celeron, pre-HT P4, and K7, the cx88 module(s) load and block the on 
board audio driver. The regular TV Wonder doesn't do that with the bt 
driver.

If I put the card in a server, the audio is fine, but I can't use a 
server for TV capture, for many reasons.

I played a bit with driver load options (index) trying to get the 
problem to change, but no luck. I'm guessing that these systems are 
configured to disable the on board audio if another audio card of any 
type is found, and there isn't a BIOS option to use the on board audio 
no matter what.

The system I built for just this is in a shuttle case and has no slots 
to use for a sound card, even if that would help. I have a bunch of old 
TV cards, ATI, STB, none of them do this, but they all put sound on a CD 
connector, while the HDTV card has a place on the card for a connector 
but not installed, and I really don't want the overhead of using 
"always_analog" anyway.

Has anyone a workaround for this?

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
