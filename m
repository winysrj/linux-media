Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:34854 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282Ab3AaLjV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Jan 2013 06:39:21 -0500
Received: by mail-wg0-f43.google.com with SMTP id e12so1904072wge.34
        for <linux-media@vger.kernel.org>; Thu, 31 Jan 2013 03:39:19 -0800 (PST)
Message-ID: <510A57E3.3050505@googlemail.com>
Date: Thu, 31 Jan 2013 11:39:15 +0000
From: Chris Clayton <chris2553@googlemail.com>
MIME-Version: 1.0
CC: linux-media@vger.kernel.org
Subject: Re: 3.8.0-rc4+ - Oops on removing WinTV-HVR-1400 expresscard TV Tuner
References: <51016937.1020202@googlemail.com>
In-Reply-To: <51016937.1020202@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/24/13 17:02, Chris Clayton wrote:
> Hi,
>
> I've today taken delivery of a WinTV-HVR-1400 expresscard TV Tuner and
> got an Oops when I removed from the expresscard slot in my laptop. I
> will quite understand if the response to this report is "don't do
> that!", but in that case, how should one remove one of these cards?
>
Just to close this down on the linux-media list, the problem was that I 
was removing the card whilst the driver was running. (I expected to be 
able to do so because Windows 7 seems to handle it.) The cx23885 driver 
is not sufficiently robust to handle this sudden removal of the card. I 
now make sure that the drivers are unloaded before removing the card.

I'll report separately that scandvb finds no dvb-t channels :-(

Chris

> I have attached three files:
>
> 1. the dmesg output from when I rebooted the machine after the oops. I
> have turned debugging on in the dib700p and cx23885 modules via modules
> options in /etc/modprobe.d/hvr1400.conf;
>
> 2. the .config file for the kernel that oopsed.
>
> 3. the text of the oops message. I've typed this up from a photograph of
> the screen because the laptop was locked up and there was nothing in the
> log files. Apologies for any typos, but I have tried to be careful.
>
> Assuming the answer isn't don't do that, let me know if I can provide
> any additional diagnostics, test any patches, etc. Please, however, cc
> me as I'm not subscribed.
>
> Chris
