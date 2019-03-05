Return-Path: <SRS0=h5dj=RI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C51A2C43381
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 15:51:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 76CF720657
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 15:51:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K3ad4fQP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727424AbfCEPvP (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Mar 2019 10:51:15 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:37923 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726250AbfCEPvP (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Mar 2019 10:51:15 -0500
Received: by mail-io1-f65.google.com with SMTP id p18so7423556ioh.5
        for <linux-media@vger.kernel.org>; Tue, 05 Mar 2019 07:51:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HdlymRau7S0uF1bhtV/A0i7c1F3nTNwzp+bs1eytHdc=;
        b=K3ad4fQPFlkH4vh3yl3mQPaMMExqm8iubms4ntxhpBkNFXtFo8oSxhRy8M+EbOzAx7
         wv5FburgXN5LbZpNWuswjvfzzcUEFQLpgbkBYeQ1Hh3DNvoqMoi9hwm8cs+KXwWL8pYl
         LAAho0tijIqw4T0FTxal2tG4Wk5xDvGwSI6yRKzj6ujxFQYUns3m4Xrk5QPq/qYQXS6A
         RN61i6Sg1VanDIOtdxBw1i+ndLrkhje7GSB+n3e+s0TacwPwLJIOeZITjgCsUnvo/Gn4
         SJ43o25MLfhitZheUVCX7CH+i5BWd+GnLkqhvSvGOR/ck72iAueD3WqOL+dPOa6LMmmV
         pjtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HdlymRau7S0uF1bhtV/A0i7c1F3nTNwzp+bs1eytHdc=;
        b=hJcW62HlH/VwmtkfggWvibtxKZwdWnI/YaQhTGdlyFt58ifGkbHpfFoJHSp2AAKfBY
         MTvam3hPRvZAxUTQPxsmEuePfzqbrJX/60z0119pZih3P/Nvz7fel2JstBC/95iACy0w
         i3dbQdbykWoWQkAn3PPtEzdZJKmszhOSX9ahf/eZ7OK/eXykmoCeffTPt4d+RkY7ugL3
         u7hgNk/jCDT7TJ8mOAr6tN5QT13GibYWS0JFMRb/DP4pCaqbYXZY548aT9eIsondYHxk
         C5b79sU90CCShuo0u4cwVlXDYB3EiBO5rBxMi9WMkSejlHak+1scfN7EyQwukAvt5rbG
         DgUQ==
X-Gm-Message-State: APjAAAUlvlTEE1af9ElpbX8b8AIYbOGd8mE/Kshs3+MtDBeal6VuEIDF
        1+5gHTalkxpGZ9EKfc3EYF5hDH1wMAIDODxAemI=
X-Google-Smtp-Source: APXvYqxAar+9nYB/bA5GkI/9fSU4up39WeS4zzaNxx08PMdI+27egfGxWiwpMOcOaa7KcedaNmlGNbsR4BaCEVxVdLs=
X-Received: by 2002:a5e:c30a:: with SMTP id a10mr426055iok.193.1551801073943;
 Tue, 05 Mar 2019 07:51:13 -0800 (PST)
MIME-Version: 1.0
References: <CAN6+69JTiWpiiOeRn2jAuW__sx2J2p8FWUts1SpLeUoAC=W4vQ@mail.gmail.com>
 <c8534224-e8eb-8b77-a4ac-bcdbfd784a1c@ideasonboard.com> <20190302163400.GC4682@pendragon.ideasonboard.com>
 <CAN6+69+pRnH6zArTAa+2F-B9UDcKHE3DjLEQ0QHqP59CbmWTag@mail.gmail.com> <20190305134607.GA10692@pendragon.ideasonboard.com>
In-Reply-To: <20190305134607.GA10692@pendragon.ideasonboard.com>
From:   Amila Manoj <amilamanoj@gmail.com>
Date:   Tue, 5 Mar 2019 16:50:47 +0100
Message-ID: <CAN6+69+0ucQ+SOqCpB3g0X+5MXEVhr7deZ8A2hS0kE_6XrjOnA@mail.gmail.com>
Subject: Re: [linux-uvc-devel] HD Camera (4e45:5501) support
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     Kieran Bingham <kieran.bingham@ideasonboard.com>,
        linux-uvc-devel@lists.sourceforge.net,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Laurent,

Thank you very much for the reply.

I tried it on a Windows 10 computer and it worked fine without
installing any additional software.

Also managed to capture USB traffic on Linux (didn't capture on Windows yet).
I don't see a lot of traffic, most of the messages are USB and USBHID
protocol messages for GET_STATUS, SET_FEATURE, GET_DESCRIPTOR etc.

There is only one USBVIDEO protocol message for GET_CUR (0x81). Seems
like this request fails the error "No such file or directory (-ENOENT)
(-2). Does this sound like a bug in firmware / cause for the error we
saw in dmesg output?

Here's the full text of USBVIDEO request and response:

REQUEST:

Frame 86: 64 bytes on wire (512 bits), 64 bytes captured (512 bits) on
interface 0
USB URB
    [Source: host]
    [Destination: 2.13.0]
    URB id: 0xffff89299a435600
    URB type: URB_SUBMIT ('S')
    URB transfer type: URB_CONTROL (0x02)
    Endpoint: 0x80, Direction: IN
    Device: 13
    URB bus id: 2
    Device setup request: relevant (0)
    Data: not present ('<')
    URB sec: 1551797452
    URB usec: 468271
    URB status: Operation now in progress (-EINPROGRESS) (-115)
    URB length [bytes]: 34
    Data length [bytes]: 0
    [Response in: 87]
    Interval: 0
    Start frame: 0
    Copy of Transfer Flags: 0x00000200
    Number of ISO descriptors: 0
    [bInterfaceClass: Video (0x0e)]
URB setup
bRequest: GET CUR (0x81)
Control Selector: Probe (0x01)
Interface: 0x01
Entity: 0x00
wLength: 34

RESPONSE:

Frame 87: 64 bytes on wire (512 bits), 64 bytes captured (512 bits) on
interface 0
USB URB
    [Source: 2.13.0]
    [Destination: host]
    URB id: 0xffff89299a435600
    URB type: URB_COMPLETE ('C')
    URB transfer type: URB_CONTROL (0x02)
    Endpoint: 0x80, Direction: IN
    Device: 13
    URB bus id: 2
    Device setup request: not relevant ('-')
    Data: present (0)
    URB sec: 1551797457
    URB usec: 587755
    URB status: No such file or directory (-ENOENT) (-2)
    URB length [bytes]: 0
    Data length [bytes]: 0
    [Request in: 86]
    [Time from request: 5.119484000 seconds]
    Unused Setup Header
    Interval: 0
    Start frame: 0
    Copy of Transfer Flags: 0x00000200
    Number of ISO descriptors: 0
    [bInterfaceClass: Video (0x0e)]
[Interface: 0x01]
[Entity: 0x00]
[Control Selector: Probe (0x01)]

Thank you!

Best regards,
Amila


On Tue, Mar 5, 2019 at 2:46 PM Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
>
> Hi Amila,
>
> On Mon, Mar 04, 2019 at 03:02:33PM +0100, Amila Manoj wrote:
> > Hello Laurent and Kieran,
> >
> > Thank you very much for the information.
> >
> > I haven't tried other uvc cameras on the system. This is a fresh Ubuntu
> > installation.
> >
> > Installed all available updates for Ubuntu and now the version is: Ubuntu
> > 18.04.2 LTS (4.15.0-45-generic)
> >
> > I set the quirk as Laurent instructed but the error seems to be same.
> >
> > dmesg output:
> > [  +9,015628] usb 2-2: new SuperSpeed USB device number 5 using xhci_hcd
> > [  +0,020584] usb 2-2: LPM exit latency is zeroed, disabling LPM.
> > [  +0,000620] usb 2-2: New USB device found, idVendor=4e45, idProduct=5501
> > [  +0,000006] usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> > [  +0,000004] usb 2-2: Product: NSE-CAM
> > [  +0,000004] usb 2-2: Manufacturer: NSE
> > [  +0,001355] uvcvideo: Probing generic UVC device 2
> > [  +0,000010] uvcvideo: Found format YUV 4:2:2 (UYVY).
> > [  +0,000005] uvcvideo: - 1920x1080 (30.0 fps)
> > [  +0,000009] uvcvideo: Found a Status endpoint (addr 82).
> > [  +0,000004] uvcvideo: Found UVC 1.10 device NSE-CAM (4e45:5501)
> > [  +0,000003] uvcvideo: Forcing device quirks to 0x100 by module parameter for
> > testing purpose.
> > [  +0,000002] uvcvideo: Please report required quirks to the linux-uvc-devel
> > mailing list.
> > [  +0,000010] uvcvideo: Added control 00000000-0000-0000-0000-000000000101/2 to
> > device 2 entity 2
> > [  +0,000005] uvcvideo: Adding mapping 'Brightness' to control
> > 00000000-0000-0000-0000-000000000101/2.
> > [  +0,000006] uvcvideo: Added control 00000000-0000-0000-0000-000000000101/3 to
> > device 2 entity 2
> > [  +0,000003] uvcvideo: Adding mapping 'Contrast' to control
> > 00000000-0000-0000-0000-000000000101/3.
> > [  +0,000005] uvcvideo: Added control 00000000-0000-0000-0000-000000000101/6 to
> > device 2 entity 2
> > [  +0,000004] uvcvideo: Adding mapping 'Hue' to control
> > 00000000-0000-0000-0000-000000000101/6.
> > [  +0,000005] uvcvideo: Added control 00000000-0000-0000-0000-000000000101/7 to
> > device 2 entity 2
> > [  +0,000004] uvcvideo: Adding mapping 'Saturation' to control
> > 00000000-0000-0000-0000-000000000101/7.
> > [  +0,000005] uvcvideo: Added control 00000000-0000-0000-0000-000000000101/8 to
> > device 2 entity 2
> > [  +0,000004] uvcvideo: Adding mapping 'Sharpness' to control
> > 00000000-0000-0000-0000-000000000101/8.
> > [  +0,000005] uvcvideo: Added control 00000000-0000-0000-0000-000000000101/10
> > to device 2 entity 2
> > [  +0,000005] uvcvideo: Adding mapping 'White Balance Temperature' to control
> > 00000000-0000-0000-0000-000000000101/10.
> > [  +0,000005] uvcvideo: Added control 00000000-0000-0000-0000-000000000101/11
> > to device 2 entity 2
> > [  +0,000004] uvcvideo: Adding mapping 'White Balance Temperature, Auto' to
> > control 00000000-0000-0000-0000-000000000101/11.
> > [  +0,000004] uvcvideo: Scanning UVC chain: OT 4 <- XU 3 <- PU 2 <- IT 1
> > [  +0,000014] uvcvideo: Found a valid video chain (1 -> 4).
>
> The GET_DEF(PROBE) is gone, this shows the quirk has been applied
> correctly.
>
> > [ +10,161183] uvcvideo: Failed to query (129) UVC probe control : -110 (exp.
> > 34).
>
> But this error still occurs :-(
>
> > [  +0,000009] uvcvideo: Failed to initialize the device (-5).
> >
> > "modinfo uvcvideo" output:
> > filename:       /lib/modules/4.15.0-45-generic/kernel/drivers/media/usb/uvc/
> > uvcvideo.ko
> > version:        1.1.1
> > license:        GPL
> > description:    USB Video Class driver
> > author:         Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > srcversion:     DBA8F055BDC0120170B3498
> > alias:          usb:v*p*d*dc*dsc*dp*ic0Eisc01ip01in*
> > alias:          usb:v*p*d*dc*dsc*dp*ic0Eisc01ip00in*
> > alias:          usb:v2833p0211d*dc*dsc*dp*icFFisc01ip00in*
> > alias:          usb:v2833p0201d*dc*dsc*dp*ic0Eisc01ip00in*
> > alias:          usb:v1C4Fp3000d*dc*dsc*dp*ic0Eisc01ip00in*
> > alias:          usb:v1B3Bp2951d*dc*dsc*dp*ic0Eisc01ip00in*
> > alias:          usb:v19ABp1000d00*dc*dsc*dp*ic0Eisc01ip00in*
> > alias:          usb:v19ABp1000d01[0-1]*dc*dsc*dp*ic0Eisc01ip00in*
> > alias:          usb:v19ABp1000d012[0-6]dc*dsc*dp*ic0Eisc01ip00in*
> > alias:          usb:v199Ep8102d*dc*dsc*dp*icFFisc01ip00in*
> > alias:          usb:v18ECp3290d*dc*dsc*dp*ic0Eisc01ip00in*
> > alias:          usb:v18ECp3288d*dc*dsc*dp*ic0Eisc01ip00in*
> > alias:          usb:v18ECp3188d*dc*dsc*dp*ic0Eisc01ip00in*
> > alias:          usb:v18CDpCAFEd*dc*dsc*dp*ic0Eisc01ip00in*
> > alias:          usb:v1871p0516d*dc*dsc*dp*icFFisc01ip00in*
> > alias:          usb:v1871p0306d*dc*dsc*dp*ic0Eisc01ip00in*
> > alias:          usb:v17EFp480Bd*dc*dsc*dp*ic0Eisc01ip00in*
> > alias:          usb:v17DCp0202d*dc*dsc*dp*ic0Eisc01ip00in*
> > alias:          usb:v174Fp8A34d*dc*dsc*dp*ic0Eisc01ip00in*
> > alias:          usb:v174Fp8A33d*dc*dsc*dp*ic0Eisc01ip00in*
> > alias:          usb:v174Fp8A31d*dc*dsc*dp*ic0Eisc01ip00in*
> > alias:          usb:v174Fp8A12d*dc*dsc*dp*ic0Eisc01ip00in*
> > alias:          usb:v174Fp5931d*dc*dsc*dp*ic0Eisc01ip00in*
> > alias:          usb:v174Fp5212d*dc*dsc*dp*ic0Eisc01ip00in*
> > alias:          usb:v152Dp0310d*dc*dsc*dp*ic0Eisc01ip00in*
> > alias:          usb:v13D3p5103d*dc*dsc*dp*ic0Eisc01ip00in*
> > alias:          usb:v0E8Dp0004d*dc*dsc*dp*ic0Eisc01ip00in*
> > alias:          usb:v0BD3p0555d*dc*dsc*dp*ic0Eisc01ip00in*
> > alias:          usb:v0AC8p3420d*dc*dsc*dp*ic0Eisc01ip00in*
> > alias:          usb:v0AC8p3410d*dc*dsc*dp*ic0Eisc01ip00in*
> > alias:          usb:v0AC8p332Dd*dc*dsc*dp*ic0Eisc01ip00in*
> > alias:          usb:v06F8p300Cd*dc*dsc*dp*ic0Eisc01ip00in*
> > alias:          usb:v05E3p0505d*dc*dsc*dp*ic0Eisc01ip00in*
> > alias:          usb:v05C8p0403d*dc*dsc*dp*ic0Eisc01ip00in*
> > alias:          usb:v05ACp8600d*dc*dsc*dp*ic0Eisc01ip00in*
> > alias:          usb:v05ACp8501d*dc*dsc*dp*ic0Eisc01ip00in*
> > alias:          usb:v05A9p7670d*dc*dsc*dp*ic0Eisc01ip00in*
> > alias:          usb:v05A9p264Ad*dc*dsc*dp*ic0Eisc01ip00in*
> > alias:          usb:v05A9p2643d*dc*dsc*dp*ic0Eisc01ip00in*
> > alias:          usb:v05A9p2641d*dc*dsc*dp*ic0Eisc01ip00in*
> > alias:          usb:v05A9p2640d*dc*dsc*dp*ic0Eisc01ip00in*
> > alias:          usb:v058Fp3820d*dc*dsc*dp*ic0Eisc01ip00in*
> > alias:          usb:v04F2pB071d*dc*dsc*dp*ic0Eisc01ip00in*
> > alias:          usb:v046Dp082Dd*dc*dsc*dp*ic0Eisc01ip00in*
> > alias:          usb:v046Dp08C7d*dc*dsc*dp*icFFisc01ip00in*
> > alias:          usb:v046Dp08C6d*dc*dsc*dp*icFFisc01ip00in*
> > alias:          usb:v046Dp08C5d*dc*dsc*dp*icFFisc01ip00in*
> > alias:          usb:v046Dp08C3d*dc*dsc*dp*icFFisc01ip00in*
> > alias:          usb:v046Dp08C2d*dc*dsc*dp*icFFisc01ip00in*
> > alias:          usb:v046Dp08C1d*dc*dsc*dp*icFFisc01ip00in*
> > alias:          usb:v045Ep0723d*dc*dsc*dp*ic0Eisc01ip00in*
> > alias:          usb:v045Ep0721d*dc*dsc*dp*ic0Eisc01ip00in*
> > alias:          usb:v045Ep00F8d*dc*dsc*dp*ic0Eisc01ip00in*
> > alias:          usb:v0458p706Ed*dc*dsc*dp*ic0Eisc01ip00in*
> > alias:          usb:v0416pA91Ad*dc*dsc*dp*ic0Eisc01ip00in*
> > depends:        videodev,videobuf2-core,videobuf2-v4l2,videobuf2-vmalloc,media
> > retpoline:      Y
> > intree:         Y
> > name:           uvcvideo
> > vermagic:       4.15.0-45-generic SMP mod_unload
> > signat:         PKCS#7
> > signer:
> > sig_key:
> > sig_hashalgo:   md4
> > parm:           clock:Video buffers timestamp clock
> > parm:           hwtimestamps:Use hardware timestamps (uint)
> > parm:           nodrop:Don't drop incomplete frames (uint)
> > parm:           quirks:Forced device quirks (uint)
> > parm:           trace:Trace level bitmask (uint)
> > parm:           timeout:Streaming control requests timeout (uint)
> >
> > In there anything else I could try?
>
> Have you tried connecting the camera to a Windows or Mac host to see if
> it works there ? I'd like to rule out the option of a defective camera.
>
> If that works, at this stage I would usually try to capture USB trafic
> when the camera is connected to a working host, and compare that with
> the requests sent by the uvcvideo driver. I'm afraid I can't help you
> with capturing USB trafic with Windows or Mac though.
>
> I would also recommend contacting the vendor to report the problem, just
> in case.
>
> --
> Regards,
>
> Laurent Pinchart
