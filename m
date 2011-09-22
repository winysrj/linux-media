Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34589 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892Ab1IVPJY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Sep 2011 11:09:24 -0400
Received: by bkbzt4 with SMTP id zt4so2585883bkb.19
        for <linux-media@vger.kernel.org>; Thu, 22 Sep 2011 08:09:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110922164508.395c2900@skate>
References: <20110921135604.64363a2e@skate>
	<CAGoCfiyFbHcZO-Rz2VFr249NprqvhQhcSPBLHRj_Txs9gimYqA@mail.gmail.com>
	<20110922164508.395c2900@skate>
Date: Thu, 22 Sep 2011 11:09:22 -0400
Message-ID: <CAGoCfiy_RVbgq+3WTsC=ZrJsOfDYEWUov6meOU8=ShACBM7J2g@mail.gmail.com>
Subject: Re: cx231xx: DMA problem on ARM
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: linux-media@vger.kernel.org, srinivasa.deevi@conexant.com,
	Maxime Ripard <maxime.ripard@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Sep 22, 2011 at 10:45 AM, Thomas Petazzoni
<thomas.petazzoni@free-electrons.com> wrote:
> Hello,
>
> Le Wed, 21 Sep 2011 08:04:52 -0400,
> Devin Heitmueller <dheitmueller@kernellabs.com> a écrit :
>
>> I ran into the same issue on em28xx in the past (which is what those
>> parts of cx231xx are based on).  Yes, just adding
>> URB_NO_TRANSFER_DMA_MAP should result in it starting to work.  Please
>> try that out, and assuming it works feel free to submit a patch which
>> can be included upstream.
>
> So, we did try with URB_NO_TRANSFER_DMA_MAP, and now, we don't have the
> BUG_ON() assertion anymore, but instead a large set of error messages:
>
> [  325.856231] cx231xx #0:  setPowerMode::mode = 48, No Change req.
> [  325.858398] cx231xx #0: cx231xx_stop_stream():: ep_mask = 8
> [  325.860656] cx231xx #0:  setPowerMode::mode = 48, No Change req.
> [  326.144073] cx231xx #0: cx231xx_stop_stream():: ep_mask = 8
> [  326.151245] cx231xx #0: cx231xx_initialize_stream_xfer: set video registers
> [  326.151763] cx231xx #0: cx231xx_start_stream():: ep_mask = 8
> [  396.907318] cx231xx #0: UsbInterface::sendCommand, failed with status --71
> [  396.912048] cx231xx #0: UsbInterface::sendCommand, failed with status --71
> [  396.977355] cx231xx #0: cx231xx_stop_stream():: ep_mask = 8
> [  396.987091] cx231xx #0: can't change interface 3 alt no. to 0 (err=-71)
> [  456.665252] cx231xx #0:  setPowerMode::mode = 48, No Change req.
> [  456.675292] cx231xx #0: cannot change alt number to 3 (error=-71)
> [  456.714508] cx231xx #0: UsbInterface::sendCommand, failed with status --71
> [  456.718811] cx231xx #0: UsbInterface::sendCommand, failed with status --71
> [  456.719635] cx231xx #0: cx231xx_stop_stream():: ep_mask = 8
> [  456.729522] cx231xx #0: can't change interface 3 alt no. to 0 (err=-71)
> [  456.750427] cx231xx #0:  setPowerMode::mode = 48, No Change req.
> [  456.756317] cx231xx #0: cannot change alt number to 3 (error=-71)
> [  456.778625] cx231xx #0: UsbInterface::sendCommand, failed with status --71
> [  456.782745] cx231xx #0: UsbInterface::sendCommand, failed with status --71
> [  456.786987] cx231xx #0: UsbInterface::sendCommand, failed with status --71
> [  456.791381] cx231xx #0: UsbInterface::sendCommand, failed with status --71
> [  456.795501] cx231xx #0: UsbInterface::sendCommand, failed with status --71
> [  456.795532] cx231xx #0: cx231xx_set_decoder_video_input: adjust_ref_count :Failed to setAFE input mux - errCode [-71]!
> [  456.841491] cx231xx #0: UsbInterface::sendCommand, failed with status --71
> [  456.845642] cx231xx #0: UsbInterface::sendCommand, failed with status --71
> [  456.849792] cx231xx #0: UsbInterface::sendCommand, failed with status --71
> [  456.854003] cx231xx #0: UsbInterface::sendCommand, failed with status --71
> [  456.858123] cx231xx #0: UsbInterface::sendCommand, failed with status --71
> [  456.862274] cx231xx #0: UsbInterface::sendCommand, failed with status --71
> [  456.866394] cx231xx #0: UsbInterface::sendCommand, failed with status --71
> [  456.870513] cx231xx #0: UsbInterface::sendCommand, failed with status --71
> [  456.875030] cx231xx #0: UsbInterface::sendCommand, failed with status --71
> [  456.879150] cx231xx #0: UsbInterface::sendCommand, failed with status --71
> [  456.883239] cx231xx #0: UsbInterface::sendCommand, failed with status --71
> [  456.887390] cx231xx #0: UsbInterface::sendCommand, failed with status --71
> [  456.891632] cx231xx #0: UsbInterface::sendCommand, failed with status --71
> [  456.895751] cx231xx #0: UsbInterface::sendCommand, failed with status --71
> [  456.899993] cx231xx #0: UsbInterface::sendCommand, failed with status --71
> [  456.904174] cx231xx #0: UsbInterface::sendCommand, failed with status --71
> [  456.914825] cx231xx #0: UsbInterface::sendCommand, failed with status --71
> [  456.919036] cx231xx #0: UsbInterface::sendCommand, failed with status --71
> [  456.924499] cx231xx #0: UsbInterface::sendCommand, failed with status --71
> [  456.936920] cx231xx #0: UsbInterface::sendCommand, failed with status --71
> [  456.941131] cx231xx #0: UsbInterface::sendCommand, failed with status --71
> [  456.946655] cx231xx #0: UsbInterface::sendCommand, failed with status --71
> [  456.960144] cx231xx #0: UsbInterface::sendCommand, failed with status --71
> [  456.968658] cx231xx #0: UsbInterface::sendCommand, failed with status --71
> [  456.984344] cx231xx #0: UsbInterface::sendCommand, failed with status --71
> [  456.999572] cx231xx #0: UsbInterface::sendCommand, failed with status --71
> [  457.004577] cx231xx #0: UsbInterface::sendCommand, failed with status --71
> [  457.015014] cx231xx #0: UsbInterface::sendCommand, failed with status --71
> [  457.019561] cx231xx #0: UsbInterface::sendCommand, failed with status --71
> [  457.029083] cx231xx #0: UsbInterface::sendCommand, failed with status --71
> [  457.033264] cx231xx #0: UsbInterface::sendCommand, failed with status --71
> [  457.039031] cx231xx #0: UsbInterface::sendCommand, failed with status --71
> [  457.043121] cx231xx #0: UsbInterface::sendCommand, failed with status --71
> [  457.047332] cx231xx #0: UsbInterface::sendCommand, failed with status --71
> [  457.051513] cx231xx #0: UsbInterface::sendCommand, failed with status --71
> [  457.059631] cx231xx #0: UsbInterface::sendCommand, failed with status --71
> [  457.066467] cx231xx #0: UsbInterface::sendCommand, failed with status --71
> [  457.071624] cx231xx #0: UsbInterface::sendCommand, failed with status --71
> [  457.084686] cx231xx #0: UsbInterface::sendCommand, failed with status --71
> [  457.088897] cx231xx #0: UsbInterface::sendCommand, failed with status --71
> [  457.093658] cx231xx #0: UsbInterface::sendCommand, failed with status --71
> [  457.097747] cx231xx #0: UsbInterface::sendCommand, failed with status --71
> [  457.102050] cx231xx #0: UsbInterface::sendCommand, failed with status --71
> [  457.106109] cx231xx #0: UsbInterface::sendCommand, failed with status --71
> [  457.110229] cx231xx #0: UsbInterface::sendCommand, failed with status --71
> [  457.114318] cx231xx #0: UsbInterface::sendCommand, failed with status --71
> [  457.118469] cx231xx #0: UsbInterface::sendCommand, failed with status --71
> [  457.122589] cx231xx #0: UsbInterface::sendCommand, failed with status --71
> [  457.126708] cx231xx #0: UsbInterface::sendCommand, failed with status --71
> [  457.130828] cx231xx #0: UsbInterface::sendCommand, failed with status --71
> [  457.134979] cx231xx #0: UsbInterface::sendCommand, failed with status --71
> [  457.139068] cx231xx #0: UsbInterface::sendCommand, failed with status --71
> [  457.139099] cx231xx #0: video_mux : 0
> [  457.139099] cx231xx #0: do_mode_ctrl_overrides : 0xb000
> [  457.143218] cx231xx #0: UsbInterface::sendCommand, failed with status --71
> [  457.143249] cx231xx #0: do_mode_ctrl_overrides NTSC
> [  457.147308] cx231xx #0: UsbInterface::sendCommand, failed with status --71
> [  457.151519] cx231xx #0: UsbInterface::sendCommand, failed with status --71
> [  457.156250] cx231xx #0: UsbInterface::sendCommand, failed with status --71
> [  457.163269] cx231xx #0: UsbInterface::sendCommand, failed with status --71
> [  457.169647] cx231xx #0: UsbInterface::sendCommand, failed with status --71
> [  457.175415] cx231xx #0: UsbInterface::sendCommand, failed with status --71
> [  457.179779] cx231xx #0: UsbInterface::sendCommand, failed with status --71
> [  457.183898] cx231xx #0: UsbInterface::sendCommand, failed with status --71
> [  457.183929] cx25840 4-0044: 720x480 is not a valid size!
> [  457.228576] cx231xx #0: cx231xx_stop_stream():: ep_mask = 8
> [  457.238769] cx231xx #0: cx231xx_initialize_stream_xfer: set video registers
> [  457.251892] cx231xx #0: UsbInterface::sendCommand, failed with status --71
> [  457.256011] cx231xx #0: UsbInterface::sendCommand, failed with status --71
> [  519.125091] cx231xx #0: cx231xx_stop_stream():: ep_mask = 8
> [  519.137359] cx231xx #0: can't change interface 3 alt no. to 0 (err=-71)
>
> The exact same device, connected to a x86 machine running the 3.0
> kernel works just fine. We have diff'ed the cx231xx driver of both
> kernels, and they are exactly the same, except for the
> URB_NO_TRANSFER_DMA_MAP, which isn't strictly needed on x86.
>
> Here is the patch that we apply on the cx231xx driver of the 3.0
> kernel. The dont_use_port_3 part is a backport of a later kernel
> version (commit 992299e84a4891275ea5924e30b66ce39a701e5e).

Hi Thomas,

Ok, that is a good start.  I would definitely submit that as a patch
(including your Signed-off-by line).

Regarding the outstanding issue, I believe I did see that and fixed
it.  Please look the history for the various cx231xx files surrounding
the time of the ".dont_use_port_3 = 1" fix.  If I recall, that patch
was actually part of a series of two or three patches which were
required for that device to work properly.  I believe the other patch
needed included an extra 10ms msleep call to ensure the hardware is
powered up fully before issuing certain i2c commands (which are what
are causing the -71 errors).

If you cannot find it, let me know and I will dig around my archives
and find it for you (I'm actually at work right now so it would be
inopportune for me to do it right this minute).

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
