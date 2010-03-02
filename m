Return-path: <linux-media-owner@vger.kernel.org>
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:52102 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751293Ab0CBF55 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Mar 2010 00:57:57 -0500
Message-ID: <4B8CA8DD.5030605@teksavvy.com>
Date: Tue, 02 Mar 2010 00:57:49 -0500
From: Mark Lord <kernel@teksavvy.com>
MIME-Version: 1.0
To: Andy Walls <awalls@radix.net>
CC: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	ivtv-devel@ivtvdriver.org
Subject: Re: cx18: Unable to find blank work order form to schedule incoming
 mailbox ...
References: <4B8BE647.7070709@teksavvy.com> <1267493641.4035.17.camel@palomino.walls.org>
In-Reply-To: <1267493641.4035.17.camel@palomino.walls.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/01/10 20:34, Andy Walls wrote:
> On Mon, 2010-03-01 at 11:07 -0500, Mark Lord wrote:
>> I'm using MythTV-0.21-fixes (from svn) on top of Linux-2.6.33 (from kernel.org),
>> with an HVR-1600 tuner card.  This card usually works okay (with workarounds for
>> the known analog recording bugs) in both analog and digital modes.
>>
>> Last night, for the first time ever, MythTV chose to record from both the analog
>> and digital sides of the HVR-1600 card at exactly the same times..
>>
>> The kernel driver failed, and neither recording was successful.
>> The only message in /var/log/messages was:
>>
>> Feb 28 19:59:45 duke kernel: cx18-0: Unable to find blank work order form to schedule incoming mailbox command processing
>
>
> This is really odd.  It means:
>
> 1. Your machine had a very busy burst of cx18 driver buffer handling
> activity.  Stopping a number of different streams, MPEG, VBI, and (DTV)
> TS at nearly the same time could do it
>
> 2. The firmware locked up.
>
> 3. The work handler kernel thread, cx18-0-in, got killed, if that's
> possible, or the processor it was running on got really bogged down.
..

Yeah, it was pretty strange.
I wonder.. the system also has a Hauppauge 950Q USB tuner,
which is also partially controlled by the cx18 driver (I think).

I wonder if perhaps that had anything to do with it?

> If you want to make the problem "just go away" then up this parameter in
> cx18-driver.h:
>
> #define CX18_MAX_IN_WORK_ORDERS (CX18_MAX_FW_MDLS_PER_STREAM + 7)
> to something like
> #define CX18_MAX_IN_WORK_ORDERS (2*CX18_MAX_FW_MDLS_PER_STREAM + 7)
..

Heh.. Yup, that's the first thing I did after looking at the code.  :)
Dunno if it'll help or not, but easy enough to do.

And if the cx18 is indeed being used by two cards (HVR-1600 and HVR-950Q),
then perhaps that number does need to be bigger or dynamic (?).

I've since tried to reproduce the failure on purpose, with no luck to date.

Thanks guys!
