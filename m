Return-path: <linux-media-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.121]:61284 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773AbZJ2NiE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Oct 2009 09:38:04 -0400
Message-ID: <4AE99ABE.1000007@acm.org>
Date: Thu, 29 Oct 2009 06:38:06 -0700
From: Bob Cunningham <rcunning@acm.org>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: linux-media@vger.kernel.org
Subject: Re: HVR-950Q problem under MythTV
References: <4AE8F99E.5010701@acm.org>	 <829197380910282040t6fce747aoca318911e76aa23f@mail.gmail.com>	 <4AE91E54.2030409@acm.org>	 <829197380910282156l6bea177g79f38eb973335e27@mail.gmail.com>	 <4AE92913.4050209@acm.org> <829197380910290559u78b05d89x9342f440d2067be5@mail.gmail.com>
In-Reply-To: <829197380910290559u78b05d89x9342f440d2067be5@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/29/2009 05:59 AM, Devin Heitmueller wrote:
> On Thu, Oct 29, 2009 at 1:33 AM, Bob Cunningham<rcunning@acm.org>  wrote:
>> I spoke too soon: Switching between SD and HD channels (or vice-versa)
>> always works the first time, but generally dies the next time I try.  The
>> behavior is very inconsistent:  If I switch from SD to HD 720p or higher,
>> the tuner goes away the next time I try to tune an SD channel.  If I switch
>> between SD and 480i HD channels, I can do so up to 4 times before it stops
>> working.
>>
>> I can switch among SD channels with no problem, and I can switch between HD
>> channels of any resolution with no problem.  Only switching back and forth
>> between HD and SD causes the problem, and it always happens, sooner or
>> later.
>>
>> Is there a way to force a "quick&  dirty" device reinitialization?  Right
>> now, I'm killing mythfrontend and mythbackend, re-plugging the HVR-950Q, and
>> restarting mythbackend and mythfrontend.  Probably overkill.  Is there an
>> easier way?
>
> In this context, we are not talking about SD versus HD - we're talking
> about analog versus digital.  You should have no trouble switching
> between SD ATSC channels and HD ATSC channels (since the hardware
> literally cannot tell the difference).  However, it's not *too*
> surprising to find issues going back and forth between analog and
> digital.

If I wait at least 30 seconds between changing channels, the lockups rarely occur.  I'm wondering if this may be a MythTV issue related to buffering, rather than an HVR-950Q issue.

I rarely watch LiveTV, and I'm using it now only to validate all my channels against the EPG content (correct XMLID), after which this shouldn't be a problem.

> Are you sure you put both the analog and digtial video sources into
> the same recording group?  If not, it's possible that MythTV will
> attempt to use both the analog and digtial parts of the card at the
> same time, which is not permitted by the hardware.

They are in the same group, and the digital side is opened "only when needed" (no EIT scan unless tuned).

> Devin

-BobC
