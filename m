Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4BAalnC019278
	for <video4linux-list@redhat.com>; Sun, 11 May 2008 06:36:47 -0400
Received: from wa-out-1112.google.com (wa-out-1112.google.com [209.85.146.176])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4BAaVYS001052
	for <video4linux-list@redhat.com>; Sun, 11 May 2008 06:36:31 -0400
Received: by wa-out-1112.google.com with SMTP id j32so2596189waf.7
	for <video4linux-list@redhat.com>; Sun, 11 May 2008 03:36:31 -0700 (PDT)
Message-ID: <c0e0e090805110336n1c880901r890178c0530ca2e8@mail.gmail.com>
Date: Sun, 11 May 2008 13:36:30 +0300
From: "ilker ilgen" <ilkerilgen@gmail.com>
To: "Jody Gugelhupf" <knueffle@yahoo.com>, video4linux-list@redhat.com
In-Reply-To: <20080511065254.GA323@daniel.bse>
MIME-Version: 1.0
References: <140248.59791.qm@web36105.mail.mud.yahoo.com>
	<20080511065254.GA323@daniel.bse>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Cc: 
Subject: Re: problems with 4 port video capture card with conexant fusion
	878a 25878-132 chip, please help
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

Hello
Did you try create modprobe.conf file under etc foldeR?

I think your bt card is a DVR card.( survalence)

alias char-major-82 bttv
options bttv card=56,56 tuner=2,2

56 is generic.Maybe you can change another.Try 22

ilker
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
