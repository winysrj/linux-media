Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBIAVEYn010226
	for <video4linux-list@redhat.com>; Thu, 18 Dec 2008 05:31:14 -0500
Received: from mail-gx0-f11.google.com (mail-gx0-f11.google.com
	[209.85.217.11])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBIAUxZK003633
	for <video4linux-list@redhat.com>; Thu, 18 Dec 2008 05:30:59 -0500
Received: by gxk4 with SMTP id 4so358558gxk.3
	for <video4linux-list@redhat.com>; Thu, 18 Dec 2008 02:30:59 -0800 (PST)
Message-ID: <da3e877f0812180230o60f5d3d1ob30a13e9b203ccc4@mail.gmail.com>
Date: Thu, 18 Dec 2008 11:30:58 +0100
From: "Mauro Giachero" <mauro.giachero@gmail.com>
To: "Lehel Kovach" <lehelkovach@hotmail.com>
In-Reply-To: <BAY135-W40EFD75EC68542FE991AB0BFF30@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <BAY135-W47952C51F5ED0CAEE9809BFF50@phx.gbl>
	<1229421997.1745.23.camel@localhost>
	<BAY135-W526C1AC293891AC584A4B7BFF50@phx.gbl>
	<1229496250.1747.4.camel@localhost>
	<BAY135-W40EFD75EC68542FE991AB0BFF30@phx.gbl>
Cc: video4linux-list@redhat.com
Subject: Re: quickcam express
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

On Thu, Dec 18, 2008 at 1:10 AM, Lehel Kovach <lehelkovach@hotmail.com> wrote:
> [...]
> i bought another quickcam (communicate model) and tried it out and got this:
>
> Bus 002 Device 005: ID 046d:089d Logitech, Inc.
>
> [ 2190.096046] usb 2-5: new full speed USB device using ohci_hcd and address 5
> [ 2190.300304] usb 2-5: configuration #1 chosen from 1 choice
> [ 2190.641232] usbcore: registered new interface driver snd-usb-audio
>
> (the video portion of it didn't register)
> [...]

I have one of these, too.
This one mostly works with the one-liner posted at [1].
Open problems include:
- console spammed with lines like
  "libv4lconvert: Error decompressing JPEG: unknown huffman code: 0000ffec"
  (and the last 8 picture lines are green)
- led control doesn't work

The data posted at [2] (USB dump using Windows drivers) can also be of
some interest.

[1] http://forums.quickcamteam.net/showthread.php?tid=310&pid=2448#pid2448
[2] http://forums.quickcamteam.net/showthread.php?tid=382

Regards
Mauro Giachero

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
