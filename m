Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6HGPWbQ002164
	for <video4linux-list@redhat.com>; Thu, 17 Jul 2008 12:25:32 -0400
Received: from n2c.bullet.mail.ac4.yahoo.com (n2c.bullet.mail.ac4.yahoo.com
	[76.13.13.79])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m6HGPDAI012814
	for <video4linux-list@redhat.com>; Thu, 17 Jul 2008 12:25:14 -0400
Date: Thu, 17 Jul 2008 09:25:07 -0700 (PDT)
From: Krish K <rtos_q@yahoo.com>
To: Markus Rechberger <mrechberger@gmail.com>
In-Reply-To: <d9def9db0807170826r210f7880s42af20d2149a13bc@mail.gmail.com>
MIME-Version: 1.0
Message-ID: <566157.38298.qm@web59602.mail.ac4.yahoo.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: video4linux-list@redhat.com
Subject: Re: Question on V4L2 VBI operation
Reply-To: rtos_q@yahoo.com
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

=A0
Thanks for the response.=A0 I am trying to implement a video driver and
looking for information on how V4L2 expects the driver to provide VBI:=20
separately or embedded in the frame data. I have looked at the V4L2
doucmentation; which is very good, but doesn't seem to explicitly
address this aspect.
=A0
Thanks
Krish

--- On Thu, 7/17/08, Markus Rechberger <mrechberger@gmail.com> wrote:

From: Markus Rechberger <mrechberger@gmail.com>
Subject: Re: Question on V4L2 VBI operation
To: rtos_q@yahoo.com
Cc: video4linux-list@redhat.com
Date: Thursday, July 17, 2008, 3:26 PM

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

Markus=0A=0A=0A      
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
