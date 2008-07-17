Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6HFRAx2017880
	for <video4linux-list@redhat.com>; Thu, 17 Jul 2008 11:27:10 -0400
Received: from py-out-1112.google.com (py-out-1112.google.com [64.233.166.178])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6HFR0Zb027111
	for <video4linux-list@redhat.com>; Thu, 17 Jul 2008 11:27:00 -0400
Received: by py-out-1112.google.com with SMTP id a29so3442175pyi.0
	for <video4linux-list@redhat.com>; Thu, 17 Jul 2008 08:27:00 -0700 (PDT)
Message-ID: <d9def9db0807170826r210f7880s42af20d2149a13bc@mail.gmail.com>
Date: Thu, 17 Jul 2008 17:26:59 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: rtos_q@yahoo.com
In-Reply-To: <264168.24331.qm@web59602.mail.ac4.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <264168.24331.qm@web59602.mail.ac4.yahoo.com>
Cc: video4linux-list@redhat.com
Subject: Re: Question on V4L2 VBI operation
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

Hi,

On Thu, Jul 17, 2008 at 1:10 AM, Krish K <rtos_q@yahoo.com> wrote:
> Hello
>
>
>
> I am new to V4L2 and have a question on how V4L2 expects
>
> VBI data to be provided.
>
>
>
> It is not clear to me if the VBI data (CC, WSS, etc) can be
>
> embedded in the frame? If the video capture device does
>
> not provide the VBI data separately, should the driver
>
> extract it from the frame? Is this what drivers usually do?
>
> If the device provides VBI data separately (either in some
>
> registers or FIFO),  then the driver should obtain this from
>
> the device for each frame?
>

as usual this depends on the device. It is possible that eg. the raw
vbi data is seen ontop of the analog TV frames, with USB devices this
leads to some interesting thoughts.
For example if mmap is used with the vbi device and all usb buffers
are dequeued, the transfer mechanism still has to take care that the
incoming vbi data gets stripped off of the frame otherwise it might
show up in the video which is not too nice.

Also depending on the device if the video gets scaled, it can easily
be that the VBI data remains at the full vbi data capture size.
I think a few drivers don't handle VBI correctly because it's not used
that widely, best is to stick with zvbi and documentation around it, I
tested alevt a while ago and it doesn't work with all devices whereas
libzvbi/zapping has a better chance.

Markus

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
