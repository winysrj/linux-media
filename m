Return-path: <mchehab@pedra>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:51790 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774Ab1CJUoy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Mar 2011 15:44:54 -0500
Received: by vxi39 with SMTP id 39so1919613vxi.19
        for <linux-media@vger.kernel.org>; Thu, 10 Mar 2011 12:44:53 -0800 (PST)
References: <20110309175231.16446e92.jean.bruenn@ip-minds.de> <76A39CFB-2838-4AD7-B353-49971F9F7DFF@wilsonet.com> <ba12e998349efa465be466a4d7f9d43f@localhost> <3AF3951C-11F6-48E4-A0EE-85179B013AFC@wilsonet.com>
In-Reply-To: <3AF3951C-11F6-48E4-A0EE-85179B013AFC@wilsonet.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Message-Id: <81E0AF02-0837-4DF8-BFEA-94A654FFF471@wilsonet.com>
Content-Transfer-Encoding: 8BIT
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Jean Delvare <khali@linux-fr.org>
From: Jarod Wilson <jarod@wilsonet.com>
Subject: Re: WinTV 1400 broken with recent versions?
Date: Thu, 10 Mar 2011 15:45:07 -0500
To: Jean-Michel Bruenn <jean.bruenn@ip-minds.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mar 10, 2011, at 9:37 AM, Jarod Wilson wrote:

> On Mar 9, 2011, at 7:00 PM, <jean.bruenn@ip-minds.de> wrote:
> 
>> 
>>> This may already be fixed, just not in 2.6.37.x yet. Can you give
>>> 2.6.38-rc8 (or later) a try and/or the media_build bits?
>> 
>> Tried - Nope, same behaviour (same error messages in dmesg, no results by
>> scan)
>> 
>>> 
>> http://linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-DVB_Device_Drivers
>> 
>> I was unable to get that working; tried with 2.6.37.2 and 2.6.37.3 always
>> getting "invalid module format" and yeah, i tried with reboot, i tried
>> with a
>> fresh variant.. Also tried ./build.sh and make install and such stuff in
>> 2.6.38-rc8, same.
> 
> As discovered on irc, seems to be a mismatch between the headers that
> were being built against and the running kernel.
> 
> That aside, given that this is a cx23885-based device, I suspect that
> this commit may be relevant to the regression in functionality:
> 
> commit 44835f197bf1e3f57464f23dfb239fef06cf89be
> Author: Jean Delvare <khali@linux-fr.org>
> Date:   Sun Jul 18 16:52:05 2010 -0300
> 
>    V4L/DVB: cx23885: Check for slave nack on all transactions
> 
>    Don't just check for nacks on zero-length transactions. Check on
>    other transactions too.
> 
>    Signed-off-by: Jean Delvare <khali@linux-fr.org>
>    Signed-off-by: Andy Walls <awalls@md.metrocast.net>
>    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> 
> The retval the xc2028 firmware load routine is getting is -ENXIO,
> which seems to possibly be new behavior as a result of that patch.
> However, it may actually be that the xc2028 driver needs to add some
> delays or retries in its firmware load function, as this change *is*
> technically correct (Jean is the i2c subsystem maintainer, so we can
> be pretty sure he knows how i2c stuff is *supposed* to behave). :)
> 
> You could try hard-coding a sleep and/or retries into the inner while
> loop near the bottom of load_firmware() in tuner-xc2028.c... That's
> definitely where things are falling down, anyway.

I knew this all seemed too familiar... :)

http://git.kernel.org/?p=linux/kernel/git/mchehab/linux-2.6.git;a=commit;h=67914b5c400d6c213f9e56d7547a2038ab5c06f4

Its already being reverted for 2.6.38 final (hopefully -- Mauro included
that in the pull req sent to Linus today).

-- 
Jarod Wilson
jarod@wilsonet.com



