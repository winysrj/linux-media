Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp148.mail.ukl.yahoo.com ([77.238.184.79]:41581 "HELO
	smtp148.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758767AbZJHSOT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 8 Oct 2009 14:14:19 -0400
Message-ID: <4ACE2BCE.9040308@yahoo.it>
Date: Thu, 08 Oct 2009 20:13:34 +0200
From: SebaX75 <sebax75@yahoo.it>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: Pinnace 320e (PCTV Hybrid Pro Stick) support
References: <2D9D466571BB4CCEB9FD981D65F8FBFC@MirekPNB> <829197380910080736g4b30e0e8m21f1d3b876a15ce6@mail.gmail.com>
In-Reply-To: <829197380910080736g4b30e0e8m21f1d3b876a15ce6@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Devin Heitmueller ha scritto:
> 2009/10/8 Miroslav Pragl <lists.subscriber@pragl.cz>:
>> Hello,
>> are here users of Pinnace 320e (PCTV Hybrid Pro Stick)?
>>
>> I have lots of problems with tuning, namely
>> - scan somehow locks on the first frequency listed in scan file and finds no
>> signal on subsequent freqs
>> - kaffeine which has own scanning scans RELIABLY two, somehow three of four
>> channels available in my region
>> - vlc which has great commandline parameters for direc tuning frequency and
>> programm (by its ID) works fine
>>
>> I currently use Fedora 11 with latest stable kernel (64 bit) and try to keep
>> up-to-date with linuxtv drivers
>>
>> any help or atleast bug confirming would help me a lot
>>
>> Thanks
>>
>> MP
>>
>> P.S. although i hated the aggressivnes of Markus' drivers from mcentral.de
>> (no longer maintained) and need of FULL kernel sources these atleast worked
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

Hi Devin,
we have already discussed a few weeks ago on IRC; you've tryed to 
identify the problem with my help and debug on, but no information about 
the problem was identified, so you have requested to me a log captured 
with usbmon during scanning.
I've sent you a session captured with usbmon, but after this I've not 
seen any improvement and I've not received any reply.
In the past day I'm joined on #linuxtv, but probably you was busy and so 
I don't know if there are news.

Bye and thanks,
Sebastian
