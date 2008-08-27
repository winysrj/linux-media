Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7RH8E9L028648
	for <video4linux-list@redhat.com>; Wed, 27 Aug 2008 13:08:15 -0400
Received: from ik-out-1112.google.com (ik-out-1112.google.com [66.249.90.179])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7RH815Z022085
	for <video4linux-list@redhat.com>; Wed, 27 Aug 2008 13:08:01 -0400
Received: by ik-out-1112.google.com with SMTP id c30so2912766ika.3
	for <video4linux-list@redhat.com>; Wed, 27 Aug 2008 10:08:00 -0700 (PDT)
Message-ID: <412bdbff0808271008y5820c97au8791a8fda18014b0@mail.gmail.com>
Date: Wed, 27 Aug 2008 13:08:00 -0400
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: "Lars Oliver Hansen" <lolh@ymail.com>
In-Reply-To: <954706.44416.qm@web28416.mail.ukl.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <954706.44416.qm@web28416.mail.ukl.yahoo.com>
Cc: video4linux-list@redhat.com, linux-dvb@linuxtv.org
Subject: Re: Information: Ubuntu Linux kernel image update solves v4l2
	alsa-sound troubles
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

Did they actually solve the problem with their build system relating
to alsa not being enabled (so people can build v4l-dvb from source),
or are they now just bundling the saa7134-alsa module in their lum
module?

Devin

On Wed, Aug 27, 2008 at 12:59 PM, Lars Oliver Hansen <lolh@ymail.com> wrote:
> Hello everyone!
>
>
> yesterday the Ubuntu 8.04 auto-updater installed a new kernel image (64-bit desktop). It solved the alsa-sound troubles on my laptop using mrec s v4l-experimental driver for saa7134.
>
> Here's the dmesg:
> [    0.000000] Linux video capture interface: v2.00
> [    0.000000] video_buf: exports duplicate symbol videobuf_mmap_mapper (owned by videobuf_core)
> [    0.000000] video_buf: exports duplicate symbol videobuf_mmap_mapper (owned by videobuf_core)
> [    0.000000] saa7130/34: v4l2 driver version 0.2.14 loaded
> [    0.000000] video_buf: exports duplicate symbol videobuf_mmap_mapper (owned by videobuf_core)
> [    0.000000] saa7134 ALSA driver for DMA sound loaded
>
> The only errors are duplicate symbols now. My Sound driver is the current latest Realtek HD audio codec driver. My laptop is an Acer 5050.
>
> Unfortunately the new kernel image made acpi not working again on my laptop instead of solving the wireless not detecting any routers.
> Is it possible to compile a new Linux kernel without modifying anything else (other dependencies) and telling grub to load this new kernel while having the previous one still around so that one can always change to the old kernel in case anything goes wrong? How?
> Thanks!
> Lars
>
> Send instant messages to your online friends http://uk.messenger.yahoo.com
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subjectunsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
>



-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
