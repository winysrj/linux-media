Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f205.google.com ([209.85.217.205]:45984 "EHLO
	mail-gx0-f205.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637AbZHSQcu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Aug 2009 12:32:50 -0400
Received: by gxk1 with SMTP id 1so6128692gxk.17
        for <linux-media@vger.kernel.org>; Wed, 19 Aug 2009 09:32:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A8C2611.9050002@nildram.co.uk>
References: <4A8C2611.9050002@nildram.co.uk>
Date: Wed, 19 Aug 2009 12:32:50 -0400
Message-ID: <829197380908190932v4bc1e06eofc82c7fef03ee02d@mail.gmail.com>
Subject: Re: Problem with Hauppauge Nova-500
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: lotway@nildram.co.uk
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Aug 19, 2009 at 12:19 PM, Lou Otway<lotway@nildram.co.uk> wrote:
> Hi there,
>
> I have a Hauppauge Nova-T 500 that is displaying some odd behaviour.
>
> Often the device fails to tune after rebooting the host machine, due to a
> failure to load firmware.
>
> when the firmware fails to load, dmesg shows:
>
> dib0700: loaded with support for 9 different device-types
> dvb-usb: found a 'Hauppauge Nova-T 500 Dual DVB-T' in cold state, will try
> to load a firmware
> dvb-usb: downloading firmware from file 'dvb-usb-dib0700-1.20.fw'
> dib0700: firmware download failed at 7 with -22
> usbcore: registered new interface driver dvb_usb_dib0700
>
> When firmware loading is successful I see:
>
> dib0700: loaded with support for 9 different device-types
> dvb-usb: found a 'Hauppauge Nova-T 500 Dual DVB-T' in warm state.
> dvb-usb: will pass the complete MPEG2 transport stream to the software
> demuxer.
> DVB: registering new adapter (Hauppauge Nova-T 500 Dual DVB-T)
> DVB: registering adapter 1 frontend 0 (DiBcom 3000MC/P)...
> MT2060: successfully identified (IF1 = 1242)
> dvb-usb: will pass the complete MPEG2 transport stream to the software
> demuxer.
> DVB: registering new adapter (Hauppauge Nova-T 500 Dual DVB-T)
> DVB: registering adapter 2 frontend 0 (DiBcom 3000MC/P)...
> MT2060: successfully identified (IF1 = 1233)
> input: IR-receiver inside an USB DVB receiver as /class/input/input7
> dvb-usb: schedule remote query interval to 50 msecs.
> dvb-usb: Hauppauge Nova-T 500 Dual DVB-T successfully initialized and
> connected.
> usbcore: registered new interface driver dvb_usb_dib0700
>
> Powering down the host machine seems to help as, so far, I have 100% success
> when restarting this way, whereas after reboot the success is much lower,
> firmware failing to load maybe 50% of the time.
>
> Has anyone seen this behaviour before, any advice on what the cause might
> be?
>
> Many thanks,
>
> Lou

Hello Lou,

Yes, this is a known issue with the Nova-T 500 that others have
reported.  We believe it has something to do with the onboard Via USB
host controller on the board.  A user mailed me a card and it is out
being repaired, but hopefully when it comes back I will be able to
track down the problem.

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
