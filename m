Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:45457 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267Ab2DVPln (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Apr 2012 11:41:43 -0400
Received: by wgbdr13 with SMTP id dr13so11102899wgb.1
        for <linux-media@vger.kernel.org>; Sun, 22 Apr 2012 08:41:41 -0700 (PDT)
Message-ID: <4F9426AF.20200@gmail.com>
Date: Sun, 22 Apr 2012 17:41:35 +0200
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	LMML <linux-media@vger.kernel.org>
Subject: Re: Fwd: Re: [PATCH 04/15] V4L: Add camera white balance preset control
References: <4F91842A.9070505@samsung.com>
In-Reply-To: <4F91842A.9070505@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

> -------- Original Message --------
> Subject: Re: [PATCH 04/15] V4L: Add camera white balance preset control
> Date: Fri, 20 Apr 2012 17:22:08 +0200
> From: Hans de Goede<hdegoede@redhat.com>
> To: Sylwester Nawrocki<s.nawrocki@samsung.com>
> 
> Hi,
> 
> On 04/18/2012 10:46 AM, Sylwester Nawrocki wrote:
>> On 04/17/2012 03:23 PM, Hans de Goede wrote:
>>> On 04/17/2012 12:09 PM, Sylwester Nawrocki wrote:
>>>> Add V4L2_CID_WHITE_BALANCE_PRESET control for camera white balance
>>>> presets. The following items are defined:
>>>>
>>>>     - V4L2_WHITE_BALANCE_NONE,
>>>>     - V4L2_WHITE_BALANCE_INCANDESCENT,
>>>>     - V4L2_WHITE_BALANCE_FLUORESCENT,
>>>>     - V4L2_WHITE_BALANCE_HORIZON,
>>>>     - V4L2_WHITE_BALANCE_DAYLIGHT,
>>>>     - V4L2_WHITE_BALANCE_FLASH,
>>>>     - V4L2_WHITE_BALANCE_CLOUDY,
>>>>     - V4L2_WHITE_BALANCE_SHADE,
>>>>
>>>> This is a manual white balance control, in addition to V4L2_CID_RED_BALANCE,
>>>> V4L2_CID_BLUE_BALANCE and V4L2_CID_WHITE_BALANCE_TEMPERATURE. It's useful
>>>> for camera devices running more complex firmware and exposing white balance
>>>> preset selection in their user register interface.
>>>
>>> Hmm, how is this supposed to work together with the v4l2-ctrls framework?
>>> The framework has a concept of a master control, which has a manual value,
>>> and the slave controls will only get unlocked (V4L2_CTRL_FLAG_INACTIVE
>>> will be cleared) when that master control is set at its manual value, now lets
>>> say that we've V4L2_CID_AUTO_WHITE_BALANCE as master with
>>> V4L2_CID_WHITE_BALANCE_PRESET and V4L2_CID_RED_BALANCE and V4L2_CID_BLUE_BALANCE
>>> slaves. Then when the master control changes from auto to manual all 3 will
>>> have their inactive flag cleared, but if the preset value !=
>>> V4L2_WHITE_BALANCE_NONE
>>> then the red- and blue-balance should have kept their inactive flag. And since
>>> this
>>> clearing of the inactive flag is done after v4l2-ctrls.c has called into the
>>> driver there is no way for the driver to fix this.
>>>
>>> One could work-around this by not specifying the whitebalance control cluster as
>>> being an auto cluster, and doing all the auto cluster stuff from the driver, but
>>> that significantly complicates the driver, and we are trying to get away of every
>>> driver doing this kinda stuff for itself...
>>
>> I assumed in common cases there will be just pairs of auto/manual controls
>> (or control groups) used, e.g. V4L2_CID_AUTO_WHITE_BALANCE and
>> V4L2_CID_RED_BALANCE/V4L2_CID_BLUE_BALANCE, or V4L2_CID_AUTO_WHITE_BALANCE and
>> V4L2_CID_WHITE_BALANCE_TEMPERATURE or V4L2_CID_AUTO_WHITE_BALANCE and
>> V4L2_CID_WHITE_BALANCE_PRESET, etc.
>>
>> This is really what the control framework support now, i.e. one master cluster
>> control with single value that swithes whole cluster into manual mode, AFAICS.
> 
> Right, so my problem is that at least the pwc driver does not work that way.

OK, let's discuss how we can proceed with the menu approach then.

>> I assumed more complicated cases will have to be coded in drivers for now. Or
>> can be handled my the control framework, if those patterns appear to be often
>> used and the control framework is enhanced to better support them.
>>
>> I tried to come up with a solution that could be also used by the pwc driver
>> and to expose all functionality available there.
>>
>>> I still believe that the solution I came up with for pwc is better, the auto
>>> whitebalance control really is a tri state when you add presets whitebalance
>>> is controlled through one of this 3 options:
>>> 1) auto
>>> 2) preset
>>> 3) manual
>>
>> 2) and 3) will often be exclusive, so we cannot just unlock (clear the
>> V4L2_CTRL_FLAG_INACTIVE flag) on them, when the WB menu is switched to value
>> other than "auto". This would happen when the WB menu and 2), 3) would form
>> an auto cluster.
>>
>> Moreover, we also have V4L2_CID_WHITE_BALANCE_TEMPERATURE as a manual WB control.
>> I assumed the WB presets are just form of it, with names (labels).
> 
> Another way of looking at the preset is as a special form of auto WB, it really
> is auto WB with a hint from the user about the lighting conditions, and the auto
> wb algorithm just happens to choose fixed values for temperature or red/green
> balance
> when it gets that user input, this is how the pwc driver currently handles it and
> this works well, currently the pwc driver has a menu with:
> 
> manual
> incandescent
> fluorescent
> daylight
> auto
> 
> This matches well with the control framework, because the red/blue balance
> (or for other cameras the temperature) get unlocked when manual, and locked
> in all other cases, which is exactly what we want. Also it avoids the user
> confusion where the user chooses manual for awb, and then still cannot control
> wb, because he must also move the preset to none, that is just bad UI design
> IMHO.
> 
> To be clear where I set tri state before, I really meant more then 2 states, so:
> 
> manual
> preset 1
> preset 2
> preset 3
> ...
> preset #
> auto

