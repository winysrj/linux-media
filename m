Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:24828 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116Ab2DRIq4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Apr 2012 04:46:56 -0400
Received: from euspt1 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0M2O008UZ303RP@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 18 Apr 2012 09:45:39 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M2O00BT83253V@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 18 Apr 2012 09:46:53 +0100 (BST)
Date: Wed, 18 Apr 2012 10:46:52 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH 04/15] V4L: Add camera white balance preset control
In-reply-to: <4F8D6EB5.5050304@redhat.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	sakari.ailus@iki.fi, g.liakhovetski@gmx.de, moinejf@free.fr,
	m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <4F8E7F7C.906@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
References: <1334657396-5737-1-git-send-email-s.nawrocki@samsung.com>
 <1334657396-5737-5-git-send-email-s.nawrocki@samsung.com>
 <4F8D6EB5.5050304@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On 04/17/2012 03:23 PM, Hans de Goede wrote:
> Hi,
> 
> On 04/17/2012 12:09 PM, Sylwester Nawrocki wrote:
>> Add V4L2_CID_WHITE_BALANCE_PRESET control for camera white balance
>> presets. The following items are defined:
>>
>>   - V4L2_WHITE_BALANCE_NONE,
>>   - V4L2_WHITE_BALANCE_INCANDESCENT,
>>   - V4L2_WHITE_BALANCE_FLUORESCENT,
>>   - V4L2_WHITE_BALANCE_HORIZON,
>>   - V4L2_WHITE_BALANCE_DAYLIGHT,
>>   - V4L2_WHITE_BALANCE_FLASH,
>>   - V4L2_WHITE_BALANCE_CLOUDY,
>>   - V4L2_WHITE_BALANCE_SHADE,
>>
>> This is a manual white balance control, in addition to V4L2_CID_RED_BALANCE,
>> V4L2_CID_BLUE_BALANCE and V4L2_CID_WHITE_BALANCE_TEMPERATURE. It's useful
>> for camera devices running more complex firmware and exposing white balance
>> preset selection in their user register interface.
> 
> Hmm, how is this supposed to work together with the v4l2-ctrls framework?
> The framework has a concept of a master control, which has a manual value,
> and the slave controls will only get unlocked (V4L2_CTRL_FLAG_INACTIVE
> will be cleared) when that master control is set at its manual value, now lets
> say that we've V4L2_CID_AUTO_WHITE_BALANCE as master with
> V4L2_CID_WHITE_BALANCE_PRESET and V4L2_CID_RED_BALANCE and V4L2_CID_BLUE_BALANCE
> slaves. Then when the master control changes from auto to manual all 3 will
> have their inactive flag cleared, but if the preset value !=
> V4L2_WHITE_BALANCE_NONE
> then the red- and blue-balance should have kept their inactive flag. And since
> this
> clearing of the inactive flag is done after v4l2-ctrls.c has called into the
> driver there is no way for the driver to fix this.
> 
> One could work-around this by not specifying the whitebalance control cluster as
> being an auto cluster, and doing all the auto cluster stuff from the driver, but
> that significantly complicates the driver, and we are trying to get away of every
> driver doing this kinda stuff for itself...

I assumed in common cases there will be just pairs of auto/manual controls
(or control groups) used, e.g. V4L2_CID_AUTO_WHITE_BALANCE and 
V4L2_CID_RED_BALANCE/V4L2_CID_BLUE_BALANCE, or V4L2_CID_AUTO_WHITE_BALANCE and
V4L2_CID_WHITE_BALANCE_TEMPERATURE or V4L2_CID_AUTO_WHITE_BALANCE and
V4L2_CID_WHITE_BALANCE_PRESET, etc.

This is really what the control framework support now, i.e. one master cluster
control with single value that swithes whole cluster into manual mode, AFAICS.

I assumed more complicated cases will have to be coded in drivers for now. Or
can be handled my the control framework, if those patterns appear to be often
used and the control framework is enhanced to better support them.

I tried to come up with a solution that could be also used by the pwc driver
and to expose all functionality available there.

> I still believe that the solution I came up with for pwc is better, the auto
> whitebalance control really is a tri state when you add presets whitebalance
> is controlled through one of this 3 options:
> 1) auto
> 2) preset
> 3) manual

2) and 3) will often be exclusive, so we cannot just unlock (clear the 
V4L2_CTRL_FLAG_INACTIVE flag) on them, when the WB menu is switched to value
other than "auto". This would happen when the WB menu and 2), 3) would form 
an auto cluster.

Moreover, we also have V4L2_CID_WHITE_BALANCE_TEMPERATURE as a manual WB control.
I assumed the WB presets are just form of it, with names (labels).

I am a bit concerned that with the menu control we might exclude at API level
a possibility of altering some of the controls simultaneously, e.g. preset
and red/blue balance.

> I know you are worried about having a V4L2_CID_AUTO_WHITE_BALANCE control
> which is not a boolean breaking apps, well the pwc driver is a quite popular
> driver and I've had 0 bug reports about my turning it into a menu...

I wish I could simply change the control type to a menu, but breaking ABI doesn't
sound like an option. I think the patch doing something like the at the core level
would have been rejected right away. So the new menu control sounds better to me,
except that it doesn't make our situation much easier, however it might be what
we wanted in long term.

> Alternatively we could add a new V4L2_CID_WHITE_BALANCE_MENU control and use
> that for drivers which have presets rather then the old
> V4L2_CID_AUTO_WHITE_BALANCE
> to ensure that userspace won't trip over it being a menu all of a sudden, but
> I believe that it is really important to properly reflect the tri-state nature
> of the awb once presets come into play, rather then trying to bolt something

Is it really tri-state ? I think it just an auto (perhaps multiple auto at some 
point?) and multiple manual states. Should we really consider the presets as 
something other than manual control ?

> on top of / to the side of our current bi-state control. And I hope that my above
> example of what sort of troubles using the bolt-on solution will give, clearly
> demonstrates that the bolt-on solution is a bad idea.

If we decided to add a new V4L2_CID_WHITE_BALANCE_MENU control, then we should
probably deprecate V4L2_CID_AUTO_WHITE_BALANCE, as having both would be confusing.
Then the V4L2_CID_AUTO_WHITE_BALANCE would have been removed and maybe after some
time added as an alias for V4L2_CID_WHITE_BALANCE_MENU. Sound terribly painful
though. This all makes me think we might be missing some reliable API version
scheme.

I'm also not very happy with appending a _MENU suffix, indicating the control's
type. 


-- 
Regards,
Sylwester
