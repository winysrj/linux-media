Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:57102 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754997AbZLNRhp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Dec 2009 12:37:45 -0500
Received: by ewy19 with SMTP id 19so3634930ewy.21
        for <linux-media@vger.kernel.org>; Mon, 14 Dec 2009 09:37:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20091214171756.GB20967@pathfinder.pcs.usp.br>
References: <20091214171756.GB20967@pathfinder.pcs.usp.br>
Date: Mon, 14 Dec 2009 14:37:41 -0300
Message-ID: <c2fe070d0912140937j388ee63fpe3a766c83638a7f8@mail.gmail.com>
Subject: Re: problems compiling webcam driver
From: leandro Costantino <lcostantino@gmail.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Check that videodev.ko is the last one.
Are you compiling vanilla gspca drivers from the kernel? or the
mercuarial version?

On Mon, Dec 14, 2009 at 2:17 PM, Nicolau Werneck <nwerneck@gmail.com> wrote:
> Hello. I have modified the t613 driver to support a new sensor (code
> 0x0802), and I am now trying to prepare a patch to submit.
>
> The problem is that now that I started to work with the driver again,
> I started to get this error message... Does anybody know what is this
> about? I already tried to switch from the 2.6.31 kernel to the 2.6.32,
> but the same happened.
>
>
> [ 1524.864013] usb 6-2: new full speed USB device using uhci_hcd and address 3
> [ 1525.026046] usb 6-2: New USB device found, idVendor=17a1, idProduct=0128
> [ 1525.026049] usb 6-2: New USB device strings: Mfr=32, Product=38, SerialNumber=0
> [ 1525.026052] usb 6-2: Product: USB2.0 JPEG WebCam
> [ 1525.026054] usb 6-2: Manufacturer: TASCORP
> [ 1525.026131] usb 6-2: configuration #1 chosen from 1 choice
> [ 1525.072916] gspca_main: disagrees about version of symbol video_devdata
> [ 1525.072918] gspca_main: Unknown symbol video_devdata
> [ 1525.073060] gspca_main: disagrees about version of symbol video_unregister_device
> [ 1525.073062] gspca_main: Unknown symbol video_unregister_device
> [ 1525.073118] gspca_main: disagrees about version of symbol video_register_device
> [ 1525.073119] gspca_main: Unknown symbol video_register_device
> [ 1525.073649] gspca_t613: Unknown symbol gspca_frame_add
> [ 1525.073731] gspca_t613: Unknown symbol gspca_debug
> [ 1525.073878] gspca_t613: Unknown symbol gspca_disconnect
> [ 1525.073931] gspca_t613: Unknown symbol gspca_resume
> [ 1525.073985] gspca_t613: Unknown symbol gspca_dev_probe
> [ 1525.074038] gspca_t613: Unknown symbol gspca_suspend
>
>
> see you,
>  ++nicolau
>
> --
> Nicolau Werneck <nwerneck@gmail.com>          1AAB 4050 1999 BDFF 4862
> http://www.lti.pcs.usp.br/~nwerneck           4A33 D2B5 648B 4789 0327
> Linux user #460716
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