Alright, so I misunderstood it as two controls:

auto
preset
manual

preset 1
preset 2
...
preset N
 
The single control with presets also a bit better matches interfaces of the
sensors I used to work with. The main reason I went for a separate WB preset 
control was the difficulty of changing the current V4L2_CID_AUTO_WHITE_BALANCE.
But it seems there are good reasons to introduce another menu type control.

There is a similar situation with the ISO control. As far as I know there may 
be following values to choose from:

auto
manual 1
manual 2
...
manual N
preset 1
preset 2
...
preset N

So probably the best would be to design 2 controls for it, a menu and 
an integer menu:

> menu

 auto
 manual
 preset 1
 ...
 preset N

> integer menu

 manual 1
 ...
 manual N

It would be then similar to the new WB menu control.

I think we wouldn't have a problem at all if the V4L2_CID_AUTO_WHITE_BALANCE 
control would have been originally a menu. Boolean controls seem pretty hard 
to extend.

> This is really what the user can choose to dividing this into"
> 
> auto
> manual
> 
> preset none
> preset 1
> preset 2
> preset 3
> ...
> preset #
> 
> Will just confuse the user, the user selects manual and then he still cannot
> control the wb (imagine confused look on users face) ...

Hmm, indeed, I prefer happy users;) It might be somehow confusing, and I don't
want to be held responsible for negative impact on users' health... On the other 
hand, I thought one should not assume the controls exposed by drivers should 
necessarily be translated directly into GUI. It's also not difficult to add some
logic at the applications to merge two or more controls into one GUI menu.
However, user experience with some simple or brain dead applications could be
in fact poor.
 
>> I am a bit concerned that with the menu control we might exclude at API level
>> a possibility of altering some of the controls simultaneously, e.g. preset
>> and red/blue balance.
> 
> But that makes no sense, with a preset we are choosing fixed red/blue balance
> settings, so red/blue balance (or the temperature) should be locked when a
> preset is active.

Yes, that wasn't a good example. Again, I was thinking about a different
functionality split among the controls, as explained above.

