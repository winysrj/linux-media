Return-path: <mchehab@gaivota>
Received: from saarni.dnainternet.net ([83.102.40.136]:59373 "EHLO
	saarni.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754259Ab1EKQdO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 May 2011 12:33:14 -0400
Message-ID: <4DCABA42.30505@iki.fi>
Date: Wed, 11 May 2011 19:33:06 +0300
From: Anssi Hannula <anssi.hannula@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Peter Hutterer <peter.hutterer@who-t.net>,
	linux-media@vger.kernel.org,
	"linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
	xorg-devel@lists.freedesktop.org
Subject: Re: IR remote control autorepeat / evdev
References: <4DC61E28.4090301@iki.fi> <20110510041107.GA32552@barra.redhat.com> <4DC8C9B6.5000501@iki.fi> <20110510053038.GA5808@barra.redhat.com> <4DC940E5.2070902@iki.fi> <4DCA1496.20304@redhat.com>
In-Reply-To: <4DCA1496.20304@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On 11.05.2011 07:46, Mauro Carvalho Chehab wrote:
> Hi Anssi/Peter,

Hi!

> Em 10-05-2011 15:43, Anssi Hannula escreveu:
>> On 10.05.2011 08:30, Peter Hutterer wrote:
>>> On Tue, May 10, 2011 at 08:14:30AM +0300, Anssi Hannula wrote:
>>>> On 10.05.2011 07:11, Peter Hutterer wrote:
>>>>> On Sun, May 08, 2011 at 07:38:00AM +0300, Anssi Hannula wrote:
>>>>>> Hi all!
>>>>>>
>>>>>> Most IR/RF remotes differ from normal keyboards in that they don't
>>>>>> provide release events. They do provide native repeat events, though.
>>>>>>
>>>>>> Currently the Linux kernel RC/input subsystems provide a simulated
>>>>>> autorepeat for remote controls (default delay 500ms, period 33ms), and
>>>>>> X.org server ignores these events and generates its own autorepeat for them.
>>>>>>
>>>>>> The kernel RC subsystem provides a simulated release event when 250ms
>>>>>> has passed since the last native event (repeat or non-repeat) was
>>>>>> received from the device.
>>>>>>
>>>>>> This is problematic, since it causes lots of extra repeat events to be
>>>>>> always sent (for up to 250ms) after the user has released the remote
>>>>>> control button, which makes the remote quite uncomfortable to use.
>>>>>
>>>>> I got a bit confused reading this description. Does this mean that remotes
>>>>> usually send:
>>>>>     key press - repeat - repeat - ... - repeat - <silence>
>>>>> where the silence indicates that the key has been released? Which the kernel
>>>>> after 250ms translates into a release event.
>>>>> And the kernel discards the repeats and generates it's own on 500/33?
>>>>> Do I get this right so far?
>>>>
>>>> Yes.
>>>>
>>>>> If so, I'm not sure how to avoid the 250ms delay since we have no indication
>>>>> from the hardware when the silence will stop, right?
>>>>
>>>> Yes.
>>>> AFAICS what we need is to not use softrepeat for these devices and
>>>> instead use the native repeats. The 250ms release delay could then be
>>>> kept (as it wouldn't cause unwanted repeats anymore) or it could be made
>>>> 0ms if that is deemed better.
>>>>
>>>> I listed some ways to do that below in my original post.
>>>>
>>>>> Note that the repeat delay and ratio are configurable per-device using XKB,
>>>>> so you could set up the 500/33 in X too.
> 
> While 500/33 is good for keyboards, this is generally not good for remote controllers.

500/33 is the one kernel uses for remotes.

> The bit rate for IR transmissions are slow. So, one keypress can last up to about
> 110 ms[1]. That means that the maximum repeat rate for IR devices with such
> protocol should be bellow than 10 keystrokes/sec.
> 
> Also, the minimum initial delay for IR needs to be different on a few hardware that
> have a broken IR implementation. We default it to 500ms, but a few drivers change it
> to fit into some hardware constraits. So, a few kernel driver have some tweaks of 
> repeat times, to be sure that the device will work properly.
> 
> [1] http://www.sbprojects.com/knowledge/ir/nec.htm
> 
>>>> It wouldn't make any difference with the actual issue which is
>>>> "autorepeat happening after physical key released".
>>>>
>>>> I guess the reason this hasn't come up earlier is that the unified IR/RC
>>>> subsystem in the linux kernel is still quite new. It definitely needs to
>>>> be improved regarding this issue - just trying to figure out the best
>>>> way to do it.
> 
> The repeat events always generated troubles, as it basically depends on how
> the hardware actually handles it. Some hardware decoders and some protocols 
> support repeat events, while others don't. There are even some remote controllers
> that, instead of generating repeat codes, they just generate multiple keypresses.
> 
> With the rc-core, we've unified the repeat treatment (yet, there are some 
> exceptions to the default way, for some devices where that uses broken hardware
> decoders).
> 
>>> right. we used to have hardware repeats in X a few releases back. I think
>>> 1.6 was the first one that shifted to pure software autorepeat. One of the
>>> results we saw in the transition period was the clash of hw autorepeat (in
>>> X's input system, anything that comes out of the kernel counts as "hw") and
>>> software repeat. 
>>>
>>> Integrating them back in is going to be a bit iffy, especially since you
>>> need the integration with XKB on each device, essentially disallowing the
>>> clients from enabling autorepeat. Not 100% what's required there.
>>> The evtev part is going to be the simplest part of all that.
>>
>> I suspected it might be tricky. So maybe (at least for the time being)
>> remote controls in X should simply get KeyRelease immediately after
>> every KeyPress?
> 
> This will probably cause some hurt. Things like volume control only work
> nice on userspace if repeat events are properly handled.

Hmm, maybe I'm missing something, but I was thinking that sending
KeyRelease immediately *fixes* volume control.

Currently (both on X and on standalone evdev programs):

1. User holds down volumeup for 4 notches, then releases it.
2. The (kernel or X.org) autorepeat keeps sending events for 250ms
   after releases at rate of 33ms, so 250/33 = 7 additional events
   get transmitted.
=> Volume goes up 11 notches instead of 4.
So the volume control is basically unusable if you hold down buttons.

By sending KeyRelease immediately after every native event from the
remote, no more additional keypresses happen when the user stops, even
if the remote doesn't send a native release event.


While having the current "unified" repeat treatment (same rate/delay) in
kernel for all remotes is nice, I think the
events-happen-after-keyrelease issue far outweighs any benefits. Hence
my push for native repeats.

> I think we should
> try to fix XKB/evdev to not use software events on remote controllers. It
> is easy to detect that an input device is a remote controller on evdev.
> I wrote a patch for it some time ago (unfortunately, hadn't time to finish
> it, as I got some jobs with higher priority). Peter, is that a way to pass
> a flag to XKB to say that a hw input device is not a keyboard, and need
> a different treatment for repeat events?
> 
>> Meaning that either a) kernel does it (while maybe providing some new
>> extra info for those evdev users that want to distinguish repeats from
>> new keypresses - original suggestion 4), or b) kernel provides a flag
>> which causes the X evdev driver to follow-up every keydown/repeat event
>> with an immediate release event. (both of these include kernel changed
>> to use native repeats instead of softrepeats, which is trivial)
> 
> The issue seems to be X-specific, so, I think that the solution should be
> there, and not at the kernel level. X should not use software autorepeat
> for remote controllers, at this won't work properly.

