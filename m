Return-path: <linux-media-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.26]:2399 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758402AbZFIOGS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Jun 2009 10:06:18 -0400
Received: by qw-out-2122.google.com with SMTP id 5so2484713qwd.37
        for <linux-media@vger.kernel.org>; Tue, 09 Jun 2009 07:06:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <625E57E0-150D-40A1-AF90-7B0112D16931@flyn.org>
References: <4f363d5e6b409da696b35f7e2a966952.squirrel@mail.voxel.net>
	 <829197380906071921g54469ee7uac77c10d380a7e0a@mail.gmail.com>
	 <625E57E0-150D-40A1-AF90-7B0112D16931@flyn.org>
Date: Tue, 9 Jun 2009 10:06:20 -0400
Message-ID: <829197380906090706h1f287623m979811f6c0b5956e@mail.gmail.com>
Subject: Re: funny colors from XC5000 on big endian systems
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: "W. Michael Petullo" <mike@flyn.org>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jun 8, 2009 at 7:09 PM, W. Michael Petullo <mike@flyn.org> wrote:
> I have a VCR connected to my 950Q using the coaxial interface.
>
> Kernel is 2.6.29.4.
>
> I am using streamer from Fedora's xawtv-3.95-11.fc11.ppc:
>
> v4lctl setchannel 3
> streamer -r 30 -s 640x480 -f jpeg -i Television -n NTSC-M -c /dev/video0 -o
> ~/Desktop/foo.avi -t 00:60:00
>
> I am using gstreamer-plugins-good-0.10.14-2.fc11.ppc:
>
> gst-launch v4l2src ! ffmpegcolorspace ! ximagesink
>
> Mike

Hello Mike,

Just a quick follow up, I was up until 1am debugging this issue. It
appears that a couple of the ioctl calls are failing when negotiating
the capabilities of the analog support.  As a result, the gstreamer
v4l code is falling back to a default colorspace.

The command I sent you should be good enough for it to work for you,
but I obviously need to debug this further so that the autonegotiation
works properly.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
