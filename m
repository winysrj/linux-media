Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:38680 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754971Ab0GLJ2h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Jul 2010 05:28:37 -0400
Received: by yxk8 with SMTP id 8so881908yxk.19
        for <linux-media@vger.kernel.org>; Mon, 12 Jul 2010 02:28:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100712101802.08527e82@tele>
References: <AANLkTinFXtHdN6DoWucGofeftciJwLYv30Ll6f_baQtH@mail.gmail.com>
	<20100707074431.66629934@tele> <AANLkTimxJi3qvIImwUDZCzWSCC3fEspjAyeXg9Qkneyo@mail.gmail.com>
	<20100707110613.18be4215@tele> <AANLkTim6xCtIMxZj3f4wpY6eZTrJBEv6uvVZZoiX-mg6@mail.gmail.com>
	<20100708121454.75db358c@tele> <AANLkTilw1KxYanoQZEZVaiFCLfkdTpO72Z9xV73i4gm2@mail.gmail.com>
	<20100709200312.755e8069@tele> <AANLkTikxIJxuQiV_7PqPA5C6ZU5XhhmmQ3hAbIwWsrPT@mail.gmail.com>
	<20100710113616.1ed63ebc@tele> <AANLkTikrKBpRSI6wVdMO3tSYPhm1CECFGeNiyJdzTa03@mail.gmail.com>
	<20100711155008.1f8f583f@tele> <AANLkTinnNhJ-DoFWfU8U5NuTj_p48SefYzWWAxZqiUb-@mail.gmail.com>
	<20100712101802.08527e82@tele>
From: Kyle Baker <kyleabaker@gmail.com>
Date: Mon, 12 Jul 2010 05:28:15 -0400
Message-ID: <AANLkTinUHyTHt78ihMHy8dzz0kfPvUMBXKreRmuM-cYW@mail.gmail.com>
Subject: Re: Microsoft VX-1000 Microphone Drivers Crash in x86_64
To: Jean-Francois Moine <moinejf@free.fr>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jul 12, 2010 at 4:18 AM, Jean-Francois Moine <moinejf@free.fr> wrote:
> The video capture is started in sd_start(). Checking all sequences
> again, I found that the GPIO is also set near line 1752. May you comment
> it and test?

I tested this and it did not show any different results.

> Otherwise, here is a way to know the exact bad USB exchange.
[snip]
> After installation, connect the webcam and set the gspca debug level to
> 0xcf:
>        echo 0xcf > /sys/module/gspca_main/parameters/debug

I'm unable to set the debug level due to the following error:
bash: /sys/module/gspca_main/parameters/debug: Permission denied

I even tried as sudo. The debug file contents are "3" with no quotes at runtime.

I worked around this by changing "PDEBUG(D_USBO, ..." to
"PDEBUG(D_PROBE, ..." and I think I've found the exact point that the
microphone is cut off.

> Check if the webcam microphone is working, and look at the kernel
> messages by:
>        tail -f /var/log/messages

Microphone is working at this point still with no unusual messages.

> Then, start the video capture. You should see each USB exchange in the
> 'tail' window. When the audio stops, the bad exchange is the one just
> printed...
>
> If the audio stopped before any exchange, this could mean that something
> went wrong when setting the alternate setting or on URB creation.

This didn't appear to be the case. I tested it 5-6 times to verify
that I saw the correct line.

Here is the exchange from plugging in my webcam until I quit Cheese.
The point that the mic quits is at
"[  224.692515] sonixj-2.9.51: reg_w1 [0002] = 62"
as far as I can tell. I hope this sheds some light on the issue.
Repeating this several times appears to show the same values each
time, so it may be a GPIO setting that is incorrect. I don't
understand the driver code as intricately as you.

