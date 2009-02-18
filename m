Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n1I5KkqI021400
	for <video4linux-list@redhat.com>; Wed, 18 Feb 2009 00:20:46 -0500
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.175])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n1I5KZEc001991
	for <video4linux-list@redhat.com>; Wed, 18 Feb 2009 00:20:36 -0500
Received: by wf-out-1314.google.com with SMTP id 25so3020351wfc.6
	for <video4linux-list@redhat.com>; Tue, 17 Feb 2009 21:20:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <83b2c1480902172112p6fb23235w53d9bb750e8bc8cb@mail.gmail.com>
References: <83b2c1480902172112p6fb23235w53d9bb750e8bc8cb@mail.gmail.com>
Date: Tue, 17 Feb 2009 22:20:35 -0700
Message-ID: <c785bba30902172120v26c20484r233ff4bdf98b430b@mail.gmail.com>
From: Paul Thomas <pthomas8589@gmail.com>
To: Sumanth V <sumanth.v@allaboutif.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: setting up dvb-s card
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

It might already be set up. You can see if there is a driver
associated with it by doing "tree /sys/bus/pci".

thanks,
Paul

On Tue, Feb 17, 2009 at 10:12 PM, Sumanth V <sumanth.v@allaboutif.com> wrote:
> Hi All,
>
>      i am trying to set up a dvb-s card on my system. when i do lspci -v i
> get this.
>
>  00:0b.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
>        Subsystem: KNC One Unknown device 0019
>        Flags: bus master, medium devsel, latency 32, IRQ 5
>        Memory at ea000000 (32-bit, non-prefetchable) [size=512]
>
> i am using the kernel version 2.6.28.
>
> How do i set up this card??
>
> Thanks
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
>

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
