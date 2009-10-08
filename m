Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f210.google.com ([209.85.218.210]:65109 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756644AbZJHTEz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Oct 2009 15:04:55 -0400
Received: by bwz6 with SMTP id 6so1066909bwz.37
        for <linux-media@vger.kernel.org>; Thu, 08 Oct 2009 12:04:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <C3EF2005C0C34F008FA0B59B48782D75@MirekPNB>
References: <2D9D466571BB4CCEB9FD981D65F8FBFC@MirekPNB>
	 <829197380910080736g4b30e0e8m21f1d3b876a15ce6@mail.gmail.com>
	 <C3EF2005C0C34F008FA0B59B48782D75@MirekPNB>
Date: Thu, 8 Oct 2009 15:04:17 -0400
Message-ID: <829197380910081204r6b8c779dsf32c61b718df77f0@mail.gmail.com>
Subject: Re: Pinnace 320e (PCTV Hybrid Pro Stick) support
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Miroslav Pragl <lists.subscriber@pragl.cz>,
	SebaX75 <sebax75@yahoo.it>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Oct 8, 2009 at 2:23 PM, Miroslav Pragl
<lists.subscriber@pragl.cz> wrote:
> Devin,
> thank you very much.
>
> I downloaded, compiled and installed drivers from current (today) hg
> repository o linuxtv.org, attached Pinnacle dongle, scanned.
>
> The log files are quite large so i ZIPed them and made available at
> http://pragl.com/tmp/em28xx_logs.zip
> They are:
>
> 1. messages.txt - relevant paert of /var/log/messages after plugging the
> dongle in
>
> 2. scan.txt - output from `scan cz-Praha` (my location) you can see scan
> locks on first frequency (634000000), finds correctly couple of channels
> then fails on other frequencies
>
> 3. scan2.txt - same scan but I commented-out 1st frequency (634000000) so
> scan successfully starts from following one (674000000) and the situation
> repeats - only this one gets scanned, following are not
>
> Hope I described it clearly :)
>
> I really appreciate your help

Interesting.  I just looked at SebaX75's usbmon trace, and I have a
suspicion as to what is going on.  If one of you is feeling
adventurous, try the following

unplug the device
comment out line 181 of file v4l/em28xx-cards.c so it looks like:

//   {EM2880_R04_GPO,        0x04,   0xff,          100},/* zl10353 reset */

make && make install && make unload
plug in device
Attempt a scan

Let me know if that causes it to lock on more than just the first frequency.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
