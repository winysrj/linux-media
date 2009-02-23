Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:32226 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753693AbZBWW5x (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Feb 2009 17:57:53 -0500
Received: by fg-out-1718.google.com with SMTP id 16so24394fgg.17
        for <linux-media@vger.kernel.org>; Mon, 23 Feb 2009 14:57:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <37843.1235429340@iinet.net.au>
References: <37843.1235429340@iinet.net.au>
Date: Mon, 23 Feb 2009 17:57:50 -0500
Message-ID: <37219a840902231457k20895709j7b9416a48128547e@mail.gmail.com>
Subject: Re: running multiple DVB cards successfully.. what do I need to
	know?? (major and minor numbers??)
From: Michael Krufky <mkrufky@linuxtv.org>
To: sonofzev@iinet.net.au
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Feb 23, 2009 at 5:49 PM, sonofzev@iinet.net.au
<sonofzev@iinet.net.au> wrote:
> Some of you may have read some of my posts about an "incorrect firmware readback"
> message appearing in my dmesg, shortly after a tuner was engaged.
>
> I have isolated this problem, but the workaround so far has not been pretty.
> On a hunch I removed my Dvico Fusion HDTV lite card from the system, running now
> only with the Dvico Fusion Dual Express.
>
> The issue has gone, I am not getting the kdvb process hogging cpu cycles and this
> message has stopped.
>
> I had tried both letting the kernel (or is it udev) assign the major and minor
> numbers and I had tried to manually set them via modprobe.conf (formerly
> modules.conf, I don't know if this is a global change or specific to Gentoo)....
>
> I had the major number the same for both cards, with a separate minor number for
> each of the three tuners, this seems to be the same.
>
> Is this how I should be setting up for 2 cards or should I be using some other
> type of configuration.

Allan,

I recommend to use the 'adapter_nr' module option.  You can specify
this option in modprobe.conf -- the name of this file is
distro-specific.

For instance, to make the dual card appear before the lite card:

options cx23885 adapter_nr=0,1
options dvb-bt8xx adapter_nr=2

to make the lite card appear before the dual card:

options cx23885 adapter_nr=0
options dvb-bt8xx adapter_nr=1,2

I hope you find this helpful.

Regards,

Mike
