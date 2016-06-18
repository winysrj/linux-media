Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f170.google.com ([209.85.220.170]:36065 "EHLO
	mail-qk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbcFRQ4Z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Jun 2016 12:56:25 -0400
Received: by mail-qk0-f170.google.com with SMTP id p10so117119663qke.3
        for <linux-media@vger.kernel.org>; Sat, 18 Jun 2016 09:56:25 -0700 (PDT)
Received: from mail-qk0-f178.google.com (mail-qk0-f178.google.com. [209.85.220.178])
        by smtp.gmail.com with ESMTPSA id p13sm14907509qkh.21.2016.06.18.09.56.24
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 18 Jun 2016 09:56:24 -0700 (PDT)
Received: by mail-qk0-f178.google.com with SMTP id s186so117361483qkc.1
        for <linux-media@vger.kernel.org>; Sat, 18 Jun 2016 09:56:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <abfe17ade84725100f405e5b1f6228b8@webmail.meine-oma.de>
References: <abfe17ade84725100f405e5b1f6228b8@webmail.meine-oma.de>
From: Olli Salonen <olli.salonen@iki.fi>
Date: Sat, 18 Jun 2016 19:56:23 +0300
Message-ID: <CAAZRmGy2qezuyX=p7-Twm6ibWzsRxVh1+HvME-Lj5fCYUk6exg@mail.gmail.com>
Subject: Re: dvb usb stick Hauppauge WinTV-soloHD
To: Thomas Stein <himbeere@meine-oma.de>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Thomas,

Please reboot your PC, run w_scan and then send the full output of
dmesg command. Maybe the driver has printed something in the logs that
can help us narrow the cause.

Cheers,
-olli

On 18 June 2016 at 18:55, Thomas Stein <himbeere@meine-oma.de> wrote:
> Hello.
>
> I'm trying to get a dvb usb stick Hauppauge WinTV-soloHD running. I saw
> there is general support already in the kernel.
> https://git.linuxtv.org/media_tree.git/commit/?id=1efc21701d94ed0c5b91467b042bed8b8becd5cc
>
> I'm able to use this device for dvb-t but not dvb-t2. I'm living in berlin
> so it should work. w_scan is scanning dvb-t2 and seems
> to find channels:
>
> Scanning DVB-T2...
> Scanning 7MHz frequencies...
> 177500: (time: 02:17.828)
> 184500: (time: 02:19.828)
> 191500: (time: 02:21.876)
> 198500: (time: 02:23.924)
> 205500: (time: 02:25.971)
> 212500: (time: 02:27.971)
> 219500: (time: 02:30.021)
> 226500: (time: 02:32.071)
> Scanning 8MHz frequencies...
> 474000: (time: 02:34.120)
> 482000: (time: 02:36.121)
> 490000: (time: 02:38.169)
> 498000: (time: 02:40.219)
> 506000: skipped (already known transponder)
> 514000: (time: 02:42.268)
> 522000: skipped (already known transponder)
> 530000: (time: 02:44.318)
> 538000: (time: 02:46.368)
> 546000: (time: 02:48.417)
> 554000: (time: 02:50.417)
> 562000: (time: 02:52.467)
> 570000: skipped (already known transponder)
> 578000: (time: 02:54.467)
> 586000: (time: 02:56.469)
> 594000: (time: 02:58.469)
> 602000: (time: 03:00.518)
> 610000: (time: 03:02.567)
> 618000: skipped (already known transponder)
> 626000: (time: 03:04.617)
> 634000: (time: 03:06.617)
> 642000: (time: 03:08.667)         signal ok:    QAM_AUTO f = 642000 kHz
> I999B8C999D999T999G999Y999P0 (0:0:0)
>         QAM_AUTO f = 642000 kHz I999B8C999D999T999G999Y999P0 (0:0:0) :
> updating transport_stream_id: -> (0:0:16481)
>         QAM_AUTO f = 642000 kHz I999B8C999D999T999G999Y999P0 (0:0:16481) :
> updating network_id -> (0:12352:16481)
>         QAM_AUTO f = 642000 kHz I999B8C999D999T999G999Y999P0 (0:12352:16481)
> : updating original_network_id -> (8468:12352:16481)
>         updating transponder:
>            (QAM_AUTO f = 642000 kHz I999B8C999D999T999G999Y999P0
> (8468:12352:16481)) 0x0000
>         to (QAM_AUTO f = 650000 kHz I999B8C999D999T32G16Y999P0
> (8468:12352:16481)) 0x4004
>         new transponder: (QAM_AUTO f = 642000 kHz I999B8C0D0T32G16Y0P1
> (8468:12352:16497)) 0x4004
> 650000: skipped (already known transponder)
> 658000: skipped (already known transponder)
> 666000: (time: 03:10.382)
> 674000: (time: 03:12.429)
> 682000: skipped (already known transponder)
> 690000: (time: 03:14.476)
> 698000: (time: 03:16.528)
> 706000: skipped (already known transponder)
> 714000: (time: 03:18.575)
> 722000: (time: 03:20.623)
> 730000: (time: 03:22.669)
> 738000: (time: 03:24.716)
> 746000: (time: 03:26.764)
> 754000: skipped (already known transponder)
> 762000: (time: 03:28.811)
> 770000: (time: 03:30.860)
> 778000: skipped (already known transponder)
> 786000: (time: 03:32.908)
> 794000: (time: 03:34.953)
> 802000: (time: 03:36.999)
> 810000: (time: 03:39.045)
> 818000: (time: 03:41.045)
> 826000: (time: 03:43.091)
> 834000: (time: 03:45.137)
> 842000: (time: 03:47.185)
> 850000: (time: 03:49.231)
> 858000: (time: 03:51.277)
>
> So the question is, what is going wrong? When i start vlc with dvb-t2
> channels file for berlin i get:
>
> [00007f7e0c01a0e8] ts demux error: cannot peek
>
> Any hints appreciated.
>
> cheers
> t.
