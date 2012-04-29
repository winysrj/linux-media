Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:40545 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752765Ab2D2J1I (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Apr 2012 05:27:08 -0400
Received: by wejx9 with SMTP id x9so1265913wej.19
        for <linux-media@vger.kernel.org>; Sun, 29 Apr 2012 02:27:07 -0700 (PDT)
Message-ID: <4F9D0969.1080806@gmail.com>
Date: Sun, 29 Apr 2012 11:27:05 +0200
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	g.liakhovetski@gmx.de, hdegoede@redhat.com, moinejf@free.fr,
	m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH 10/15] V4L: Add camera 3A lock control
References: <1334657396-5737-1-git-send-email-s.nawrocki@samsung.com> <1334657396-5737-11-git-send-email-s.nawrocki@samsung.com> <20120417160920.GG5356@valkosipuli.localdomain> <4F8E82D6.8060008@samsung.com> <20120423054627.GA7913@valkosipuli.localdomain> <4F970911.5000404@gmail.com> <4F971435.10608@iki.fi>
In-Reply-To: <4F971435.10608@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 04/24/2012 10:59 PM, Sakari Ailus wrote:
> Dzien dobry Sylwester,
> 
> (I hope it's not too wrong time of the day for that! ;))

No, it's never too wrong;)

> Sylwester Nawrocki wrote:
>> On 04/23/2012 07:47 AM, Sakari Ailus wrote:
>>> Sylwester Nawrocki wrote:
>>>> On 04/17/2012 06:09 PM, Sakari Ailus wrote:
>>>>> On Tue, Apr 17, 2012 at 12:09:51PM +0200, Sylwester Nawrocki wrote:
...
>>> I was thinking how does the situation really differ from disabling the
>>> corresponding automatic algorithm. There may be subtle differences in
>>> practice albeit in principle the two are no different. And if some of 
>>> the
>>> sensors implement it as lock, then I guess it gives us few options 
>>> for the
>>> user space interface.
>>
>> Can you anticipate any any possible issues such diversity might bring to
>> applications ? I imagine such control can be quite useful for snapshot,
>> and with current control API design and the drivers' behaviour 
>> applications
>> cannot be sure what settings a device ends up with after switching from
>> "auto" to "manual" - last auto settings or the manual values. Usually its
>> just the previous manual values.
> 
> On software controlled digital cameras, depending on what the manual 
> configuration actually means, you either get the same than by locking 
> the automatic control or the previous manual configuration. If the means 
> for manual configuration are the same than what the automatic algorithm 
> uses then it's the first case. However, I have a feeling that such low 
> level controls might often not work the best for manual control: for 
> white balance users seldom wish to fiddle with SRGB matrix or gamma 
> tables directly. Colour balance might just do mostly the same and be 
> more convenient, with the automatic algorithm still doing some work to 
> configure the underlying low-level configuration.

I was thinking more along the lines of currently available V4L2 
controls. And with cameras with I2C control interface there is often
a device specific user interface of which characteristics are slightly 
different that what we would have implemented directly in software in 
user space. 

> Perhaps it would make sense to suggest that the control algorithm locks 
> should be implemented even in cases where the lock would mean exactly 
> the same than just disabling the algorithm. What do you think?

IMHO a driver should expose the control only if hardware supports 
locking. Once we have clear semantics for the lock control, it should
be up to the driver's author to decide whether such functionality 
should be exposed or not. I believe the locking and disabling/enabling 
automatic settings will differ in most cases, there may be different
latencies involved, etc. 

Also I think the lock control should have top priority, .e.g when
the user sets V4L2_CID_AUTO_FOCUS_START control nothing should 
happen, unless V4L2_LOCK_FOCUS is set to 0. What do you think ?

BTW, I've changed names of the individual lock bits an removed 
"_3A" prefix from them. It seems to look better that way:

#define V4L2_CID_3A_LOCK	(V4L2_CID_CAMERA_CLASS_BASE+27)
#define V4L2_LOCK_EXPOSURE	(1 << 0)
#define V4L2_LOCK_WHITE_BALANCE	(1 << 1)
#define V4L2_LOCK_FOCUS		(1 << 2)

Or must we abide the rule that individual option names are created 
by only removing the "_CID" part from the control name and appending
the option's name ?

> Shouldn't the lock be related to contiguous focus only btw.? Regular 
> autofocus is typically a one-time operation, the lens ending up on a 
> position where the AF algorithm left it.

Perhaps, it would make sense mostly for continuous auto focus. 
However, I'm inclined to not limit it to continuous auto focus only. 
I think regardless of the focus mode the lock should freeze focusing,
so still image capture is not disturbed.


--

Regards,
Sylwester
