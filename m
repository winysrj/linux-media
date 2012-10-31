Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:64335 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711Ab2JaK5m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Oct 2012 06:57:42 -0400
Received: by mail-ie0-f174.google.com with SMTP id k13so1812733iea.19
        for <linux-media@vger.kernel.org>; Wed, 31 Oct 2012 03:57:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <m3vcdr1ku9.fsf@ursa.amorsen.dk>
References: <1350838349-14763-1-git-send-email-fschaefer.oss@googlemail.com>
	<m3vcdr1ku9.fsf@ursa.amorsen.dk>
Date: Wed, 31 Oct 2012 07:57:42 -0300
Message-ID: <CALF0-+WHPbdg6eVS8cN00vfcN_HJLYfkWYN9kpRfDBAyOeFV0g@mail.gmail.com>
Subject: Re: [PATCH 00/23] em28xx: add support fur USB bulk transfers
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Benny Amorsen <benny+usenet@amorsen.dk>
Cc: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>,
	mchehab@redhat.com, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Oct 30, 2012 at 10:39 PM, Benny Amorsen <benny+usenet@amorsen.dk> wrote:
> Frank Schäfer <fschaefer.oss@googlemail.com> writes:
>
>> This patch series adds support for USB bulk transfers to the em28xx driver.
>
> I tried these patches on my Raspberry Pi, 3.6.1 kernel, Nanostick 290e
>
> options em28xx prefer_bulk=1 core_debug=1 usb_debug=1
> options em28xx_dvb debug=1
>
> [    5.469510] em28xx: New device PCTV Systems PCTV 290e @ 480 Mbps (2013:024f, interface 0, class 0)
> [    5.890637] em28xx: DVB interface 0 found
> [    6.025292] em28xx #0: chip ID is em28174
> [    6.515383] em28xx #0: Identified as PCTV nanoStick T2 290e (card=78)
> [    6.567066] em28xx #0: v4l2 driver version 0.1.3
> [    6.614720] em28xx #0 em28xx_set_alternate :minimum isoc packet size: 2888 (alt=0)
> [    6.663064] em28xx #0 em28xx_set_alternate :setting alternate 0 with wMaxPacketSize=0
> [    6.715934] em28xx #0 em28xx_accumulator_set :em28xx Scale: (1,1)-(179,143)
> [    6.765694] em28xx #0 em28xx_capture_area_set :em28xx Area Set: (180,144)
> [    6.793060] em28xx #0: V4L2 video device registered as video0
> [    6.808200] em28xx #0 em28xx_alloc_urbs :em28xx: called em28xx_alloc_isoc in mode 2
> [    6.819456] em28xx #0: no endpoint for DVB mode and transfer type 1
> [    6.829283] em28xx: Failed to pre-allocate USB transfer buffers for DVB.
> [    6.839454] em28xx: probe of 1-1.3.1:1.0 failed with error -22
> [    6.852511] usbcore: registered new interface driver em28xx
> [    7.255738] em28xx #0 em28xx_accumulator_set :em28xx Scale: (1,1)-(179,143)
> [    7.291575] em28xx #0 em28xx_capture_area_set :em28xx Area Set: (180,144)
> [    7.326200] em28xx #0 em28xx_uninit_usb_xfer :em28xx: called em28xx_uninit_usb_xfer in mode 1
>
> Is the Nanostick 290e just fundamentally incompatible with bulk
> transfers, or is there hope yet?
>
> It works great with isochronous transfers on my PC and the Fedora
> kernel, but the Raspberry USB host blows up when trying to do
> isochronous mode.
>
>

Isn't this completely OT?

Anyway, RPI has known issues regarding USB bandwidth.

See here

https://github.com/ezequielgarcia/stk1160-standalone/issues/8
https://github.com/ezequielgarcia/stk1160-standalone/issues/2
http://www.raspberrypi.org/phpBB3/viewtopic.php?p=196918#p196918

Regards,

    Ezequiel