>>> I know you are worried about having a V4L2_CID_AUTO_WHITE_BALANCE control
>>> which is not a boolean breaking apps, well the pwc driver is a quite popular
>>> driver and I've had 0 bug reports about my turning it into a menu...
>>
>> I wish I could simply change the control type to a menu, but breaking ABI doesn't
>> sound like an option. I think the patch doing something like the at the core level
>> would have been rejected right away. So the new menu control sounds better to me,
>> except that it doesn't make our situation much easier, however it might be what
>> we wanted in long term.
>>
>>> Alternatively we could add a new V4L2_CID_WHITE_BALANCE_MENU control and use
>>> that for drivers which have presets rather then the old
>>> V4L2_CID_AUTO_WHITE_BALANCE
>>> to ensure that userspace won't trip over it being a menu all of a sudden, but
>>> I believe that it is really important to properly reflect the tri-state nature
>>> of the awb once presets come into play, rather then trying to bolt something
>>
>> Is it really tri-state ? I think it just an auto (perhaps multiple auto at some
>> point?) and multiple manual states. Should we really consider the presets as
>> something other than manual control ?
> 
> As said above it is a more then 2 states situation, as for the preset being
> something other then manual, yes, because with the preset active the manual
> controls are locked to the preset selected value(s).
>
>>> on top of / to the side of our current bi-state control. And I hope that my above
>>> example of what sort of troubles using the bolt-on solution will give, clearly
>>> demonstrates that the bolt-on solution is a bad idea.
>>
>> If we decided to add a new V4L2_CID_WHITE_BALANCE_MENU control, then we should
>> probably deprecate V4L2_CID_AUTO_WHITE_BALANCE, as having both would be confusing.
> 
> Agreed.
> 
>> Then the V4L2_CID_AUTO_WHITE_BALANCE would have been removed and maybe after some
>> time added as an alias for V4L2_CID_WHITE_BALANCE_MENU.
> 
> I would not do that just document it as deprecated and keep it around so that apps
> hardcoding control ids keep compiling.

Yeah, makes sense. Of course, I meant, each of the above steps would be done within
a proper time frame.

>> I'm also not very happy with appending a _MENU suffix, indicating the control's
>> type.
> 
> True, but I'm sure if we can agree on the menu approach we can then come up with
> a better name maybe:
> 
> V4L2_CID_AUTO_N_PRESET_WHITE_BALANCE

Sounds good to me. I'm just not sure if it would be a good replacement for 
V4L2_CID_AUTO_WHITE_BALANCE. Maybe just reordering the words in the current CID 
would do, i.e. V4L2_CID_WHITE_BALANCE_AUTO ? Hmm, I'm not sure myself about it..

Or perhaps we should just keep both: 
V4L2_CID_AUTO_WHITE_BALANCE and V4L2_CID_AUTO_N_PRESET_WHITE_BALANCE ?

So I'm going to rework patch 04/15, to remove V4L2_WHITE_BALANCE_PRESET_NONE and
add AUTO, MANUAL entries. Only the CID name is still an open issue.


Some examples to start with:

#define V4L2_CID_WHITE_BALANCE_AUTO  (V4L2_CID_CAMERA_CLASS_BASE+XX)
enum v4l2_white_balance_auto {
	V4L2_WHITE_BALANCE_AUTO,
	V4L2_WHITE_BALANCE_MANUAL,
	V4L2_WHITE_BALANCE_INCANDESCENT,
	V4L2_WHITE_BALANCE_FLUORESCENT,
	V4L2_WHITE_BALANCE_FLUORESCENT_H,
	V4L2_WHITE_BALANCE_HORIZON,
	V4L2_WHITE_BALANCE_DAYLIGHT,
	V4L2_WHITE_BALANCE_FLASH,
	V4L2_WHITE_BALANCE_CLOUDY,
	V4L2_WHITE_BALANCE_SHADE,
};

or 

#define V4L2_CID_AUTO_N_PRESET_WHITE_BALANCE  (V4L2_CID_CAMERA_CLASS_BASE+XX)
enum v4l2_auto_n_preset_white_balance {
	V4L2_WHITE_BALANCE_AUTO,
	V4L2_WHITE_BALANCE_MANUAL,
	V4L2_WHITE_BALANCE_INCANDESCENT,
	V4L2_WHITE_BALANCE_FLUORESCENT,
	V4L2_WHITE_BALANCE_HORIZON,
	V4L2_WHITE_BALANCE_DAYLIGHT,
	V4L2_WHITE_BALANCE_FLASH,
	V4L2_WHITE_BALANCE_CLOUDY,
	V4L2_WHITE_BALANCE_SHADE,
};


enum v4l2_auto_n_preset_white_balance {
	V4L2_AUTO_N_PRESET_WHITE_BALANCE_AUTO,
	V4L2_AUTO_N_PRESET_WHITE_BALANCE_MANUAL,
	V4L2_AUTO_N_PRESET_WHITE_BALANCE_INCANDESCENT,
	...

would be unfortunately a bit cumbersome.

--

Thanks,
Sylwester
