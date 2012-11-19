Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:46561 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752686Ab2KSALN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Nov 2012 19:11:13 -0500
Message-ID: <50A97901.5040501@iki.fi>
Date: Mon, 19 Nov 2012 02:10:41 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Philippe Valembois - Phil <lephilousophe@users.sourceforge.net>
CC: linux-media@vger.kernel.org, greg@kroah.com
Subject: Re: Hauppauge WinTV HVR 900 (M/R 65018/B3C0) doesn't work anymore
 since linux 3.6.6
References: <50A3FF56.3070703@users.sourceforge.net>
In-Reply-To: <50A3FF56.3070703@users.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/14/2012 10:30 PM, Philippe Valembois - Phil wrote:
> Hello,
> I have posted a bug report here :
> https://bugzilla.kernel.org/show_bug.cgi?id=50361 and I have been told
> to send it to the ML too.
>
> The commit causing the bug has been pushed to kernel between linux-3.5
> and linux-3.6.
>
> Here is my bug summary :
>
> The WinTV HVR900 DVB-T usb stick has stopped working in Linux 3.6.6.
> The tuner fails at tuning and no DVB channel can be watched.
>
> Reverting the commit 3de9e9624b36263618470c6e134f22eabf8f2551 fixes the
> problem
> and the tuner can tune again. It still seems there is some delay between the
> moment when the USB stick is plugged and when it can tune : running
> dvbscan too
> fast makes the first channels tuning fail but after several seconds it tunes
> perfectly.
>
> Don't hesitate to ask me for additional debug.


There is multiple models of that device. What is your device USB ID?
What it outputs to the system log when stick is plugged? Use dmesg 
command to see and copy paste output.

Your device supports DVB-C, DVB-T and analog? You tested only DVB-T?


I just tested quite many em28xx based sticks with stock 3.6.6 and all 
seems to work just fine. All em28xx devices I have here are digital 
only, which makes me wonder if it has something to do with hybrid 
devices (digital + analog)...

regards
Antti

-- 
http://palosaari.fi/
