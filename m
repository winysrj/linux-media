Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4TFfVXS020049
	for <video4linux-list@redhat.com>; Thu, 29 May 2008 11:41:31 -0400
Received: from mxweblb04fl.versatel.de (mxweblb04fl.versatel.de
	[89.246.255.245])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4TFfIl4005171
	for <video4linux-list@redhat.com>; Thu, 29 May 2008 11:41:19 -0400
Received: from ens28fl.versatel.de (ens28fl.versatel.de [82.140.32.10])
	by mxweblb04fl.versatel.de (8.13.1/8.13.1) with ESMTP id m4TFfCc5000656
	for <video4linux-list@redhat.com>; Thu, 29 May 2008 17:41:12 +0200
Received: from cinnamon-sage.de (i577A0A09.versanet.de [87.122.10.9])
	(authenticated bits=0)
	by ens28fl.versatel.de (8.12.11.20060308/8.12.11) with SMTP id
	m4TFfCNL029323
	for <video4linux-list@redhat.com>; Thu, 29 May 2008 17:41:12 +0200
Received: from 192.168.23.2:57678 by cinnamon-sage.de for
	<video4linux-list@redhat.com> ; 29.05.2008 17:41:06
Message-ID: <483ECEB2.7080005@cinnamon-sage.de>
Date: Thu, 29 May 2008 17:41:38 +0200
From: Lars Hanisch <dvb@cinnamon-sage.de>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Subject: How to enumerate video devices?
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

  What is the best method to enumerate video devices, so that a program 
can display a list of present hardware in/outputs? Just iterating over 
/dev/video0 to /dev/videoSomeHighNumber seems a bit 'unprofessional'.

  (BTW I'm also looking for the right way of enumerating framebuffer 
devices...)

  I didn't find anything in the api-spec nor at google (perhaps I had 
the wrong searchphrases?).

  Please enlighten me. ;-)

Lars.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
