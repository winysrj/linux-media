Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:56264 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755767Ab0AFOgY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jan 2010 09:36:24 -0500
Received: by fxm25 with SMTP id 25so10742339fxm.21
        for <linux-media@vger.kernel.org>; Wed, 06 Jan 2010 06:36:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <63a62e0a1001060200r11e440abt84daf0822fcb3e8d@mail.gmail.com>
References: <829197381001040936w3bc9b4e0w22eecded4687d9d3@mail.gmail.com>
	 <63a62e0a1001060200r11e440abt84daf0822fcb3e8d@mail.gmail.com>
Date: Wed, 6 Jan 2010 09:36:22 -0500
Message-ID: <829197381001060636x311a7bddw73d5e5cb30320dea@mail.gmail.com>
Subject: Re: Call for Testers - dib0700 IR improvements
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Harald Gustafsson <hgu1972@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jan 6, 2010 at 5:00 AM, Harald Gustafsson <hgu1972@gmail.com> wrote:
> Hi,
>
> Thanks for working on improving the Nova T 500 performance, it is much
> appreciated, and let me know if you need further help with debugging it.
>
> I tried your dib0700-ir tree. My problems with the Nova T 500 and the 1.20
> firmware have been warm reboots. Before your patch a warm reboot would give
> I2C errors in dmesg log with the 1.20 FW, hence I have only used my machine
> with cold boots since my upgrade this xmas. With the 1.10 FW and Ubuntu 7.04
> + v4l tip sometime in 2008 the system have run without much problems
> including frequent warm reboots for 2 years. Sorry to say this patch does
> not solve the problem to have a working IR after a warm reboot see dmesg
> logs below. I have not seen any problems with high load before, so can't
> give any info on that matter more than it is certainly low now. The I2C
> errors I saw before your patch come shortly after a warm reboot (see last
> dmesg log included), but have not had any problems after cold boots for the
> past week the system have been recording.

Hi Harald,

Thanks for taking the time to test and provide feedback.

Just to be clear, this patch does *not* address the warm reboot
problem.  I am continuing to work that issue, but there should be no
expectation that this patch allows the device to survive a warm
reboot.

It should address concerns people were seeing where the system load
would be between 0.50 and 1.0 just by having the device connected, and
*may* help in cases where you start to see mt2060 errors after several
hours of operation.

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
