Return-Path: <SRS0=0You=RH=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA088C43381
	for <linux-media@archiver.kernel.org>; Mon,  4 Mar 2019 14:08:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 83FC120815
	for <linux-media@archiver.kernel.org>; Mon,  4 Mar 2019 14:08:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fhzJE49T"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726161AbfCDOIF (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 4 Mar 2019 09:08:05 -0500
Received: from mail-it1-f180.google.com ([209.85.166.180]:36130 "EHLO
        mail-it1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726037AbfCDOIE (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 4 Mar 2019 09:08:04 -0500
Received: by mail-it1-f180.google.com with SMTP id v83so7658924itf.1
        for <linux-media@vger.kernel.org>; Mon, 04 Mar 2019 06:08:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=LF9FFDqWbNYs2AayrlIFheBE3DP0yN474z+x8a96UKw=;
        b=fhzJE49Tu3Sigt1OvoXjONt9jA4B+pOWVw7PmwJmlqW1on/5/mfqzyz5Y082YNQKka
         OTuuRlrPoDRgwyZVq0KNrz0mJJNXNXy4n6CATxg50WCzfnNGTpQL8kfwhqoMnskhZ8el
         9i8LO6NK5aKtp0bHjpMmE1k8MzLuALag9p8CvhoSR5lxl77luj01kC00UoB6Lgg9X92B
         mca2wkTXxvhpu/BNA37AFiW0eQOX/KW7crOKe8kWuSgiNGD759OnLDrsCJ/wNu/zXrcV
         +fGQ7dI+mtlUhxM1+xFEUwjZN5VuHJdHnaXYM+r42i3oZA18E5QJoQ2zrrtl73PAQTgy
         no5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=LF9FFDqWbNYs2AayrlIFheBE3DP0yN474z+x8a96UKw=;
        b=KDgWbLYVWmqgFVPveXlnhzhNQtAynML7CA8II9qxncPz9gZ/0nrDag5xfqFCumXhDM
         +bO4flqTiN8rBCMRDbC+gvonBlG+rHWAqcwwuoEA/uejrr0J+MsJv+XHl1Dlcubno2e7
         xh8z0IpqqDj8ynycEI9TcKQOaZl6k6FhIIlG1WKPF3BQzSWVI5c4OhMgeSVSiGNTI/8u
         w0CWdfdzIPXSeIXEikGm3KTUUaFQigcVHgsr3qEI0z9fpEYJDLRb/Kicbtzykr6S04Yy
         ZfaXnG1cUQQcEn1Pd4zZtaEH9DUOIg6AOOD9X8uyRc/1ENZb28DJc37G+4cew0GE3xrN
         VuUA==
X-Gm-Message-State: APjAAAXdEOPvX2esOYkLUQe3iW9gJ2VY6zkGq6kFJKXS+gdQ+RgY4TSl
        cEsH3W71S4HwhudMqObdv02Kxi5VTmbU/h2Bi3dcyw==
X-Google-Smtp-Source: AHgI3Ia6kGePBLmOx3zDsuuSNUiBzD/oilE4x8wgSdRJyiq6aUiJELahL0FADACil84hyI0IeKK+7gAlhsGCO1Pn4BI=
X-Received: by 2002:a24:7ec9:: with SMTP id h192mr11153766itc.104.1551708482858;
 Mon, 04 Mar 2019 06:08:02 -0800 (PST)
MIME-Version: 1.0
References: <CAN6+69JTiWpiiOeRn2jAuW__sx2J2p8FWUts1SpLeUoAC=W4vQ@mail.gmail.com>
 <c8534224-e8eb-8b77-a4ac-bcdbfd784a1c@ideasonboard.com> <20190302163400.GC4682@pendragon.ideasonboard.com>
 <CAN6+69+pRnH6zArTAa+2F-B9UDcKHE3DjLEQ0QHqP59CbmWTag@mail.gmail.com>
In-Reply-To: <CAN6+69+pRnH6zArTAa+2F-B9UDcKHE3DjLEQ0QHqP59CbmWTag@mail.gmail.com>
From:   Amila Manoj <amilamanoj@gmail.com>
Date:   Mon, 4 Mar 2019 15:07:36 +0100
Message-ID: <CAN6+69K4yG1p5MeXYxaE3ajGwN0UGpYDyuE_ODF0ZfUUQBsK0Q@mail.gmail.com>
Subject: Re: [linux-uvc-devel] HD Camera (4e45:5501) support
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Sending again as plain text to linux-media list.

On Mon, Mar 4, 2019 at 3:02 PM Amila Manoj <amilamanoj@gmail.com> wrote:
>
> Hello Laurent and Kieran,
>
> Thank you very much for the information.
>
> I haven't tried other uvc cameras on the system. This is a fresh Ubuntu installation.
>
> Installed all available updates for Ubuntu and now the version is: Ubuntu 18.04.2 LTS (4.15.0-45-generic)
>
> I set the quirk as Laurent instructed but the error seems to be same.
>
> dmesg output:
> [  +9,015628] usb 2-2: new SuperSpeed USB device number 5 using xhci_hcd
> [  +0,020584] usb 2-2: LPM exit latency is zeroed, disabling LPM.
> [  +0,000620] usb 2-2: New USB device found, idVendor=4e45, idProduct=5501
> [  +0,000006] usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> [  +0,000004] usb 2-2: Product: NSE-CAM
> [  +0,000004] usb 2-2: Manufacturer: NSE
> [  +0,001355] uvcvideo: Probing generic UVC device 2
> [  +0,000010] uvcvideo: Found format YUV 4:2:2 (UYVY).
> [  +0,000005] uvcvideo: - 1920x1080 (30.0 fps)
> [  +0,000009] uvcvideo: Found a Status endpoint (addr 82).
> [  +0,000004] uvcvideo: Found UVC 1.10 device NSE-CAM (4e45:5501)
> [  +0,000003] uvcvideo: Forcing device quirks to 0x100 by module parameter for testing purpose.
> [  +0,000002] uvcvideo: Please report required quirks to the linux-uvc-devel mailing list.
> [  +0,000010] uvcvideo: Added control 00000000-0000-0000-0000-000000000101/2 to device 2 entity 2
> [  +0,000005] uvcvideo: Adding mapping 'Brightness' to control 00000000-0000-0000-0000-000000000101/2.
> [  +0,000006] uvcvideo: Added control 00000000-0000-0000-0000-000000000101/3 to device 2 entity 2
> [  +0,000003] uvcvideo: Adding mapping 'Contrast' to control 00000000-0000-0000-0000-000000000101/3.
> [  +0,000005] uvcvideo: Added control 00000000-0000-0000-0000-000000000101/6 to device 2 entity 2
> [  +0,000004] uvcvideo: Adding mapping 'Hue' to control 00000000-0000-0000-0000-000000000101/6.
> [  +0,000005] uvcvideo: Added control 00000000-0000-0000-0000-000000000101/7 to device 2 entity 2
> [  +0,000004] uvcvideo: Adding mapping 'Saturation' to control 00000000-0000-0000-0000-000000000101/7.
> [  +0,000005] uvcvideo: Added control 00000000-0000-0000-0000-000000000101/8 to device 2 entity 2
> [  +0,000004] uvcvideo: Adding mapping 'Sharpness' to control 00000000-0000-0000-0000-000000000101/8.
> [  +0,000005] uvcvideo: Added control 00000000-0000-0000-0000-000000000101/10 to device 2 entity 2
> [  +0,000005] uvcvideo: Adding mapping 'White Balance Temperature' to control 00000000-0000-0000-0000-000000000101/10.
> [  +0,000005] uvcvideo: Added control 00000000-0000-0000-0000-000000000101/11 to device 2 entity 2
> [  +0,000004] uvcvideo: Adding mapping 'White Balance Temperature, Auto' to control 00000000-0000-0000-0000-000000000101/11.
> [  +0,000004] uvcvideo: Scanning UVC chain: OT 4 <- XU 3 <- PU 2 <- IT 1
> [  +0,000014] uvcvideo: Found a valid video chain (1 -> 4).
> [ +10,161183] uvcvideo: Failed to query (129) UVC probe control : -110 (exp. 34).
> [  +0,000009] uvcvideo: Failed to initialize the device (-5).
>
> "modinfo uvcvideo" output:
> filename:       /lib/modules/4.15.0-45-generic/kernel/drivers/media/usb/uvc/uvcvideo.ko
> version:        1.1.1
> license:        GPL
> description:    USB Video Class driver
> author:         Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> srcversion:     DBA8F055BDC0120170B3498
> alias:          usb:v*p*d*dc*dsc*dp*ic0Eisc01ip01in*
> alias:          usb:v*p*d*dc*dsc*dp*ic0Eisc01ip00in*
> alias:          usb:v2833p0211d*dc*dsc*dp*icFFisc01ip00in*
> alias:          usb:v2833p0201d*dc*dsc*dp*ic0Eisc01ip00in*
> alias:          usb:v1C4Fp3000d*dc*dsc*dp*ic0Eisc01ip00in*
> alias:          usb:v1B3Bp2951d*dc*dsc*dp*ic0Eisc01ip00in*
> alias:          usb:v19ABp1000d00*dc*dsc*dp*ic0Eisc01ip00in*
> alias:          usb:v19ABp1000d01[0-1]*dc*dsc*dp*ic0Eisc01ip00in*
> alias:          usb:v19ABp1000d012[0-6]dc*dsc*dp*ic0Eisc01ip00in*
> alias:          usb:v199Ep8102d*dc*dsc*dp*icFFisc01ip00in*
> alias:          usb:v18ECp3290d*dc*dsc*dp*ic0Eisc01ip00in*
> alias:          usb:v18ECp3288d*dc*dsc*dp*ic0Eisc01ip00in*
> alias:          usb:v18ECp3188d*dc*dsc*dp*ic0Eisc01ip00in*
> alias:          usb:v18CDpCAFEd*dc*dsc*dp*ic0Eisc01ip00in*
> alias:          usb:v1871p0516d*dc*dsc*dp*icFFisc01ip00in*
> alias:          usb:v1871p0306d*dc*dsc*dp*ic0Eisc01ip00in*
> alias:          usb:v17EFp480Bd*dc*dsc*dp*ic0Eisc01ip00in*
> alias:          usb:v17DCp0202d*dc*dsc*dp*ic0Eisc01ip00in*
> alias:          usb:v174Fp8A34d*dc*dsc*dp*ic0Eisc01ip00in*
> alias:          usb:v174Fp8A33d*dc*dsc*dp*ic0Eisc01ip00in*
> alias:          usb:v174Fp8A31d*dc*dsc*dp*ic0Eisc01ip00in*
> alias:          usb:v174Fp8A12d*dc*dsc*dp*ic0Eisc01ip00in*
> alias:          usb:v174Fp5931d*dc*dsc*dp*ic0Eisc01ip00in*
> alias:          usb:v174Fp5212d*dc*dsc*dp*ic0Eisc01ip00in*
> alias:          usb:v152Dp0310d*dc*dsc*dp*ic0Eisc01ip00in*
> alias:          usb:v13D3p5103d*dc*dsc*dp*ic0Eisc01ip00in*
> alias:          usb:v0E8Dp0004d*dc*dsc*dp*ic0Eisc01ip00in*
> alias:          usb:v0BD3p0555d*dc*dsc*dp*ic0Eisc01ip00in*
> alias:          usb:v0AC8p3420d*dc*dsc*dp*ic0Eisc01ip00in*
> alias:          usb:v0AC8p3410d*dc*dsc*dp*ic0Eisc01ip00in*
> alias:          usb:v0AC8p332Dd*dc*dsc*dp*ic0Eisc01ip00in*
> alias:          usb:v06F8p300Cd*dc*dsc*dp*ic0Eisc01ip00in*
> alias:          usb:v05E3p0505d*dc*dsc*dp*ic0Eisc01ip00in*
> alias:          usb:v05C8p0403d*dc*dsc*dp*ic0Eisc01ip00in*
> alias:          usb:v05ACp8600d*dc*dsc*dp*ic0Eisc01ip00in*
> alias:          usb:v05ACp8501d*dc*dsc*dp*ic0Eisc01ip00in*
> alias:          usb:v05A9p7670d*dc*dsc*dp*ic0Eisc01ip00in*
> alias:          usb:v05A9p264Ad*dc*dsc*dp*ic0Eisc01ip00in*
> alias:          usb:v05A9p2643d*dc*dsc*dp*ic0Eisc01ip00in*
> alias:          usb:v05A9p2641d*dc*dsc*dp*ic0Eisc01ip00in*
> alias:          usb:v05A9p2640d*dc*dsc*dp*ic0Eisc01ip00in*
> alias:          usb:v058Fp3820d*dc*dsc*dp*ic0Eisc01ip00in*
> alias:          usb:v04F2pB071d*dc*dsc*dp*ic0Eisc01ip00in*
> alias:          usb:v046Dp082Dd*dc*dsc*dp*ic0Eisc01ip00in*
> alias:          usb:v046Dp08C7d*dc*dsc*dp*icFFisc01ip00in*
> alias:          usb:v046Dp08C6d*dc*dsc*dp*icFFisc01ip00in*
> alias:          usb:v046Dp08C5d*dc*dsc*dp*icFFisc01ip00in*
> alias:          usb:v046Dp08C3d*dc*dsc*dp*icFFisc01ip00in*
> alias:          usb:v046Dp08C2d*dc*dsc*dp*icFFisc01ip00in*
> alias:          usb:v046Dp08C1d*dc*dsc*dp*icFFisc01ip00in*
> alias:          usb:v045Ep0723d*dc*dsc*dp*ic0Eisc01ip00in*
> alias:          usb:v045Ep0721d*dc*dsc*dp*ic0Eisc01ip00in*
> alias:          usb:v045Ep00F8d*dc*dsc*dp*ic0Eisc01ip00in*
> alias:          usb:v0458p706Ed*dc*dsc*dp*ic0Eisc01ip00in*
> alias:          usb:v0416pA91Ad*dc*dsc*dp*ic0Eisc01ip00in*
> depends:        videodev,videobuf2-core,videobuf2-v4l2,videobuf2-vmalloc,media
> retpoline:      Y
> intree:         Y
> name:           uvcvideo
> vermagic:       4.15.0-45-generic SMP mod_unload
> signat:         PKCS#7
> signer:
> sig_key:
> sig_hashalgo:   md4
> parm:           clock:Video buffers timestamp clock
> parm:           hwtimestamps:Use hardware timestamps (uint)
> parm:           nodrop:Don't drop incomplete frames (uint)
> parm:           quirks:Forced device quirks (uint)
> parm:           trace:Trace level bitmask (uint)
> parm:           timeout:Streaming control requests timeout (uint)
>
> In there anything else I could try?
>
> Thank you!
>
> Regards,
> Amila
>
> On Sat, Mar 2, 2019 at 5:34 PM Laurent Pinchart <laurent.pinchart@ideasonboard.com> wrote:
>>
>> Hello,
>>
>> On Thu, Feb 28, 2019 at 07:45:57PM +0000, Kieran Bingham wrote:
>> > Hi Amila,
>> >
>> > I believe this topic might get more attention on the linux-media mailing
>> > list (which I've added to Cc), but I have some comments below too:
>> >
>> > On 27/02/2019 16:41, Amila Manoj wrote:
>> > > Hello,
>> > >
>> > > I'm trying to get this camera working with Ubuntu 18 (4.15.0-20-generic
>> > > x86_64 GNU/Linux):
>> > >
>> > > http://www.nse-global.com/index.php?ac=article&at=read&did=445
>> > >
>> > > This camera is not listed under supported devices in
>> > > http://www.ideasonboard.org/uvc/#devices
>> > >
>> > > Device initialization fails and it doesn't get listed under /dev/video*
>> > >
>> > > In lsusb, the device is listed with just the vendor and product id's.
>> > >
>> > >
>> > > "lsusb" output:
>> > >
>> > > Bus 002 Device 007: ID 4e45:5501
>> > > Bus 002 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
>> > > Bus 001 Device 005: ID 8087:0a2b Intel Corp.
>> > > Bus 001 Device 004: ID 1e3d:2093 Chipsbank Microelectronics Co., Ltd CBM209x Flash Drive (OEM)
>> > > Bus 001 Device 003: ID 04f2:0833 Chicony Electronics Co., Ltd
>> > > Bus 001 Device 009: ID 17ef:6019 Lenovo
>> > > Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
>> > >
>> > >
>> > > "dmesg" output (with trace enabled):
>> > >
>> > > [Feb27 15:37] usb 2-1: new SuperSpeed USB device number 7 using xhci_hcd
>> > > [  +0.024687] usb 2-1: LPM exit latency is zeroed, disabling LPM.
>> > > [  +0.000632] usb 2-1: New USB device found, idVendor=4e45, idProduct=5501
>> > > [  +0.000005] usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
>> > > [  +0.000003] usb 2-1: Product: NSE-CAM
>> > > [  +0.000003] usb 2-1: Manufacturer: NSE
>> > > [  +0.001181] uvcvideo: Probing generic UVC device 1
>> > > [  +0.000009] uvcvideo: Found format YUV 4:2:2 (UYVY).
>> > > [  +0.000003] uvcvideo: - 1920x1080 (30.0 fps)
>> > > [  +0.000009] uvcvideo: Found a Status endpoint (addr 82).
>> > > [  +0.000003] uvcvideo: Found UVC 1.10 device NSE-CAM (4e45:5501)
>> > > [  +0.000009] uvcvideo: Added control 00000000-0000-0000-0000-000000000101/2 to device 1 entity 2
>> > > [  +0.000003] uvcvideo: Adding mapping 'Brightness' to control 00000000-0000-0000-0000-000000000101/2.
>> > > [  +0.000005] uvcvideo: Added control 00000000-0000-0000-0000-000000000101/3 to device 1 entity 2
>> > > [  +0.000003] uvcvideo: Adding mapping 'Contrast' to control 00000000-0000-0000-0000-000000000101/3.
>> > > [  +0.000003] uvcvideo: Added control 00000000-0000-0000-0000-000000000101/6 to device 1 entity 2
>> > > [  +0.000003] uvcvideo: Adding mapping 'Hue' to control 00000000-0000-0000-0000-000000000101/6.
>> > > [  +0.000003] uvcvideo: Added control 00000000-0000-0000-0000-000000000101/7 to device 1 entity 2
>> > > [  +0.000003] uvcvideo: Adding mapping 'Saturation' to control 00000000-0000-0000-0000-000000000101/7.
>> > > [  +0.000004] uvcvideo: Added control 00000000-0000-0000-0000-000000000101/8 to device 1 entity 2
>> > > [  +0.000003] uvcvideo: Adding mapping 'Sharpness' to control 00000000-0000-0000-0000-000000000101/8.
>> > > [  +0.000003] uvcvideo: Added control 00000000-0000-0000-0000-000000000101/10 to device 1 entity 2
>> > > [  +0.000004] uvcvideo: Adding mapping 'White Balance Temperature' to control 00000000-0000-0000-0000-000000000101/10.
>> > > [  +0.000003] uvcvideo: Added control 00000000-0000-0000-0000-000000000101/11 to device 1 entity 2
>> > > [  +0.000003] uvcvideo: Adding mapping 'White Balance Temperature, Auto' to control 00000000-0000-0000-0000-000000000101/11.
>> > > [  +0.000003] uvcvideo: Scanning UVC chain: OT 4 <- XU 3 <- PU 2 <- IT 1
>> > > [  +0.000010] uvcvideo: Found a valid video chain (1 -> 4).
>> > > [  +0.709208] usb 1-2: new low-speed USB device number 9 using xhci_hcd
>> > > [  +0.151295] usb 1-2: New USB device found, idVendor=17ef, idProduct=6019
>> > > [  +0.000005] usb 1-2: New USB device strings: Mfr=0, Product=2, SerialNumber=0
>> > > [  +0.000003] usb 1-2: Product: Lenovo Optical USB Mouse
>> > > [  +4.165317] input: Lenovo Optical USB Mouse as /devices/pci0000:00/0000:00:14.0/usb1/1-2/1-2:1.0/0003:17EF:6019.0006/input/input16
>> > > [  +0.059888] hid-generic 0003:17EF:6019.0006: input,hidraw0: USB HID v1.11 Mouse [Lenovo Optical USB Mouse] on usb-0000:00:14.0-2/input0
>> > > [  +5.055435] uvcvideo: UVC non compliance - GET_DEF(PROBE) not supported. Enabling workaround.
>> > > [  +5.119896] uvcvideo: Failed to query (129) UVC probe control : -110 (exp. 34).
>> >
>> > Hrm ... that ^ 'looks' like a bug we fixed a while back I think ...
>>
>> The camera times out when the driver tries to get the current value of
>> the UVC probe control. I would suspect a bug in the camera firmware that
>> makes it crash when it received the previous GET_DEF(PROBE) request.
>>
>> GET_DEF(PROBE) can be skipped entirely by setting the
>> UVC_QUIRK_PROBE_DEF quirk. Amila, could you please try that ? The
>> easiest way to do so is to disconnect the camera, set the quirk with
>>
>> echo 0x100 > /sys/module/uvcvideo/parameters/quirks
>>
>> (running as root, or with sudo) and reconnect the camera.
>>
>> > Have you tried other UVC cameras on this system?
>> > Are you able to try a later kernel version just to be sure?
>> >
>> >
>> > > [  +0.000007] uvcvideo: Failed to initialize the device (-5).
>> > > [ +25.599651] usbhid 2-1:1.2: can't add hid device: -110
>> > > [  +0.000031] usbhid: probe of 2-1:1.2 failed with error -110
>> > >
>> > >
>> > > "lsusb -d 4e45:5501 -v" output:
>> > >
>> > > Bus 002 Device 006: ID 4e45:5501
>> > > Device Descriptor:
>> > >   bLength                18
>> > >   bDescriptorType         1
>> > >   bcdUSB               3.00
>> > >   bDeviceClass          239 Miscellaneous Device
>> > >   bDeviceSubClass         2 ?
>> > >   bDeviceProtocol         1 Interface Association
>> > >   bMaxPacketSize0         9
>> > >   idVendor           0x4e45
>> > >   idProduct          0x5501
>> > >   bcdDevice            1.03
>> > >   iManufacturer           1 (error)
>> > >   iProduct                2 (error)
>> >
>> > These (error)s might be a bit of a concern...
>> >
>> > >   iSerial                 0
>> > >   bNumConfigurations      1
>> > >   Configuration Descriptor:
>> > >     bLength                 9
>> > >     bDescriptorType         2
>> > >     wTotalLength          249
>> > >     bNumInterfaces          3
>> > >     bConfigurationValue     1
>> > >     iConfiguration          3 (error)
>> > >     bmAttributes         0x80
>> > >       (Bus Powered)
>> > >     MaxPower              100mA
>> > >     Interface Association:
>> > >       bLength                 8
>> > >       bDescriptorType        11
>> > >       bFirstInterface         0
>> > >       bInterfaceCount         2
>> > >       bFunctionClass         14 Video
>> > >       bFunctionSubClass       3 Video Interface Collection
>> > >       bFunctionProtocol       0
>> > >       iFunction               0
>> > >     Interface Descriptor:
>> > >       bLength                 9
>> > >       bDescriptorType         4
>> > >       bInterfaceNumber        0
>> > >       bAlternateSetting       0
>> > >       bNumEndpoints           1
>> > >       bInterfaceClass        14 Video
>> > >       bInterfaceSubClass      1 Video Control
>> > >       bInterfaceProtocol      0
>> > >       iInterface              0
>> > >       VideoControl Interface Descriptor:
>> > >         bLength                13
>> > >         bDescriptorType        36
>> > >         bDescriptorSubtype      1 (HEADER)
>> > >         bcdUVC               1.10
>> > >         wTotalLength           81
>> > >         dwClockFrequency       48.000000MHz
>> > >         bInCollection           1
>> > >         baInterfaceNr( 0)       1
>> > >       VideoControl Interface Descriptor:
>> > >         bLength                18
>> > >         bDescriptorType        36
>> > >         bDescriptorSubtype      2 (INPUT_TERMINAL)
>> > >         bTerminalID             1
>> > >         wTerminalType      0x0201 Camera Sensor
>> > >         bAssocTerminal          0
>> > >         iTerminal               0
>> > >         wObjectiveFocalLengthMin      0
>> > >         wObjectiveFocalLengthMax      0
>> > >         wOcularFocalLength            0
>> > >         bControlSize                  3
>> > >         bmControls           0x00000000
>> > >       VideoControl Interface Descriptor:
>> > >         bLength                13
>> > >         bDescriptorType        36
>> > >         bDescriptorSubtype      5 (PROCESSING_UNIT)
>> > >         bUnitID                 2
>> > >         bSourceID               1
>> > >         wMaxMultiplier      16384
>> > >         bControlSize            3
>> > >         bmControls     0x0000105f
>> > >           Brightness
>> > >           Contrast
>> > >           Hue
>> > >           Saturation
>> > >           Sharpness
>> > >           White Balance Temperature
>> > >           White Balance Temperature, Auto
>> > >         iProcessing             0
>> > >         bmVideoStandards     0x 0
>> > >       VideoControl Interface Descriptor:
>> > >         bLength                28
>> > >         bDescriptorType        36
>> > >         bDescriptorSubtype      6 (EXTENSION_UNIT)
>> > >         bUnitID                 3
>> > >         guidExtensionCode         {ffffffff-ffff-ffff-ffff-ffffffffffff}
>> >
>> > Hrm ... Laurent - is that suspicious? or ok?
>>
>> An extension unit with no controls and a GUID set to all 1s. Sloppy
>> firmware, really :-) It shouldn't cause any issue, but it shows the
>> level of quality to expect from the device.
>>
>> Ideally these issues should be reported to the device manufacturer, but
>> that's pretty hard to do in practice.
>>
>> > >         bNumControl             0
>> > >         bNrPins                 1
>> > >         baSourceID( 0)          2
>> > >         bControlSize            3
>> > >         bmControls( 0)       0x00
>> > >         bmControls( 1)       0x00
>> > >         bmControls( 2)       0x00
>> > >         iExtension              0
>> > >       VideoControl Interface Descriptor:
>> > >         bLength                 9
>> > >         bDescriptorType        36
>> > >         bDescriptorSubtype      3 (OUTPUT_TERMINAL)
>> > >         bTerminalID             4
>> > >         wTerminalType      0x0101 USB Streaming
>> > >         bAssocTerminal          0
>> > >         bSourceID               3
>> > >         iTerminal               0
>> > >       Endpoint Descriptor:
>> > >         bLength                 7
>> > >         bDescriptorType         5
>> > >         bEndpointAddress     0x82  EP 2 IN
>> > >         bmAttributes            3
>> > >           Transfer Type            Interrupt
>> > >           Synch Type               None
>> > >           Usage Type               Data
>> > >         wMaxPacketSize     0x0040  1x 64 bytes
>> > >         bInterval               1
>> > >         bMaxBurst               0
>> > >     Interface Descriptor:
>> > >       bLength                 9
>> > >       bDescriptorType         4
>> > >       bInterfaceNumber        1
>> > >       bAlternateSetting       0
>> > >       bNumEndpoints           1
>> > >       bInterfaceClass        14 Video
>> > >       bInterfaceSubClass      2 Video Streaming
>> > >       bInterfaceProtocol      0
>> > >       iInterface              0
>> > >       VideoStreaming Interface Descriptor:
>> > >         bLength                            14
>> > >         bDescriptorType                    36
>> > >         bDescriptorSubtype                  1 (INPUT_HEADER)
>> > >         bNumFormats                         1
>> > >         wTotalLength                       71
>> > >         bEndPointAddress                  131
>> > >         bmInfo                              0
>> > >         bTerminalLink                       4
>> > >         bStillCaptureMethod                 1
>> > >         bTriggerSupport                     0
>> > >         bTriggerUsage                       0
>> > >         bControlSize                        1
>> > >         bmaControls( 0)                    27
>> > >       VideoStreaming Interface Descriptor:
>> > >         bLength                            27
>> > >         bDescriptorType                    36
>> > >         bDescriptorSubtype                  4 (FORMAT_UNCOMPRESSED)
>> > >         bFormatIndex                        1
>> > >         bNumFrameDescriptors                1
>> > >         guidFormat                            {55595659-0000-1000-8000-00aa00389b71}
>> > >         bBitsPerPixel                      16
>> > >         bDefaultFrameIndex                  1
>> > >         bAspectRatioX                       0
>> > >         bAspectRatioY                       0
>> > >         bmInterlaceFlags                 0x00
>> > >           Interlaced stream or variable: No
>> > >           Fields per frame: 2 fields
>> > >           Field 1 first: No
>> > >           Field pattern: Field 1 only
>> > >           bCopyProtect                      0
>> > >       VideoStreaming Interface Descriptor:
>> > >         bLength                            30
>> > >         bDescriptorType                    36
>> > >         bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
>> > >         bFrameIndex                         1
>> > >         bmCapabilities                   0x03
>> > >           Still image supported
>> > >           Fixed frame-rate
>> > >         wWidth                           1920
>> > >         wHeight                          1080
>> > >         dwMinBitRate                995328000
>> > >         dwMaxBitRate                995328000
>> > >         dwMaxVideoFrameBufferSize     4147200
>> > >         dwDefaultFrameInterval         333333
>> > >         bFrameIntervalType                  1
>> > >         dwFrameInterval( 0)            333333
>> > >       Endpoint Descriptor:
>> > >         bLength                 7
>> > >         bDescriptorType         5
>> > >         bEndpointAddress     0x83  EP 3 IN
>> > >         bmAttributes            2
>> > >           Transfer Type            Bulk
>> > >           Synch Type               None
>> > >           Usage Type               Data
>> > >         wMaxPacketSize     0x0400  1x 1024 bytes
>> > >         bInterval               0
>> > >         bMaxBurst              15
>> > >     Interface Descriptor:
>> > >       bLength                 9
>> > >       bDescriptorType         4
>> > >       bInterfaceNumber        2
>> > >       bAlternateSetting       0
>> > >       bNumEndpoints           1
>> > >       bInterfaceClass         3 Human Interface Device
>> > >       bInterfaceSubClass      0 No Subclass
>> > >       bInterfaceProtocol      0 None
>> > >       iInterface              0
>> > >         HID Device Descriptor:
>> > >           bLength                 9
>> > >           bDescriptorType        33
>> > >           bcdHID               1.11
>> > >           bCountryCode            0 Not supported
>> > >           bNumDescriptors         1
>> > >           bDescriptorType        34 Report
>> > >           wDescriptorLength      29
>> > >           Warning: incomplete report descriptor
>> > >           Report Descriptor: (length is 7)
>> > >             Item(Main  ): (null), data=none
>> > >             Item(Main  ): (null), data=none
>> > >             Item(Main  ): (null), data=none
>> > >             Item(Main  ): (null), data=none
>> > >             Item(Main  ): (null), data=none
>> > >             Item(Main  ): (null), data=none
>> > >             Item(Main  ): (null), data=none
>> > >       Endpoint Descriptor:
>> > >         bLength                 7
>> > >         bDescriptorType         5
>> > >         bEndpointAddress     0x81  EP 1 IN
>> > >         bmAttributes            3
>> > >           Transfer Type            Interrupt
>> > >           Synch Type               None
>> > >           Usage Type               Data
>> > >         wMaxPacketSize     0x0040  1x 64 bytes
>> > >         bInterval              10
>> > >         bMaxBurst               0
>> > > Device Status:     0x77e8
>> > >   (Bus Powered)
>> > >   U2 Enabled
>> > >   Debug Mode
>> > >
>> > >
>> > > I would appreciate any pointers to see if I can get this working.
>>
>> --
>> Regards,
>>
>> Laurent Pinchart
