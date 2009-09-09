Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:49529 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752293AbZIISUb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Sep 2009 14:20:31 -0400
Received: by fxm17 with SMTP id 17so3573735fxm.37
        for <linux-media@vger.kernel.org>; Wed, 09 Sep 2009 11:20:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <c2885d2b0909091113h2ae6e27ai7541b3efac0e4606@mail.gmail.com>
References: <200909091814.10092.animatrix30@gmail.com>
	 <829197380909090919o613827d0ye00cbfe3bde888ed@mail.gmail.com>
	 <c2885d2b0909091113h2ae6e27ai7541b3efac0e4606@mail.gmail.com>
Date: Wed, 9 Sep 2009 14:20:33 -0400
Message-ID: <829197380909091120h45f1a21eoe2aa576acbf3a4ac@mail.gmail.com>
Subject: Re: Invalid module format
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: "animatrix30@gmail.com" <animatrix30@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Sep 9, 2009 at 2:13 PM,
animatrix30@gmail.com<animatrix30@gmail.com> wrote:
> Without mrechberger version, I can't find support for my Pinnacle PCTV Usb
> stick.
> If I had it, (after having installed the mrec driver), I have this error :
>
> [  909.128197] em28xx v4l2 driver version 0.0.1 loaded
> [  909.128518] em28xx: new video device (eb1a:2870): interface 0, class 255
> [  909.128521] em28xx: device is attached to a USB 2.0 bus
> [  909.128525] em28xx #0: Alternate settings: 8
> [  909.128527] em28xx #0: Alternate setting 0, max size= 0
> [  909.128530] em28xx #0: Alternate setting 1, max size= 0
> [  909.128532] em28xx #0: Alternate setting 2, max size= 1448
> [  909.128535] em28xx #0: Alternate setting 3, max size= 2048
> [  909.128537] em28xx #0: Alternate setting 4, max size= 2304
> [  909.128540] em28xx #0: Alternate setting 5, max size= 2580
> [  909.128543] em28xx #0: Alternate setting 6, max size= 2892
> [  909.128545] em28xx #0: Alternate setting 7, max size= 3072
> [  909.545514] input: em2880/em2870 remote control as /class/input/input12
> [  909.545548] em28xx-input.c: remote control handler attached
> [  909.545551] em28xx #0: Found Pinnacle PCTV DVB-T
> [  909.545571] usbcore: registered new interface driver em28xx
> [  909.595321] em28xx_dvb: Unknown symbol em28xx_set_mode
> [  909.595461] em28xx_dvb: Unknown symbol em28xx_uninit_isoc
> [  909.595547] em28xx_dvb: Unknown symbol em28xx_init_isoc
> [  909.595678] em28xx_dvb: disagrees about version of symbol
> em28xx_unregister_extension
> [  909.595681] em28xx_dvb: Unknown symbol em28xx_unregister_extension
> [  909.596137] em28xx_dvb: disagrees about version of symbol
> em28xx_register_extension
> [  909.596140] em28xx_dvb: Unknown symbol em28xx_register_extension
> [  909.596355] em28xx_dvb: Unknown symbol em28xx_tuner_callback
>
>
> What should I do ?
>
> Thanks!
<snip>

If you built mrec's driver from source, it may not have picked up the
latest v4l headers.  If you are trying to use his binary package, then
you have to use whatever kernel he compiled it against (and you cannot
install the latest v4l-dvb tree).

Assuming you're talking about the model 70e, I have a tree setup for
that device, but it's not yet fully debugged:

http://www.kernellabs.com/hg/~dheitmueller/pctv-70e

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
