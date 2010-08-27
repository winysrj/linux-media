Return-path: <mchehab@pedra>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:57976 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753831Ab0H0Wye convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Aug 2010 18:54:34 -0400
Received: by qyk33 with SMTP id 33so3406894qyk.19
        for <linux-media@vger.kernel.org>; Fri, 27 Aug 2010 15:54:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C3070A4.6040702@redhat.com>
References: <4C3070A4.6040702@redhat.com>
From: Jonathan Isom <jeisom@gmail.com>
Date: Fri, 27 Aug 2010 17:54:14 -0500
Message-ID: <AANLkTinXb=TeSGO_6Mr6jhzaUOUZ3yZL5+oAP2GP0GG5@mail.gmail.com>
Subject: Re: ibmcam (xrilink_cit) and konica webcam driver porting to gspca update
To: Hans de Goede <hdegoede@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Patryk Biela <patryk.biela@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Sun, Jul 4, 2010 at 6:29 AM, Hans de Goede <hdegoede@redhat.com> wrote:
> Hi all,
>
> I've finished porting the usbvideo v4l1 ibmcam and
> konicawc drivers to gspcav2.
>
> The ibmcam driver is replaced by gspca_xirlink_cit, which also
> adds support for 2 new models (it turned out my testing cams
> where not supported by the old driver). This one could use
> more testing.

I just tried using your driver. I get no video.  using 2.6.35.3.  Had
to patch usb_buffer_[alloc & free]
otherwise no changes to your tree.

> /usr/bin/qv4l2 /dev/video2
Start Capture: Input/output error
VIDIOC_STREAMON: Input/output error
Start Capture: Input/output error
VIDIOC_STREAMON: Input/output error

-- info
Model 2	
KSX-X9903	
0x0545
0x8080
3.0a
Old, cheaper model	Xirlink C-It

/usr/sbin/v4l2-dbg -d /dev/video2 -D
Driver info:
        Driver name   : xirlink-cit
        Card type     : USB IMAGING DEVICE
        Bus info      : usb-0000:00:12.2-6.1
        Driver version: 133376
        Capabilities  : 0x05000001
                Video Capture
                Read/Write
                Streaming

Any Ideas

Jonathan





> The konicawc driver is replaced by gspca_konica which is
> pretty much finished.
>
> You can get them both here:
> http://linuxtv.org/hg/~hgoede/ibmcam
>
> Once Douglas updates the hg v4l-dvb tree to be up2date with
> the latest and greatest from Mauro, then I'll rebase my
> tree (the ibmcam driver needs a very recent gspca core patch),
> and send a pull request.
>
> Regards,
>
> Hans
>
>
> p.s.
>
> 1) Many thanks to Patryk Biela for providing me a konica
>   driver using camera.
> 2) Still to do the se401 driver.
> 3) I'll be on vacation the coming week and not reading email.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
ASUS m3a78 motherboard
AMD Athlon64 X2 Dual Core Processor 6000+ 3.1Ghz
2 Gigabytes of DDR2-800
Gigabyte nVidia 9400gt  Graphics adapter
KWorld ATSC 110 TV Capture Card
KWorld ATSC 115 TV Capture Card
