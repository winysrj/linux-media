Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx06.extmail.prod.ext.phx2.redhat.com
	[10.5.110.10])
	by int-mx03.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id nAB9itMb014281
	for <video4linux-list@redhat.com>; Wed, 11 Nov 2009 04:44:55 -0500
Received: from mail-px0-f184.google.com (mail-px0-f184.google.com
	[209.85.216.184])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id nAB9isxS007942
	for <video4linux-list@redhat.com>; Wed, 11 Nov 2009 04:44:54 -0500
Received: by pxi14 with SMTP id 14so712503pxi.31
	for <video4linux-list@redhat.com>; Wed, 11 Nov 2009 01:44:54 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 11 Nov 2009 10:36:44 +0100
Message-ID: <fe6fd5f60911110136t5f0f97fcjcd849916df6fda0c@mail.gmail.com>
From: Carlos Lavin <carlos.lavin@vista-silicon.com>
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Subject: module ov7670.c
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

i don't know that it pass with this module, ov7670.c , because i don't see
in the screen of my Pc this modulo when the kernel is load. this module
haven't the module_init  function , and i don't know if it is possible to
run it without this function. the version kernel where i work is 2.6.30,
also i have patched this modulo for works with the library soc_camera.h
can anybody help me? I am rookie in this topics.
thanks.
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
