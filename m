Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61315 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760679AbZKZQHu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Nov 2009 11:07:50 -0500
Message-ID: <4B0EA7CC.9070309@redhat.com>
Date: Thu, 26 Nov 2009 14:07:40 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Jarod Wilson <jarod@wilsonet.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Krzysztof Halasa <khc@pm.waw.pl>,
	Jarod Wilson <jarod@redhat.com>, linux-kernel@vger.kernel.org,
	Mario Limonciello <superm1@ubuntu.com>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org,
	Janne Grunau <j@jannau.net>,
	Christoph Bartelmus <lirc@bartelmus.de>
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was:
 Re: [PATCH 1/3 v2] lirc core device driver infrastructure
References: <200910200956.33391.jarod@redhat.com> <200910200958.50574.jarod@redhat.com> <4B0A765F.7010204@redhat.com> <4B0A81BF.4090203@redhat.com> <m36391tjj3.fsf@intrepid.localdomain> <20091123173726.GE17813@core.coreip.homeip.net> <4B0B6321.3050001@wilsonet.com> <20091126053109.GE23244@core.coreip.homeip.net> <A910E742-51B5-45E0-AD80-B9AE0728D9FB@wilsonet.com>
In-Reply-To: <A910E742-51B5-45E0-AD80-B9AE0728D9FB@wilsonet.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jarod Wilson wrote:

>> I guess the question is what is the interface we want the regular
>> userspace (i.e. not lircd) to use. Right now programs has to use 2
>> intercfaces - one lirc for dealing with remotes that are not using
>> the standard event interface and evdev for remotes using it as well
>> as the rest of the input devices.
> 
> From the mythtv perspective, using the input layer could yield a better
> out-of-the-box experience -- users don't have to set up an lircrc mapping
> that converts key names as specified in lircd.conf into commands 
> (key strokes, actually) that mythtv understands. For example, a button labeled "Play"
> in lircd.conf has to be mapped to 'p' in ~/.lircrc for mythtv to do the right 
> thing with it. If everything came through the input layer, be that natively
> or via lircd's uinput reinjection, there would be no need to do that extra 
> mapping step, mythtv would simply handle a KEY_PLAY event. So at worst, 
> one manual mapping to do -- IR signal to standard button name in lircd.conf -- 
> instead of two. But the lircrc approach does also allow more flexibility, 
> in that you can only have a certain app respond to a certain key, if so desired, 
> and remap a key to a different function (KEY_RED, KEY_GREEN, KEY_BLUE, KEY_YELLOW
>  -- what should their default functionality be? I know some users map a pair
> of those to mythtv's "skip to next commflag point" and "skip to prior commflag point").
> 
> Unfortunately, mythtv currently doesn't handle KEY_PLAY, KEY_VOLUMEUP, etc., etc. at 
> all right now, it operates purely on keys commonly found on a standard keyboard.
> Remedying that is on my TODO list for the next release, if I can carve out the time.

This discussion is a little OT from the API discussions, since it affects both out-of-the
box IR reception via input layer and lirc.

All media applications should be capable of handling the corresponding KEY_PLAY, KEY_VOLUMEUP ...
keys without needing to do anything else than just handling the corresponding keycode.
You shouldn't need to start a daemon or doing anything else for this to work out-of-the-box.

They currently don't do it due to historic reasons (it is easier to let something else
remap KEY_PLAY into 'p' than to add the proper code there).

When using non-hot-pluggable devices where you're building a dedicated MCE hardware (this 
is the common case of MythTV setups), things are not that bad, since, once you set your
hardware, it is done.

However, by looking on the number of different new devices, it seems that the most common 
type of devices are the TV USB sticks. As they are hot pluggable, eventually users may 
have more than one hardware and they expect that the IR layer will work equally on
all your devices.

The proper way for supporting it is to have a common application-agnostic keycode to indicate
the received events. For example, all IR's should produce KEY_CHANNELUP/KEY_CHANNELDOWN events
for changing the channels. Also, on a perfect world, lirc should send this event to the
multimedia application that handles TV when such key is pressed, instead of converting into
some other keycode. This prevents future problems if, for some reason, the application needs to
do something else with that key, or if the key has a different meaning on some different contexts.

For example, on some applications, KEY_UP/KEY_DOWN can mean to change a channel, but those keys
are also used for menu navigation. However, KEY_CHANNELUP has a clear unique meaning: to change a channel. 
The expected behavior, from users perspective, is to mimic a TV box, where if you press channel UP
any open menu will be closed and the channel will be changed, but pressing UP key will
navigate at the menu. Well, if you map KEY_CHANNELUP as KEY_UP, you'll produce a different behavior.

Cheers,
Mauro.
