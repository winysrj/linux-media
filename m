Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with SMTP id n5J7p9E4004503
	for <video4linux-list@redhat.com>; Fri, 19 Jun 2009 03:51:09 -0400
Received: from smtp4.versatel.nl (smtp4.versatel.nl [62.58.50.91])
	by mx1.redhat.com (8.13.8/8.13.8) with SMTP id n5J7naXr015526
	for <video4linux-list@redhat.com>; Fri, 19 Jun 2009 03:49:36 -0400
Message-ID: <4A3B437F.3070101@hhs.nl>
Date: Fri, 19 Jun 2009 09:51:27 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Russell King <rjkfsm@gmail.com>
References: <ab1abcde0906171431r3782f252pdd2a3b7f24a72d0e@mail.gmail.com>
In-Reply-To: <ab1abcde0906171431r3782f252pdd2a3b7f24a72d0e@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: Still no fix
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

On 06/17/2009 11:31 PM, Russell King wrote:
> Hi,
>
> I am trying to use an old Creative Instant Webcam with the gspca module that
> ships with the 2.6.29 kernel and almost all I get are problems. It does not
> matter if I use my laptop with an ATI video card or my desktop with an
> nVidia card. I have tried using the webcam as the only device on the USB
> hub. Funny thing is that "mplayer tv:// -tv
> driver=v4l2:width=352:height=288:device=/dev/video0"
> works properly.
>

Hi,

what is the output dmesg after plugging in that webcam ?

Also are you using libv4l ?

Regards,

Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
