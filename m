Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:6565 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753278Ab0DXUzE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Apr 2010 16:55:04 -0400
Received: by fg-out-1718.google.com with SMTP id d23so1557481fga.1
        for <linux-media@vger.kernel.org>; Sat, 24 Apr 2010 13:55:01 -0700 (PDT)
Message-ID: <4BD35AA3.7070003@googlemail.com>
Date: Sat, 24 Apr 2010 22:54:59 +0200
From: Sven Barth <pascaldragon@googlemail.com>
MIME-Version: 1.0
To: Mike Isely <isely@isely.net>
CC: linux-media@vger.kernel.org
Subject: Re: Problem with cx25840 and Terratec Grabster AV400
References: <4BD2EACA.5040005@googlemail.com> <alpine.DEB.1.10.1004241212100.5135@ivanova.isely.net> <4BD34E5A.40507@googlemail.com> <alpine.DEB.1.10.1004241517320.5135@ivanova.isely.net>
In-Reply-To: <alpine.DEB.1.10.1004241517320.5135@ivanova.isely.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

On 24.04.2010 22:24, Mike Isely wrote:
> On Sat, 24 Apr 2010, Sven Barth wrote:
>>
>> Hi!
>>
>> Although you never really completed that support for the AV400 it runs pretty
>> well once you've touched the cx25840 source. I'm using it for months now and
>> it runs better than it did with Windows (I sometimes had troubles with audio
>> there which led to an "out of sync" audio track).
>
> Unfortunately I can't really "say" it is supported in the pvrusb2 driver
> until it actually works well enough that a user doesn't have to hack
> driver source (pvrusb2 or otherwise).  Otherwise I'm just going to get
> inundated with help requests for this.  Not having a sample of the
> device here I'm handicapped from debugging such issues.
>

I don't want to have this hacking as much as you do. But currently it's 
the only way that works for me (I'm really glad that it has come that 
far ^^)...
I'll try to help here as good as I can (and time permits) to solve this 
issue.

> I've just made a change to the pvrusb2 driver to allow for the ability
> to mark a piece of hardware (such as this device) as "experimental".
> Such devices will generate a warning in the kernel log upon
> initialization.  The experimental marker doesn't impact the ability to
> use the device; it just triggers the warning message.  Once we know the
> device is working acceptably well enough, the marker can be turned off.
> This should help avoid misleading others about whether or not the
> pvrusb2 driver fully supports a particular piece of hardware.
>

No offense intended, but do you really think that people will read that? 
Normal users (using Ubuntu, etc) don't really care whether their device 
is marked as experimental or not... they just want it to work and thus 
can go to great lengths to "disturb" the developers working on their 
driver...

>> PS: Did you read my mail from last December?
>> http://www.isely.net/pipermail/pvrusb2/2009-December/002716.html
>
> Yeah, I saw it back then, and then I probably got distracted away :-(

I know that problem pretty well. ^^ I was only curious.

>
> The key issue is that your hardware doesn't seem to work until you make
> those two changes to the v4l-dvb cx25840 driver.  Obviously one can't
> just make those changes without understanding the implications for other
> users of the driver.  I (or someone expert at the cx25840 module) needs
> to study that patch and understand what is best to do for the driver.
>
>    -Mike
>
>

It would be interesting to know why the v4l devs disabled the audio 
routing for cx2583x chips and whether it was intended that a cx25837 
chip gets the same treatment as a e.g. cx25836.
And those "implications" you're talking about is the reason why I wrote 
here: I want to check whether there is a better or more correct way than 
to disable those checks (it works here, because I have only that one 
device that contains a cx2583x chip...).

Just a thought: can it be that my chip's audio routing isn't set to the 
correct value after initialization and thus it needs to be set at least 
once, while all other chips default to a working routing after 
initialization? Could be a design mistake done by Terratec...

Regards,
Sven
