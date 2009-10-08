Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp131.mail.ukl.yahoo.com ([77.238.184.62]:24156 "HELO
	smtp131.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757660AbZJHXfs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 8 Oct 2009 19:35:48 -0400
Message-ID: <4ACE7727.7090800@yahoo.it>
Date: Fri, 09 Oct 2009 01:35:03 +0200
From: SebaX75 <sebax75@yahoo.it>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Miroslav Pragl <lists.subscriber@pragl.cz>,
	linux-media@vger.kernel.org
Subject: Re: Pinnace 320e (PCTV Hybrid Pro Stick) support
References: <2D9D466571BB4CCEB9FD981D65F8FBFC@MirekPNB>	 <829197380910080736g4b30e0e8m21f1d3b876a15ce6@mail.gmail.com>	 <C3EF2005C0C34F008FA0B59B48782D75@MirekPNB> <829197380910081204r6b8c779dsf32c61b718df77f0@mail.gmail.com>
In-Reply-To: <829197380910081204r6b8c779dsf32c61b718df77f0@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Il 08/10/2009 21:04, Devin Heitmueller ha scritto:
> On Thu, Oct 8, 2009 at 2:23 PM, Miroslav Pragl
> <lists.subscriber@pragl.cz>  wrote:
>> Devin,
>> thank you very much.
>>
>> I downloaded, compiled and installed drivers from current (today) hg
>> repository o linuxtv.org, attached Pinnacle dongle, scanned.
>>
>> The log files are quite large so i ZIPed them and made available at
>> http://pragl.com/tmp/em28xx_logs.zip
>> They are:
>>
>> 1. messages.txt - relevant paert of /var/log/messages after plugging the
>> dongle in
>>
>> 2. scan.txt - output from `scan cz-Praha` (my location) you can see scan
>> locks on first frequency (634000000), finds correctly couple of channels
>> then fails on other frequencies
>>
>> 3. scan2.txt - same scan but I commented-out 1st frequency (634000000) so
>> scan successfully starts from following one (674000000) and the situation
>> repeats - only this one gets scanned, following are not
>>
>> Hope I described it clearly :)
>>
>> I really appreciate your help
>
> Interesting.  I just looked at SebaX75's usbmon trace, and I have a
> suspicion as to what is going on.  If one of you is feeling
> adventurous, try the following
>
> unplug the device
> comment out line 181 of file v4l/em28xx-cards.c so it looks like:
>
> //   {EM2880_R04_GPO,        0x04,   0xff,          100},/* zl10353 reset */
>
> make&&  make install&&  make unload
> plug in device
> Attempt a scan
>
> Let me know if that causes it to lock on more than just the first frequency.
>
> Devin
>

Hi Devin,
I've no problem to test... and now all is working. I've scanned all VHF 
and UHF frequency and all MUX were identified and channel are recognized.

Your suspicion was correct, very thanks.

Sebastian
