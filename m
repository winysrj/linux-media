Return-path: <linux-media-owner@vger.kernel.org>
Received: from static-72-93-233-3.bstnma.fios.verizon.net ([72.93.233.3]:37537
	"EHLO mail.wilsonet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715AbZKZGQA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Nov 2009 01:16:00 -0500
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was: Re: [PATCH 1/3 v2] lirc core device driver infrastructure
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
From: Jarod Wilson <jarod@wilsonet.com>
In-Reply-To: <20091126053109.GE23244@core.coreip.homeip.net>
Date: Thu, 26 Nov 2009 01:16:01 -0500
Cc: Krzysztof Halasa <khc@pm.waw.pl>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Jarod Wilson <jarod@redhat.com>, linux-kernel@vger.kernel.org,
	Mario Limonciello <superm1@ubuntu.com>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org,
	Janne Grunau <j@jannau.net>,
	Christoph Bartelmus <lirc@bartelmus.de>
Content-Transfer-Encoding: 8BIT
Message-Id: <A910E742-51B5-45E0-AD80-B9AE0728D9FB@wilsonet.com>
References: <200910200956.33391.jarod@redhat.com> <200910200958.50574.jarod@redhat.com> <4B0A765F.7010204@redhat.com> <4B0A81BF.4090203@redhat.com> <m36391tjj3.fsf@intrepid.localdomain> <20091123173726.GE17813@core.coreip.homeip.net> <4B0B6321.3050001@wilsonet.com> <20091126053109.GE23244@core.coreip.homeip.net>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Nov 26, 2009, at 12:31 AM, Dmitry Torokhov wrote:

> On Mon, Nov 23, 2009 at 11:37:53PM -0500, Jarod Wilson wrote:
>> On 11/23/2009 12:37 PM, Dmitry Torokhov wrote:
>>> On Mon, Nov 23, 2009 at 03:14:56PM +0100, Krzysztof Halasa wrote:
>>>> Mauro Carvalho Chehab<mchehab@redhat.com>  writes:
>>>> 
>>>>> Event input has the advantage that the keystrokes will provide an unique
>>>>> representation that is independent of the device.
>>>> 
>>>> This can hardly work as the only means, the remotes have different keys,
>>>> the user almost always has to provide customized key<>function mapping.
>>>> 
>>> 
>>> Is it true? I would expect the remotes to have most of the keys to have
>>> well-defined meanings (unless it is one of the programmable remotes)...
>> 
>> Its the cases like programmable universal remotes that really throw  
>> things for a loop. That, and people wanting to use random remote X that  
>> came with the amp or tv or set top box, with IR receiver Y.
> 
> Right, but still the keys usually do have the well-defined meaning,

Except when they don't. I have two very similar remotes, one that was bundled with a system from CaptiveWorks, and one that was bundled with an Antec Veris IR/LCD (SoundGraph iMON rebrand). Outside of the Antec remote having a mouse pad instead of up/down/left/right/enter, they have an identical layout, and the keys in the same locations on the remotes send the same IR signal. But the button names vary a LOT between the two. So on the DVD key on the Antec and the MUTE key on the CW send the same signal. Same with Audio vs. Eject, TV vs. History, etc. Moral of the story is that not all IR protocols spell things out particularly well for what a given code should actually mean.

> teh
> issue is in mapping raw code to the appropriate keycode. This can be
> done either by lirc config file (when lirc is used) or by some other
> means.

The desire to map a button press to multiple keystrokes isn't uncommon either, though I presume that's doable within the input layer context too.

>> ...
>>>> We need to handle more than one RC at a time, of course.
>>>> 
>>>>> So, the basic question that should be decided is: should we create a new
>>>>> userspace API for raw IR pulse/space
>>>> 
>>>> I think so, doing the RCx proto handling in the kernel (but without
>>>> RCx raw code<>  key mapping in this case due to multiple controllers
>>>> etc.). Though it could probably use the input layer as well(?).
>>>> 
>>> 
>>> I think if the data is used to do the primary protocol decoding then it
>>> should be a separate interface that is processed by someone and then fed
>>> into input subsystem (either in-kernel or through uinput).
>>> 
>>> Again, I would prefer to keep EV_KEY/KEY_* as the primary event type for
>>> keys and buttons on all devices.
>> 
>> Current lircd actually inter-operates with the input subsystem quite  
>> well for any and all supported remotes if their keys are mapped in their  
>> respective lircd.conf file using standard input subsystem key names, and  
>> the lirc daemon started with the --uinput param. lircd decodes the raw  
>> IR, finds the mapping in its config, and happily passes it along to 
>> uinput.
> 
> Right.
> 
> I guess the question is what is the interface we want the regular
> userspace (i.e. not lircd) to use. Right now programs has to use 2
> intercfaces - one lirc for dealing with remotes that are not using
> the standard event interface and evdev for remotes using it as well
> as the rest of the input devices.

>From the mythtv perspective, using the input layer could yield a better out-of-the-box experience -- users don't have to set up an lircrc mapping that converts key names as specified in lircd.conf into commands (key strokes, actually) that mythtv understands. For example, a button labeled "Play" in lircd.conf has to be mapped to 'p' in ~/.lircrc for mythtv to do the right thing with it. If everything came through the input layer, be that natively or via lircd's uinput reinjection, there would be no need to do that extra mapping step, mythtv would simply handle a KEY_PLAY event. So at worst, one manual mapping to do -- IR signal to standard button name in lircd.conf -- instead of two. But the lircrc approach does also allow more flexibility, in that you can only have a certain app respond to a certain key, if so desired, and remap a key to a different function (KEY_RED, KEY_GREEN, KEY_BLUE, KEY_YELLOW -- what should their default functionality be? I know some users map a pair of those to mythtv's "skip to next commflag point" and "skip to prior commflag point").

Unfortunately, mythtv currently doesn't handle KEY_PLAY, KEY_VOLUMEUP, etc., etc. at all right now, it operates purely on keys commonly found on a standard keyboard. Remedying that is on my TODO list for the next release, if I can carve out the time.

-- 
Jarod Wilson
jarod@wilsonet.com



