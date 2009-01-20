Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0K4kNt2001135
	for <video4linux-list@redhat.com>; Mon, 19 Jan 2009 23:46:23 -0500
Received: from mail-bw0-f10.google.com (mail-bw0-f10.google.com
	[209.85.218.10])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n0K4k8Ui006179
	for <video4linux-list@redhat.com>; Mon, 19 Jan 2009 23:46:09 -0500
Received: by bwz3 with SMTP id 3so151268bwz.3
	for <video4linux-list@redhat.com>; Mon, 19 Jan 2009 20:46:08 -0800 (PST)
Message-ID: <aec7e5c30901192046j1a595day51da698181d034e5@mail.gmail.com>
Date: Tue, 20 Jan 2009 13:46:08 +0900
From: "Magnus Damm" <magnus.damm@gmail.com>
To: "Matthieu CASTET" <matthieu.castet@parrot.com>
In-Reply-To: <497487F2.7070400@parrot.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <497487F2.7070400@parrot.com>
Cc: video4linux-list@redhat.com, Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: soc-camera : sh_mobile_ceu_camera race on free_buffer ?
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

Hi Matthieu,

On Mon, Jan 19, 2009 at 11:02 PM, Matthieu CASTET
<matthieu.castet@parrot.com> wrote:
> Hi,
>
> I am writing a soc camera driver, and I use sh_mobile_ceu_camera as an
> example.
>
> But I don't understand how buffer are handled when the application is
> doing a streamoff :
>
> streamoff will call videobuf_streamoff and then videobuf_queue_cancel.
> videobuf_queue_cancel will call free_buffer.
>
> But we didn't do stop_capture, so as far I understand the controller is
> still writing data in memory. What prevent us to free the buffer we are
> writing.

I have not looked into this in great detail, but isn't this handled by
the videobuf state? The videobuf has state VIDEOBUF_ACTIVE while it is
in use. I don't think such a buffer is freed.

> Why doesn't we do a stop_capture before videobuf_streamoff ?
>
> I saw that pxa_camera use videobuf_waiton, before freeing the buffer.
> That seem more safe, but that mean we need to wait that controller
> finish to write all the pending buffer.

Hm, but vivi.c does not use videbuf_waiton(). I guess this depends on
how the frames are queued in the driver.

Cheers,

/ magnus

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