This affects all other non-X applications as well, as the kernel does
software autorepeat for remote controllers.


>>>>>> Now, IMO something should be done to fix this. But what exactly?
>>>>>>
>>>>>> Here are two ideas that would remove these ghost repeats:
>>>>>>
>>>>>> 1. Do not provide any repeat/release simulation in the kernel for RC
>>>>>> devices (by default?), just provide both keydown and immediate release
>>>>>> events for every native keypress or repeat received from the device.
>>>>>> + Very simple to implement
>>>>>> - We lose the ability to track repeats, i.e. if a new event was a repeat
>>>>>>   or a new keypress; "holding down" a key becomes impossible
>>>>>>
>>>>>> or
>>>>>> 2. Replace kernel autorepeat simulation by passing through the native
>>>>>> repeat events (probably filtering them according to REP_DELAY and
>>>>>> REP_PERIOD), and have a device property bit (fetchable via EVIOCGPROP)
>>>>>> indicating that the keyrelease is simulated, and have the X server use
>>>>>> the native repeats instead of softrepeats for such a device.
>>>>>> + The userspace correctly gets repeat events tagged as repeats and
>>>>>>   release events when appropriate (albeit a little late)
>>>>>> - Adds complexity. Also, while the kernel part is quite easy to
>>>>>>   implement, I'm not sure if the X server part is.
>>>>>>
>>>>>> or
>>>>>> 3. Same as 1., but indicate the repeatness of an event with a new
>>>>>>    additional special event before EV_SYN (sync event).
>>>>>> + Simple to implement
>>>>>> - Quite hacky, and userspace still can't guess from initial
>>>>>>   keypress/release if the key is still pressed down or not.
>>>>>>
>>>>>> 4. Same as 1., but have a new EV_RC with RC_KEYDOWN and RC_KEYUP events,
>>>>>>    with RC_KEYDOWN sent when a key is pressed down a first time along
>>>>>>    with the normal EV_KEY event, and RC_KEYUP sent when the key is
>>>>>>    surely released (e.g. 250ms without native repeat events or another
>>>>>>    key got pressed, i.e. like the simulated keyup now).
>>>>>> + Simple to implement, works as expected with most userspace apps with
>>>>>>   no changes to them; and if an app wants to know the repeatness of an
>>>>>>   event or held-down-ness of a key, it can do that.
>>>>>> - Repeatness of the event is hidden behind a new API.
>>>>>>
>>>>>> What do you think? Or any other ideas?
>>>>>>
>>>>>> 2 and 4 seem nicest to me.
>>>>>> (I don't know how feasible 2 would be on X server side, though)
>>>>>>
>>>>>> -- 
>>>>>> Anssi Hannula
>>>>>> _______________________________________________
>>>>>> xorg-devel@lists.x.org: X.Org development
>>>>>> Archives: http://lists.x.org/archives/xorg-devel
>>>>>> Info: http://lists.x.org/mailman/listinfo/xorg-devel
>>>>>>
>>>>>
>>>>
>>>>
>>>> -- 
>>>> Anssi Hannula
>>>
>>
>>
> 


-- 
Anssi Hannula
