Return-path: <linux-media-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.122]:38413 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753206AbZJ2FdE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Oct 2009 01:33:04 -0400
Message-ID: <4AE92913.4050209@acm.org>
Date: Wed, 28 Oct 2009 22:33:07 -0700
From: Bob Cunningham <rcunning@acm.org>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: linux-media@vger.kernel.org
Subject: Re: HVR-950Q problem under MythTV
References: <4AE8F99E.5010701@acm.org>	 <829197380910282040t6fce747aoca318911e76aa23f@mail.gmail.com>	 <4AE91E54.2030409@acm.org> <829197380910282156l6bea177g79f38eb973335e27@mail.gmail.com>
In-Reply-To: <829197380910282156l6bea177g79f38eb973335e27@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/28/2009 09:56 PM, Devin Heitmueller wrote:
> On Thu, Oct 29, 2009 at 12:47 AM, Bob Cunningham<rcunning@acm.org>  wrote:
>> For F11, I appended the line "options xc5000 no_poweroff=1" to
>> /etc/modprobe.d/local.conf
>>
>> Rather than power down (shudder), I did the following:
>> 1. Unplug HVR-950Q
>> 2. rmmod xc5000
>> 3. modprobe xc5000 no_poweroff=1
>> 4. Plug in HVR-950Q
>
> You would be shocked how many people have trouble with those four
> steps.  So now I just tell people to reboot.
>
>> All is well with the world: The tuner is tuning, MythTV is mythic, and I am
>> a vidiot.
>
> That's great.  Bear in mind that I only did a minimal amount of
> burn-in under MythTV, so if you see other issues, please speak up.  I
> basically did enough to get rid of the segfaults, show the user video,
> and cleanup a couple of errors in the mythbackend.log (by implementing
> the hue and saturation controls).
>
> Devin

I spoke too soon: Switching between SD and HD channels (or vice-versa) always works the first time, but generally dies the next time I try.  The behavior is very inconsistent:  If I switch from SD to HD 720p or higher, the tuner goes away the next time I try to tune an SD channel.  If I switch between SD and 480i HD channels, I can do so up to 4 times before it stops working.

I can switch among SD channels with no problem, and I can switch between HD channels of any resolution with no problem.  Only switching back and forth between HD and SD causes the problem, and it always happens, sooner or later.

Is there a way to force a "quick & dirty" device reinitialization?  Right now, I'm killing mythfrontend and mythbackend, re-plugging the HVR-950Q, and restarting mythbackend and mythfrontend.  Probably overkill.  Is there an easier way?

-BobC
