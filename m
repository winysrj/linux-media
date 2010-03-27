Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx03.extmail.prod.ext.phx2.redhat.com
	[10.5.110.7])
	by int-mx04.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o2RF2YDQ004187
	for <video4linux-list@redhat.com>; Sat, 27 Mar 2010 11:02:34 -0400
Received: from mail-pw0-f46.google.com (mail-pw0-f46.google.com
	[209.85.160.46])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o2RF2PkN025795
	for <video4linux-list@redhat.com>; Sat, 27 Mar 2010 11:02:25 -0400
Received: by pwi5 with SMTP id 5so6221983pwi.33
	for <video4linux-list@redhat.com>; Sat, 27 Mar 2010 08:02:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55fab5731003270620g6d597530k94106150e4722e0a@mail.gmail.com>
References: <55fab5731003270620g6d597530k94106150e4722e0a@mail.gmail.com>
Date: Sat, 27 Mar 2010 16:02:23 +0100
Message-ID: <6eeb4a0a1003270802r3db5fb27v82aa079d28f225b6@mail.gmail.com>
Subject: Re: Problem runnning webcam on a sheevaplug with using pwc
From: Raul Fajardo <rfajardo@gmail.com>
To: Yves Glodt <yg@mind.lu>
Cc: video4linux-list@redhat.com
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi Yves,

this is a bug related to the hotplug system or something.
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/443278

The driver works in two cases:
1) the camera was connected on power up.
2) you remove the module rmmod pwc, connect the camera and let the hotplug
system load the module

I suppose that's your problem.

Best regards,
Raul

On Sat, Mar 27, 2010 at 2:20 PM, Yves Glodt <yg@mind.lu> wrote:

> Hi,
>
> I have a problem when I run webcam on my sheevaplug, it seems to hang.
>
> I use the 2.6.33-1 kernel from
> http://sheeva.with-linux.com/sheeva/index.php?dir=2.6.33.1/
> The pwc module was missing so I cross-compiled it on my laptop and
> installed
> it.
> The modules loads and detects the camera without a problem. /dev/video0 is
> there as well.
>
>
> This is all what happens:
>
> root@sheevaplug:~# webcam
> reading config file: /root/.webcamrc
> video4linux webcam v1.5 - (c) 1998-2002 Gerd Knorr
> grabber config:
>  size 640x480 [none]
>  input usb, norm (null), jpeg quality 100
>  rotate=0, top=0, left=0, bottom=480, right=640
>
> and then it hangs forever.
>
> When I use the same webcam with the same .webcamrc on my laptop, it works.
> I attach an strace of the webcam run.
>
> Somebody knows what goes wrong here? Or what other debug possibilities I
> have? :-)
>
> best regards,
> Yves
>
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
>
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
