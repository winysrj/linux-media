Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n7IItfmp000958
	for <video4linux-list@redhat.com>; Tue, 18 Aug 2009 14:55:41 -0400
Received: from mail-vw0-f184.google.com (mail-vw0-f184.google.com
	[209.85.212.184])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n7IItM4N019308
	for <video4linux-list@redhat.com>; Tue, 18 Aug 2009 14:55:22 -0400
Received: by vws14 with SMTP id 14so1696148vws.6
	for <video4linux-list@redhat.com>; Tue, 18 Aug 2009 11:55:22 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 18 Aug 2009 20:55:21 +0200
Message-ID: <80f602570908181155v71e96a45q4563cd330ee4e5f0@mail.gmail.com>
From: Christian Neumair <cneumair@gnome.org>
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: fbtv 3.95 & vdr 1.4.5: closing fbtv causes vdr freeze
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

Dear video4linux-list,

I observed a problem with an ancient easyVDR distribution from 2007 which
uses vdr 1.4.5 (c't vdr), fbtv 3.95, and kernel 2.6.22.5: As soon as I quit
fbtv with ctrl-c, vdr turns into a CPU hog and has to be killed. This is
unfortunate, because in my setup I only want to use the local fbtv frontend
occassionally, while permanently using the remote VOMP plugin. Is this a
known issue? Can you reproduce it with recent vdr and fbtv versions? Can I
do anything to debug the issue?

Thanks in advance!

best regards,
 Christian Neumair
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
