Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n078AKnV007439
	for <video4linux-list@redhat.com>; Wed, 7 Jan 2009 03:10:20 -0500
Received: from correo.cdmon.com (correo.cdmon.com [212.36.74.112])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n078A11Y014072
	for <video4linux-list@redhat.com>; Wed, 7 Jan 2009 03:10:02 -0500
Received: from localhost (localhost.cdmon.com [127.0.0.1])
	by correo.cdmon.com (Postfix) with ESMTP id 16FD1130E7C
	for <video4linux-list@redhat.com>; Wed,  7 Jan 2009 09:10:00 +0100 (CET)
Received: from correo.cdmon.com ([127.0.0.1])
	by localhost (correo.cdmon.com [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id bGTMq08cebhk for <video4linux-list@redhat.com>;
	Wed,  7 Jan 2009 09:09:59 +0100 (CET)
Received: from [192.168.0.174] (62.Red-217-126-43.staticIP.rima-tde.net
	[217.126.43.62])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by correo.cdmon.com (Postfix) with ESMTP id AECD9130E72
	for <video4linux-list@redhat.com>; Wed,  7 Jan 2009 09:09:59 +0100 (CET)
Message-ID: <49646351.6030709@cdmon.com>
Date: Wed, 07 Jan 2009 09:09:53 +0100
From: Jordi Moles Blanco <jordi@cdmon.com>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: support for remote in lifeview trio
Reply-To: jordi@cdmon.com
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

hi,

i've been googling and trying some things during days with no luck.

i want to get the remote which comes with this card working, and i only 
found old posts like this one:

http://www.spinics.net/lists/vfl/msg29862.html

which assures that the patch gets the remote to work on that card.

i downloaded the latest v4l source code and tried to patch it with the 
code proposed on that post, but var names have changed and i don't have 
a clue on how to apply it properly.

i haven't seen any more recent post, so i guess it may still be in a 
to-do list, or may be it was rejected for some reason to go into the 
main-line.

Could anyone tell me if this patch will ever be included? or... what v4l 
version could i download to be able to patch it as described?

Thanks.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
