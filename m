Return-path: <linux-media-owner@vger.kernel.org>
Received: from 7of9.schinagl.nl ([88.159.158.68]:58089 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752806Ab3IIVK0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Sep 2013 17:10:26 -0400
Message-ID: <522E393E.1010204@schinagl.nl>
Date: Mon, 09 Sep 2013 23:10:22 +0200
From: Oliver Schinagl <oliver+list@schinagl.nl>
MIME-Version: 1.0
To: Jarod Wilson <jarod@wilsonet.com>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: iMon driver with 3.11 no response
References: <522CE16D.2030004@schinagl.nl> <522E1210.20506@wilsonet.com>
In-Reply-To: <522E1210.20506@wilsonet.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/09/13 20:23, Jarod Wilson wrote:
> Note: I've not had much time to work on any IR stuff in nearly 2 years
> now, and I generally just ignore tech support requests, as there are
> mailing lists and forums that can help you. But you caught me at a
> decent time. :)
Yay! I did cc the lmml but from my other e-mail address (this current 
one) as I do all my lmml mails with, but I can completely understand.
>
> On 09/08/2013 04:43 PM, Oliver Schinagl wrote:
>> Hey Jarod,
>>
>> I've been using my iMon that came with my silverstone tech case for
>> years. This was all using the old methods via lirc etc. With my new
>> install I decided to move to devinput and use your brand new and shiny
>> driver.
>>
>> However I get little to no response from either the IR part, the knob or
>> the VFD (I just echo "Hello" > /dev/lcd0). The only thing I do know
>> works, is powerup (since that's all handled on the PCB itself, that's no
>> surprise, but does show the board seems to be still in working order).
>>
>> The driver (when loading rc-imon-pad first) loads fine, but evtest
>> doesn't respond to anything. I tried with lirc initially and devinput
>> but also that gave no response. The debug output from imon when loading
>> it with debug=1 as follows:
>>
>> [  568.738241] input: iMON Panel, Knob and Mouse(15c2:ffdc) as
>> /devices/pci0000:00/0000:00:1a.2/usb5/5-2/5-2:1.0/input/input19
>> [  568.746030] imon 5-2:1.0: Unknown 0xffdc device, defaulting to VFD
>> and iMON IR
> ^^^
> This is the main issue. I suspect your ffdc device could be an LCD
> instead of a VFD, which would explain the display not working, and it
> may use an RC-6 MCE remote instead of an iMON remote, which would
> explain the receiver not spitting out any devinput data. The lack of
> events from the knob is slightly troubling though. You can load the imon
> driver and override the display type to LCD:
>
> modprobe imon display_type=2
Yeah, but I really do have the VFD version. The VFD wasn't working to 
amazingly however when I last actually used it (dark, some pixels not at 
all). Now the bigger question arises, does the microcontroller actually 
need the VFD to work. I did 25% of my testing (i was messing with it for 
2 hours or so) without the VFD actually connected (it's temporary in a 
different system and it was getting in the way).
>
> Then you can use ir-keytable (part of v4l-utils) to load the MCE
> keytable and set the protocol to MCE instead of iMON IR.
But I also have the original imon remote, the PCB says 'Chisheng C 94 
VO-333', the grey variant imon remote if you google for it, I think it's 
called the iMon-pad. It's a really old model though, one of the earlier 
ones ;)
>
> Once its determined what the hardware actually is, an entry can be added
> to the code that figures out ffdc variant for your device so that it
> gets auto-configured in the future.
Well that would be a good plan; once I figure out why it's being wrong, 
I'll send a patch ;)

oliver
>

