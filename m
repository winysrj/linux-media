Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mA4E9wiw006248
	for <video4linux-list@redhat.com>; Tue, 4 Nov 2008 09:09:58 -0500
Received: from fk-out-0910.google.com (fk-out-0910.google.com [209.85.128.186])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mA4E9lrX029821
	for <video4linux-list@redhat.com>; Tue, 4 Nov 2008 09:09:47 -0500
Received: by fk-out-0910.google.com with SMTP id e30so3970795fke.3
	for <video4linux-list@redhat.com>; Tue, 04 Nov 2008 06:09:46 -0800 (PST)
Message-ID: <c41ce8440811040609v591ae268y80d6669dccf55862@mail.gmail.com>
Date: Tue, 4 Nov 2008 15:09:46 +0100
From: picciuX <matteo@picciux.it>
To: video4linux-list@redhat.com
In-Reply-To: <1225586521.2642.7.camel@pc10.localdom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c41ce8440810310231gdb614bcred3f4386de883abb@mail.gmail.com>
	<1225586521.2642.7.camel@pc10.localdom.local>
Subject: Re: Pinnacle PCTV 310i Remote: i2c 'ERROR: NO_DEVICE'
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

2008/11/2 hermann pitton <hermann-pitton@arcor.de>:

> don't have that remote, but also enable ir-kbd-i2c debug=1.
>
> ir-kbd-i2c: probe 0x7a @ saa7133[0]: no
> ir-kbd-i2c: probe 0x47 @ saa7133[0]: no
> ir-kbd-i2c: probe 0x71 @ saa7133[0]: no
> ir-kbd-i2c: probe 0x2d @ saa7133[0]: no
> ir-kbd-i2c: probe 0x7a @ saa7133[1]: no
> ir-kbd-i2c: probe 0x47 @ saa7133[1]: no
> ir-kbd-i2c: probe 0x71 @ saa7133[1]: no
> ir-kbd-i2c: probe 0x2d @ saa7133[1]: no
>
> You should have the device found at 0x47.
>

In fact i see:

ir-kbd-i2c: probe 0x47 @ saa7133[0]: yes

So everything seemed to go well. But, same story for the rest: ERROR:
NO_DEVICE when i press buttons on the remote.
What seems strange to me is the fact that the driver *reacts* to
remote key presses, but reacts with an error.

Cheers
Matteo

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
