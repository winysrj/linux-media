Return-path: <linux-media-owner@vger.kernel.org>
Received: from rtr.ca ([76.10.145.34]:54171 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754527AbZGSPMD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Jul 2009 11:12:03 -0400
Message-ID: <4A6337C1.6080104@rtr.ca>
Date: Sun, 19 Jul 2009 11:12:01 -0400
From: Mark Lord <lkml@rtr.ca>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Steven Toth <stoth@linuxtv.org>, linux-media@vger.kernel.org,
	Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Regression 2.6.31: xc5000 no longer works with Myth-0.21-fixes
 	branch
References: <4A631C8F.7000002@rtr.ca> <829197380907190706i686fd1afwdca0d8be648129@mail.gmail.com>
In-Reply-To: <829197380907190706i686fd1afwdca0d8be648129@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Devin Heitmueller wrote:
> On Sun, Jul 19, 2009 at 9:15 AM, Mark Lord<lkml@rtr.ca> wrote:
>> Devin,
>>
>> Thanks for your good efforts and updates on the xc5000 driver.
>> But the version in 2.6.31 no longer works with mythfrontend
>> from the 0.21-fixes branch of MythTV.
..
> Also, Could you please install the latest v4l-dvb code using the
> directions at http://linuxtv.org/repo and see if the problem still
> occurs.  This will tell us if the problem is some patch that didn't
> make it upstream, and will make it easier for me to give you patches
> that provide more debug info.
..

Okay, I pulled in v4l-dvb-bdd711bbc07e, built/installed/rebooted,
and ended up with exactly the same behaviour.

So the good news is, nothing appears to have been left out in 2.6.31. :)

But still no really good clues to go on, other than this observation
from before:

>> The mythbackend (recording) program tunes/records fine with it,
>> but any attempt to watch "Live TV" via mythfrontend just locks
>> up the UI for 30 seconds or so, and then it reverts to the menus.
>>
>> I find that rather odd, as mythfrontend normally has very little
>> interaction with the tuner devices.  But it does try to read the
>> signal strength and quality from the tuner, so perhaps this is a
>> clue as to what has gone wrong?
..

Really, the mythfrontend DOES NOT DEAL WITH TUNERS directly,
leaving that to the mythbackend.  EXCEPT for when it wants to show
a signal strength/quality indication onscreen, which is done
when tuning to a new channel.

So it's got to be something on that pathway, I suspect,
but despite being a kernel developer, I'm not terribly
knowledgeable about V4L, DVB, or the MythTV internals.

Cheers
