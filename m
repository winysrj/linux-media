Return-path: <linux-media-owner@vger.kernel.org>
Received: from h206.core.ignum.cz ([217.31.49.206]:40251 "EHLO
	h206.core.ignum.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758012AbZJHSYU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Oct 2009 14:24:20 -0400
Message-ID: <C3EF2005C0C34F008FA0B59B48782D75@MirekPNB>
From: "Miroslav Pragl" <lists.subscriber@pragl.cz>
To: "Devin Heitmueller" <dheitmueller@kernellabs.com>
Cc: <linux-media@vger.kernel.org>
References: <2D9D466571BB4CCEB9FD981D65F8FBFC@MirekPNB> <829197380910080736g4b30e0e8m21f1d3b876a15ce6@mail.gmail.com>
In-Reply-To: <829197380910080736g4b30e0e8m21f1d3b876a15ce6@mail.gmail.com>
Subject: Re: Pinnace 320e (PCTV Hybrid Pro Stick) support
Date: Thu, 8 Oct 2009 20:23:22 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="ISO-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Devin,
thank you very much.

I downloaded, compiled and installed drivers from current (today) hg 
repository o linuxtv.org, attached Pinnacle dongle, scanned.

The log files are quite large so i ZIPed them and made available at 
http://pragl.com/tmp/em28xx_logs.zip
They are:

1. messages.txt - relevant paert of /var/log/messages after plugging the 
dongle in

2. scan.txt - output from `scan cz-Praha` (my location) you can see scan 
locks on first frequency (634000000), finds correctly couple of channels 
then fails on other frequencies

3. scan2.txt - same scan but I commented-out 1st frequency (634000000) so 
scan successfully starts from following one (674000000) and the situation 
repeats - only this one gets scanned, following are not

Hope I described it clearly :)

I really appreciate your help

MP


--------------------------------------------------
From: "Devin Heitmueller" <dheitmueller@kernellabs.com>
Sent: Thursday, October 08, 2009 4:36 PM
To: "Miroslav Pragl" <lists.subscriber@pragl.cz>
Cc: <linux-media@vger.kernel.org>
Subject: Re: Pinnace 320e (PCTV Hybrid Pro Stick) support

> 2009/10/8 Miroslav Pragl <lists.subscriber@pragl.cz>:
>> Hello,
>> are here users of Pinnace 320e (PCTV Hybrid Pro Stick)?
>>
>> I have lots of problems with tuning, namely
>> - scan somehow locks on the first frequency listed in scan file and finds 
>> no
>> signal on subsequent freqs
>> - kaffeine which has own scanning scans RELIABLY two, somehow three of 
>> four
>> channels available in my region
>> - vlc which has great commandline parameters for direc tuning frequency 
>> and
>> programm (by its ID) works fine
>>
>> I currently use Fedora 11 with latest stable kernel (64 bit) and try to 
>> keep
>> up-to-date with linuxtv drivers
>>
>> any help or atleast bug confirming would help me a lot
>>
>> Thanks
>>
>> MP
>>
>> P.S. although i hated the aggressivnes of Markus' drivers from 
>> mcentral.de
>> (no longer maintained) and need of FULL kernel sources these atleast 
>> worked
>> :(
>
> Hi Miroslav,
>
> I did the 320e work with the assistance of a couple of users in
> Europe.  Could you confirm that you are running the latest v4l-dvb
> tree from http://linuxtv.org/hg/v4l-dvb?  If so, please provide the
> output of dmesg after connecting the device.
>
> Devin
>
> -- 
> Devin J. Heitmueller - Kernel Labs
> http://www.kernellabs.com
> 