Jul 12 05:03:47 kyleabaker-desktop kernel: [  117.600025] usb 2-10:
new full speed USB device using ohci_hcd and address 4
Jul 12 05:03:47 kyleabaker-desktop kernel: [  117.832495] Linux video
capture interface: v2.00
Jul 12 05:03:47 kyleabaker-desktop kernel: [  117.835301] gspca: main
v2.9.0 registered
Jul 12 05:03:47 kyleabaker-desktop kernel: [  117.836042]
gspca-2.9.51: probing 045e:00f7
Jul 12 05:03:48 kyleabaker-desktop kernel: [  118.840036]
sonixj-2.9.51: reg_w1 [00f1] = 01
Jul 12 05:03:49 kyleabaker-desktop kernel: [  119.850013]
sonixj-2.9.51: reg_w1 [00f1] = 00
Jul 12 05:03:49 kyleabaker-desktop kernel: [  119.854147]
sonixj-2.9.51: Sonix chip id: 11
Jul 12 05:03:50 kyleabaker-desktop kernel: [  120.860022]
sonixj-2.9.51: reg_w [0001] = 29 74 ..
Jul 12 05:03:51 kyleabaker-desktop kernel: [  121.872517]
sonixj-2.9.51: reg_w1 [00f1] = 00
Jul 12 05:03:51 kyleabaker-desktop kernel: [  121.874230] input:
sonixj as /devices/pci0000:00/0000:00:02.0/usb2/2-10/input/input4
Jul 12 05:03:51 kyleabaker-desktop kernel: [  121.874315]
gspca-2.9.51: video0 created
Jul 12 05:03:51 kyleabaker-desktop kernel: [  121.874318]
gspca-2.9.51: found int in endpoint: 0x83, buffer_len=1, interval=100
Jul 12 05:03:51 kyleabaker-desktop kernel: [  121.874337]
gspca-2.9.51: 045e:00f7 bad interface 1
Jul 12 05:03:51 kyleabaker-desktop kernel: [  121.874345]
gspca-2.9.51: 045e:00f7 bad interface 2
Jul 12 05:03:51 kyleabaker-desktop kernel: [  121.874361] usbcore:
registered new interface driver sonixj
Jul 12 05:03:51 kyleabaker-desktop kernel: [  121.874363] sonixj: registered
Jul 12 05:03:51 kyleabaker-desktop kernel: [  121.970290] usbcore:
registered new interface driver snd-usb-audio
Jul 12 05:05:22 kyleabaker-desktop kernel: [  212.443063]
gspca-2.9.51: found int in endpoint: 0x83, buffer_len=1, interval=100
Jul 12 05:05:23 kyleabaker-desktop kernel: [  213.450017]
sonixj-2.9.51: reg_w1 [0001] = 61
Jul 12 05:05:24 kyleabaker-desktop kernel: [  214.460030]
sonixj-2.9.51: reg_w [0001] = 61 44 ..
Jul 12 05:05:25 kyleabaker-desktop kernel: [  215.472516]
sonixj-2.9.51: reg_w [0008] = 81 21 ..
Jul 12 05:05:26 kyleabaker-desktop kernel: [  216.480018]
sonixj-2.9.51: reg_w [0017] = 20 07 ..
Jul 12 05:05:27 kyleabaker-desktop kernel: [  217.490018]
sonixj-2.9.51: reg_w [009a] = 00 40 ..
Jul 12 05:05:28 kyleabaker-desktop kernel: [  218.500019]
sonixj-2.9.51: reg_w [00d4] = 60 00 ..
Jul 12 05:05:29 kyleabaker-desktop kernel: [  219.518667]
sonixj-2.9.51: reg_w [0003] = 00 1a ..
Jul 12 05:05:30 kyleabaker-desktop kernel: [  220.532524]
sonixj-2.9.51: reg_w1 [0001] = 63
Jul 12 05:05:31 kyleabaker-desktop kernel: [  221.542516]
sonixj-2.9.51: reg_w1 [0017] = 20
Jul 12 05:05:32 kyleabaker-desktop kernel: [  222.559770]
sonixj-2.9.51: reg_w1 [0001] = 62
Jul 12 05:05:33 kyleabaker-desktop kernel: [  223.570016]
sonixj-2.9.51: reg_w1 [0001] = 42
Jul 12 05:05:34 kyleabaker-desktop kernel: [  224.692515]
sonixj-2.9.51: reg_w1 [0002] = 62
Jul 12 05:05:36 kyleabaker-desktop kernel: [  226.690016]
sonixj-2.9.51: reg_w1 [0002] = 40
Jul 12 05:05:37 kyleabaker-desktop kernel: [  227.700014]
sonixj-2.9.51: reg_w1 [0002] = 40
Jul 12 05:05:38 kyleabaker-desktop kernel: [  228.720016]
sonixj-2.9.51: reg_w1 [0015] = 28
Jul 12 05:05:39 kyleabaker-desktop kernel: [  229.730020]
sonixj-2.9.51: reg_w1 [0016] = 1e
Jul 12 05:05:40 kyleabaker-desktop kernel: [  230.742519]
sonixj-2.9.51: reg_w1 [0012] = 01
Jul 12 05:05:41 kyleabaker-desktop kernel: [  231.750015]
sonixj-2.9.51: reg_w1 [0013] = 01
Jul 12 05:05:42 kyleabaker-desktop kernel: [  232.760073]
sonixj-2.9.51: reg_w1 [0018] = 07
Jul 12 05:05:43 kyleabaker-desktop kernel: [  233.770014]
sonixj-2.9.51: reg_w1 [00d2] = 6a
Jul 12 05:05:44 kyleabaker-desktop kernel: [  234.790030]
sonixj-2.9.51: reg_w1 [00d3] = 50
Jul 12 05:05:45 kyleabaker-desktop kernel: [  235.792515]
sonixj-2.9.51: reg_w1 [00c6] = 00
Jul 12 05:05:46 kyleabaker-desktop kernel: [  236.802516]
sonixj-2.9.51: reg_w1 [00c7] = 00
Jul 12 05:05:47 kyleabaker-desktop kernel: [  237.810018]
sonixj-2.9.51: reg_w1 [00c8] = 50
Jul 12 05:05:48 kyleabaker-desktop kernel: [  238.830014]
sonixj-2.9.51: reg_w1 [00c9] = 3c
Jul 12 05:05:49 kyleabaker-desktop kernel: [  239.832516]
sonixj-2.9.51: reg_w1 [0018] = 07
Jul 12 05:05:50 kyleabaker-desktop kernel: [  240.840017]
sonixj-2.9.51: reg_w1 [0017] = a0
Jul 12 05:05:51 kyleabaker-desktop kernel: [  241.850068]
sonixj-2.9.51: reg_w1 [0005] = 00
Jul 12 05:05:52 kyleabaker-desktop kernel: [  242.860017]
sonixj-2.9.51: reg_w1 [0007] = 00
Jul 12 05:05:53 kyleabaker-desktop kernel: [  243.870016]
sonixj-2.9.51: reg_w1 [0006] = 00
Jul 12 05:05:54 kyleabaker-desktop kernel: [  244.880016]
sonixj-2.9.51: reg_w1 [0014] = 08
Jul 12 05:05:55 kyleabaker-desktop kernel: [  245.890305]
sonixj-2.9.51: reg_w [0020] = 00 2d ..
Jul 12 05:05:56 kyleabaker-desktop kernel: [  246.900017]
sonixj-2.9.51: reg_w [0084] = 14 00 ..
Jul 12 05:05:57 kyleabaker-desktop kernel: [  247.910015]
sonixj-2.9.51: reg_w [0084] = 14 00 ..
Jul 12 05:05:58 kyleabaker-desktop kernel: [  248.920015]
sonixj-2.9.51: reg_w [0084] = 14 00 ..
Jul 12 05:05:59 kyleabaker-desktop kernel: [  249.940014]
sonixj-2.9.51: reg_w [0084] = 14 00 ..
Jul 12 05:06:00 kyleabaker-desktop kernel: [  250.950019]
sonixj-2.9.51: reg_w [0084] = 14 00 ..
Jul 12 05:06:01 kyleabaker-desktop kernel: [  251.960015]
sonixj-2.9.51: reg_w [0084] = 14 00 ..
Jul 12 05:06:02 kyleabaker-desktop kernel: [  252.970014]
sonixj-2.9.51: reg_w [0084] = 14 00 ..
Jul 12 05:06:03 kyleabaker-desktop kernel: [  253.980306]
sonixj-2.9.51: reg_w [0084] = 14 00 ..
Jul 12 05:06:04 kyleabaker-desktop kernel: [  254.997213]
sonixj-2.9.51: reg_w1 [009a] = 05
Jul 12 05:06:05 kyleabaker-desktop kernel: [  256.000020]
sonixj-2.9.51: reg_w1 [0099] = 5a
Jul 12 05:06:06 kyleabaker-desktop kernel: [  257.010014]
sonixj-2.9.51: reg_w [0084] = 14 00 ..
Jul 12 05:06:07 kyleabaker-desktop kernel: [  258.026869]
sonixj-2.9.51: reg_w1 [0005] = 20
Jul 12 05:06:08 kyleabaker-desktop kernel: [  259.030015]
sonixj-2.9.51: reg_w1 [0007] = 20
Jul 12 05:06:09 kyleabaker-desktop kernel: [  260.050023]
sonixj-2.9.51: reg_w1 [0006] = 20
Jul 12 05:06:11 kyleabaker-desktop kernel: [  261.400021]
sonixj-2.9.51: reg_w [00c0] = 2d 2d ..
Jul 12 05:06:12 kyleabaker-desktop kernel: [  262.410019]
sonixj-2.9.51: reg_w [00ca] = 28 d8 ..
Jul 12 05:06:13 kyleabaker-desktop kernel: [  263.420015]
sonixj-2.9.51: reg_w [00ce] = 32 dd ..
Jul 12 05:06:14 kyleabaker-desktop kernel: [  264.430016]
sonixj-2.9.51: reg_w1 [0018] = 47
Jul 12 05:06:15 kyleabaker-desktop kernel: [  265.442517]
sonixj-2.9.51: reg_w1 [0018] = 07
Jul 12 05:06:16 kyleabaker-desktop kernel: [  266.450016]
sonixj-2.9.51: reg_w1 [0017] = 22
Jul 12 05:06:17 kyleabaker-desktop kernel: [  267.460025]
sonixj-2.9.51: reg_w1 [0001] = 06
Jul 12 05:06:18 kyleabaker-desktop kernel: [  268.470016]
sonixj-2.9.51: reg_w1 [0096] = 00
Jul 12 05:06:19 kyleabaker-desktop kernel: [  269.480018]
sonixj-2.9.51: reg_w [0084] = 14 00 ..
Jul 12 05:06:20 kyleabaker-desktop kernel: [  270.497626]
sonixj-2.9.51: reg_w [008a] = e8 0f ..
Jul 12 05:06:21 kyleabaker-desktop kernel: [  271.602523]
sonixj-2.9.51: reg_w1 [0001] = 61
Jul 12 05:06:22 kyleabaker-desktop kernel: [  272.612517]
sonixj-2.9.51: reg_w1 [0017] = 20
Jul 12 05:06:23 kyleabaker-desktop kernel: [  273.620018]
sonixj-2.9.51: reg_w1 [0001] = 61
Jul 12 05:06:24 kyleabaker-desktop kernel: [  274.640013]
sonixj-2.9.51: reg_w1 [0001] = 0b
Jul 12 05:06:24 kyleabaker-desktop kernel: [  274.644749]
gspca-2.9.51: found int in endpoint: 0x83, buffer_len=1, interval=100

> BTW, your webcam is connected to a USB 1.1 port with the driver
> ohci_hcd. Have you some USB 2.0 port that you could use?

I know my computer has USB 2.0 ports, but they all seem to be falling
back to 1.1 (if thats what you're seeing them as). I understand the
bandwidth is greater in USB 2.0, but are there other problems that
would be causing this?

Thanks, I think we may be getting somewhere now.

-- 
Kyle Baker
