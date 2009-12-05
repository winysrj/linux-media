Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx05.extmail.prod.ext.phx2.redhat.com
	[10.5.110.9])
	by int-mx08.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id nB5KmW1q019720
	for <video4linux-list@redhat.com>; Sat, 5 Dec 2009 15:48:32 -0500
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.158])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id nB5KmKEw022279
	for <video4linux-list@redhat.com>; Sat, 5 Dec 2009 15:48:21 -0500
Received: by fg-out-1718.google.com with SMTP id e21so240367fga.9
	for <video4linux-list@redhat.com>; Sat, 05 Dec 2009 12:48:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <217901.88208.qm@web24812.mail.ird.yahoo.com>
References: <217901.88208.qm@web24812.mail.ird.yahoo.com>
Date: Sat, 5 Dec 2009 15:48:19 -0500
Message-ID: <829197380912051248y71beb227s2170f05c507ed50@mail.gmail.com>
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: =?ISO-8859-7?B?zd/q7/IgyPns3PI=?= <niktom11@yahoo.gr>
Content-Type: text/plain; charset=ISO-8859-7
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: Freecom Hybrid (tm6000 driver)
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

2009/12/5 Νίκος Θωμάς <niktom11@yahoo.gr>:
> Hi, my name is Martino,
> I bought this device beacouse where I live some
> channels are on dvb-t and
> other only on analog tv,
> I compiled this
> driver
> http://www.linuxtv.org/wiki/index.php/Trident_TM6000but
> when I plug my
> device dmesg say that don't find the
> firmware
> tm6000-xc3028.fw (I made the extraction of the firmware Iike the
> wiki), on
> web I found other linux user with the same problem but I dont find
> any
> solution,
>
> Some one can help me??

Hello Martino,

The tm6000 driver is completely broken, and not going to be fixed
anytime soon.  Therefore, your device is not going to work.

Sorry I don't have better news.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
