Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f174.google.com ([209.85.218.174]:40533 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345AbZEJFYk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 May 2009 01:24:40 -0400
Received: by bwz22 with SMTP id 22so2047573bwz.37
        for <linux-media@vger.kernel.org>; Sat, 09 May 2009 22:24:40 -0700 (PDT)
Message-ID: <4A066501.7090707@gmail.com>
Date: Sun, 10 May 2009 07:24:17 +0200
From: David Lister <foceni@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org,
	"g.sergi@tiscali.it" <g.sergi@tiscali.it>
CC: "www.linuxtv.org" <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Technisat SkyStar USB 2 HD CI
References: <23093212.796221241882652744.JavaMail.defaultUser@defaultHost>
In-Reply-To: <23093212.796221241882652744.JavaMail.defaultUser@defaultHost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

g.sergi@tiscali.it wrote:
> Hi,
> I have Technisat SkyStar USB 2 HD CI
> I use Ubuntu 9.04
> I need help 
> to make it work
> Thank you

I don't know if it's the same HW as SkyStar HD2, but if it is (you
_will_ know) exchange it for a cx2388x-based card (Hauppauge, TeVii,
etc) or even saa7134-based card (KNC One, Mystique) while you can.
SkyStar HD2 was a real nightmare - generally unstable, S2 mostly
unusable, reports of frequently corrupted picture (all channels), very
low sensitivity, some things not supported by the driver for over 3
years (HW signal, SNR, BER reporting; CI). Few weeks ago, I had three
PCI SS-HD2+CI cards with the newest driver (tried all other repositories
as well) and I had to return them all. While I was still trying, many
people contacted me with the same experiences. It might work for some
people under certain conditions, but are you willing to take the risk,
when there are cards with high quality HW, better tuner, sensitivity &
Linux support for the same price?

-- 
Dave
