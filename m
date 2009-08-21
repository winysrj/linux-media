Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx08.extmail.prod.ext.phx2.redhat.com
	[10.5.110.12])
	by int-mx05.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id n7LEijI4015111
	for <video4linux-list@redhat.com>; Fri, 21 Aug 2009 10:44:45 -0400
Received: from mail-fx0-f221.google.com (mail-fx0-f221.google.com
	[209.85.220.221])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n7LEiVPs027309
	for <video4linux-list@redhat.com>; Fri, 21 Aug 2009 10:44:31 -0400
Received: by fxm21 with SMTP id 21so493943fxm.3
	for <video4linux-list@redhat.com>; Fri, 21 Aug 2009 07:44:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CC0519432816B04CA17FCEC83F6D189061AF451633@ExchBE.Mail24.ee>
References: <CC0519432816B04CA17FCEC83F6D189061AF451633@ExchBE.Mail24.ee>
Date: Fri, 21 Aug 2009 10:44:30 -0400
Message-ID: <829197380908210744p61adb7b9off9fe11c8e9ed534@mail.gmail.com>
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Avo Aasma <Avo.Aasma@webit.ee>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Cc: "video4linux-list@redhat.com" <video4linux-list@redhat.com>
Subject: Re: Error installing v4l driver
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

2009/8/21 Avo Aasma <Avo.Aasma@webit.ee>:
> Hello,
>
> I’m using Ubuntu Jaunty 9.04 with kernel 2.6.28-15-generic. I’m using MythTV with Hauppauge Nova-T 500 dual DVB card. After updating system with new linux-headres, I should reinstall v4l driver in order to get IR receiver to work. I have made this several times when linux-headers are updated without any problems.
> For reinstall I have used:
> hg pull
> hg update
> make clean
> rm v4l/.version
> make all
> sudo make install
>
> Now I get errors during command make all.
> Error is listed below.
>
>  CC [M]  /home/avo/v4l-dvb/v4l/stb6100.o
> /home/avo/v4l-dvb/v4l/stb6100.c: In function 'stb6100_set_frequency':
> /home/avo/v4l-dvb/v4l/stb6100.c:377: error: implicit declaration of function 'DIV_ROUND_CLOSEST'
> make[3]: *** [/home/avo/v4l-dvb/v4l/stb6100.o] Error 1
> make[2]: *** [_module_/home/avo/v4l-dvb/v4l] Error 2
> make[2]: Leaving directory `/usr/src/linux-headers-2.6.28-15-generic'
> make[1]: *** [default] Error 2
> make[1]: Leaving directory `/home/avo/v4l-dvb/v4l'
> make: *** [all] Error 2
>
> Can you help me to fix this problem?
>
> Regards,

I'm pretty sure I saw a fix go in for this yesterday afternoon.
Please install the latest code and see if it still occurs.

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
