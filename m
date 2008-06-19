Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5JElXCZ009102
	for <video4linux-list@redhat.com>; Thu, 19 Jun 2008 10:47:33 -0400
Received: from horsea.3ti.be (horsea.3ti.be [62.213.193.164])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5JElHq3028155
	for <video4linux-list@redhat.com>; Thu, 19 Jun 2008 10:47:18 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by horsea.3ti.be (Postfix) with ESMTP id 59C7F2A80A1
	for <video4linux-list@redhat.com>;
	Thu, 19 Jun 2008 16:47:17 +0200 (CEST)
Received: from horsea.3ti.be ([127.0.0.1])
	by localhost (horsea.3ti.be [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id Ax6ioFEFKweQ for <video4linux-list@redhat.com>;
	Thu, 19 Jun 2008 16:47:16 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by horsea.3ti.be (Postfix) with ESMTP id 9939A2A80A1
	for <video4linux-list@redhat.com>;
	Thu, 19 Jun 2008 16:47:16 +0200 (CEST)
Date: Thu, 19 Jun 2008 16:47:16 +0200 (CEST)
From: Dag Wieers <dag@wieers.com>
To: video4linux-list@redhat.com
Message-ID: <alpine.LRH.1.10.0806191639240.24892@horsea.3ti.be>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Subject: Looking for a well suppord TV card with some requirements
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

Hi,

I am looking for a well support TV card with the following feature list:

   - Must have at least one tuner (PAL), preferably two
   - Must have composite input (for connecting a Nintendo Wii)
   - Should not have any delay between input signal and output
   - Works on kernel 2.6.18 (either vanilla, or by adding a driver)
   - Additionally, DVB-T would be nice

I bought a Hauppauge PVR-150 because I thought it complied to the above, 
but apparently (because it is an MPEG encoder and not a real TV card) 
there was a 2 second delay between the image from the Wii and the output 
on screen which is unacceptable for playing games.

(And the sound didn't work, but I didn't try to look for a solution 
because of the delay)

I still have an old Hauppauge WinTV card from 2000, based on the bttv 
driver which works fine, but does not have composite input.

Who can help me find something acceptable ?

-- 
--   dag wieers,  dag@wieers.com,  http://dag.wieers.com/   --
[Any errors in spelling, tact or fact are transmission errors]

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
