Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m45LXHfW009629
	for <video4linux-list@redhat.com>; Mon, 5 May 2008 17:33:17 -0400
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.227])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m45LWwrl022155
	for <video4linux-list@redhat.com>; Mon, 5 May 2008 17:32:59 -0400
Received: by rv-out-0506.google.com with SMTP id f6so1227068rvb.51
	for <video4linux-list@redhat.com>; Mon, 05 May 2008 14:32:58 -0700 (PDT)
Message-ID: <d9def9db0805051432t6fb53d79qc7d31797986f17c4@mail.gmail.com>
Date: Mon, 5 May 2008 23:32:57 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: jortega@listpropertiesnow.com
In-Reply-To: <20080505141021.A537F83A@resin13.mta.everyone.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080505141021.A537F83A@resin13.mta.everyone.net>
Cc: video4linux-list@redhat.com
Subject: Re: i2c_kbd_irc Pinnacle PCTV USB 2
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

On Mon, May 5, 2008 at 11:10 PM,  <jortega@listpropertiesnow.com> wrote:
> Hello,
>
>  Sorry about the last message don't know why this thing keeps rejecting me.
>
>  Anyway here's the mail again:
>
>  I've got a Pinnacle PCTV USB2 in Europe. It works fine in Windows and on Ubuntu Gutsy.
>
>  The only problem that I have and have been having is that the freakin remote doesn't want to cooperate.
>
>  I have tried a million different ideas (lirc,mythtv,tvtime,mce_usb2,bttv, etc...)
>
>  Here's what I've tried lately:
>
>  modprobe irc_kbd_i2c
>
>  good this is what the dmesg gives me:
>
>  [ 6737.645843] input: i2c IR (EM28XX Pinn as /class/input/input6
>  [ 6737.645871] ir-kbd-i2c: i2c IR (EM28XX Pinn detected at i2c-0/0-0047/ir0 [em28xx #0]
>  [ 6737.646416] i2c IR (EM28XX Pinn: unknown key: key=0x00 raw=0x00 down=1
>
>
>  Seems to be on event 6, here's a cat of /proc/bus/input/devices
>
>  I: Bus=0018 Vendor=0000 Product=0000 Version=0000
>  N: Name="i2c IR (EM28XX Pinn"
>  P: Phys=i2c-0/0-0047/ir0
>  S: Sysfs=/class/input/input6
>  U: Uniq=
>  H: Handlers=kbd event6
>  B: EV=100003
>  B: KEY=c0014 902040 0 0 0 4 8000 1a8 80000803 9e1680 0 40 12800ffc
>
>  Nice, that seems to have loaded.
>
>  Now, I should be able to cat /dev/input/event6 and get something, but I get nothing.
>
>  I've also tried irrecord with no luck.
>
>  Any ideas?

we can go through it tomorrow!
I did quite some remote control userland work recently :)

Markus

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
