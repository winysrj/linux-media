Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.7]:13427 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753171Ab0AJV0v (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jan 2010 16:26:51 -0500
Message-ID: <4B4A4617.7070400@wp.pl>
Date: Sun, 10 Jan 2010 22:26:47 +0100
From: dz-tor <dz-tor@wp.pl>
MIME-Version: 1.0
To: hermann pitton <hermann-pitton@arcor.de>
CC: Pavle Predic <pavle.predic@yahoo.co.uk>,
	video4linux-list@redhat.com, LMML <linux-media@vger.kernel.org>,
	Terry Wu <terrywu2009@gmail.com>
Subject: Re: Leadtek Winfast TV2100
References: <4B40B9CC.1040108@wp.pl>	 <1262979242.3246.10.camel@pc07.localdom.local> <4B47B836.3000108@wp.pl>	 <279441.7775.qm@web28406.mail.ukl.yahoo.com>  <4B48AD64.1000505@wp.pl> <1263057295.3870.27.camel@pc07.localdom.local>
In-Reply-To: <1263057295.3870.27.camel@pc07.localdom.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 09.01.2010 18:14, hermann pitton wrote:
> Hi,
>
> Am Samstag, den 09.01.2010, 17:23 +0100 schrieb dz-tor:
>    
>> Hi Pavle,
>>
>> On 09.01.2010 15:46, Pavle Predic wrote:
>>      
>>> Hey Darek,
>>>
>>> Great job of making the card work. I was really thrilled when I saw
>>> your post. However, I am a total newbie, so I couldn't apply the
>>> changes you wrote about. Could you please be a bit more specific? What
>>> I did is downloaded the driver from here:
>>> http://dl.bytesex.org/releases/video4linux/saa7134-0.2.12.tar.gz and
>>> made the changes to those two files, as described. But I have no clue
>>> how to compile it. I installed linux-headers for my kernel version and
>>> tried to run make, but I'm getting an error. Are there any
>>> configuration options that I need to set in Makefile or Make.config?
>>>        
>> I'm not sure whether downloading and compiling driver is good idea. v4l
>> drivers (which includes saa7134) are included in mainline kernel, so
>> compiling kernel is what you have to do. From what I know, in Debian
>> there should be package in repositories with kernel sources
>> (linux-source or similar) - this option you should use if you want to
>> stick to the kernel version provided by your distribution. Another
>> option is to download kernel sources from kernel.org and use them (I've
>> done so - I'm using latest stable release). Here you have link to how-to
>> about kernel compiling:
>> https://help.ubuntu.com/6.10/ubuntu/installation-guide/i386/kernel-baking.html.
>> It's for Ubuntu, but for you it should be also applicable (on bottom
>> there is also link to Debian documentation).
>>
>> Before compilation you should make changes which I gave earlier. All
>> files which should be modified are in
>> <kernel_src_path>/drivers/media/video/saa7134/ directory. Have in mind
>> that what I've done is that I've changed existing card configuration -
>> it's not proper solution. When I'll manage remote control to work, I'll
>> try to prepare patch with new card configuration. You can apply my
>> changes now or wait until I'll prepare the patch.
>>
>> Regards,
>> Darek
>>      
> Great!
>
> So Pavle's regspy results and following my instructions did the trick.
>
> Patches must go to LMML<linux-media@vger.kernel.org>  and be against
> latest v4l-dvb master at linuxtv.org.
>    
Done
> You can use what I prepared already yesterday for testing and is
> attached. You have only to change the clock and use LINE1 for external
> audio input. I suggest to use also LINE1 for mute then, gpio 0x08 is
> that input anyway.
>
> We can send that modified patch already and add IR support later.
>
> You must find the up/down gpio and with mask_keycode = 0x000000
> all the other gpios which do change on keypresses and create unique
> keycodes. Then you either need to add a new keytable or can use an
> already existing one.
>    
I understand what have to be done to get support for remote control - 
problem lays somewhere else. Later I'll send more details with code and 
outputs from dmesg and description of the problem.

Regards,
Darek

