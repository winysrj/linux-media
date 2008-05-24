Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4OBZhsi025034
	for <video4linux-list@redhat.com>; Sat, 24 May 2008 07:35:43 -0400
Received: from smtp-out03.email.it (smtp-out03.email.it [212.97.34.23])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4OBZAXv004887
	for <video4linux-list@redhat.com>; Sat, 24 May 2008 07:35:11 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by smtp-out03.email.it (Postfix) with ESMTP id 9046554002
	for <video4linux-list@redhat.com>;
	Sat, 24 May 2008 13:35:03 +0200 (CEST)
Received: from smtp-out03.email.it ([127.0.0.1])
	by localhost (smtp-out03.email.it [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id 1KsoR4Ls7IML for <video4linux-list@redhat.com>;
	Sat, 24 May 2008 13:35:02 +0200 (CEST)
Received: from [192.168.0.4] (unknown [83.147.86.163])
	by smtp-out03.email.it (Postfix) with ESMTP id 6916E54004
	for <video4linux-list@redhat.com>;
	Sat, 24 May 2008 13:35:02 +0200 (CEST)
Message-ID: <4837FD65.8030009@email.it>
Date: Sat, 24 May 2008 13:35:01 +0200
From: gionnico <gionnico@email.it>
MIME-Version: 1.0
To: video4linux-list@redhat.com
References: <20080524054443.1262.qmail@f5mail-237-202.rediffmail.com>
In-Reply-To: <20080524054443.1262.qmail@f5mail-237-202.rediffmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: Make file issue
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

Sandipan Bhattacharjee ha scritto:
>
> Dear All,
>
> I was trying to install Ethernet driver on my new HP laptop. The NIC 
> card is from Realtek. I got the source and makefile from Realtek 
> website. When i use make install, i get an error like:
> install: cannot stat `r8101e.ko': No such file or directory
>
> Can you please guide me how to go about this?
>
> Thanks in advance.
>
> Cheers,
> Sandipan.
>
> -- 
> video4linux-list mailing list
> Unsubscribe 
> mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list

It's because make failed somehow.
You should post the last lines of output .. not here, because it's OT.
 
 
 --
 Email.it, the professional e-mail, gratis per te: http://www.email.it/f
 
 Sponsor:
 Caschi, abbigliamento e accessori per la moto a prezzi convenienti, solo su Motostorm.it
 Clicca qui: http://adv.email.it/cgi-bin/foclick.cgi?mid=7850&d=24-5

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
