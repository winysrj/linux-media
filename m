Return-path: <mchehab@gaivota>
Received: from sypressi.dnainternet.net ([83.102.40.135]:59023 "EHLO
	sypressi.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768Ab1EHEoG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 May 2011 00:44:06 -0400
Message-ID: <4DC61E28.4090301@iki.fi>
Date: Sun, 08 May 2011 07:38:00 +0300
From: Anssi Hannula <anssi.hannula@iki.fi>
MIME-Version: 1.0
To: linux-media@vger.kernel.org,
	"linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
	xorg-devel@lists.freedesktop.org
Subject: IR remote control autorepeat / evdev
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi all!

Most IR/RF remotes differ from normal keyboards in that they don't
provide release events. They do provide native repeat events, though.

Currently the Linux kernel RC/input subsystems provide a simulated
autorepeat for remote controls (default delay 500ms, period 33ms), and
X.org server ignores these events and generates its own autorepeat for them.

The kernel RC subsystem provides a simulated release event when 250ms
has passed since the last native event (repeat or non-repeat) was
received from the device.

This is problematic, since it causes lots of extra repeat events to be
always sent (for up to 250ms) after the user has released the remote
control button, which makes the remote quite uncomfortable to use.

Now, IMO something should be done to fix this. But what exactly?

Here are two ideas that would remove these ghost repeats:

1. Do not provide any repeat/release simulation in the kernel for RC
devices (by default?), just provide both keydown and immediate release
events for every native keypress or repeat received from the device.
+ Very simple to implement
- We lose the ability to track repeats, i.e. if a new event was a repeat
  or a new keypress; "holding down" a key becomes impossible

or
2. Replace kernel autorepeat simulation by passing through the native
repeat events (probably filtering them according to REP_DELAY and
REP_PERIOD), and have a device property bit (fetchable via EVIOCGPROP)
indicating that the keyrelease is simulated, and have the X server use
the native repeats instead of softrepeats for such a device.
+ The userspace correctly gets repeat events tagged as repeats and
  release events when appropriate (albeit a little late)
- Adds complexity. Also, while the kernel part is quite easy to
  implement, I'm not sure if the X server part is.

or
3. Same as 1., but indicate the repeatness of an event with a new
   additional special event before EV_SYN (sync event).
+ Simple to implement
- Quite hacky, and userspace still can't guess from initial
  keypress/release if the key is still pressed down or not.

4. Same as 1., but have a new EV_RC with RC_KEYDOWN and RC_KEYUP events,
   with RC_KEYDOWN sent when a key is pressed down a first time along
   with the normal EV_KEY event, and RC_KEYUP sent when the key is
   surely released (e.g. 250ms without native repeat events or another
   key got pressed, i.e. like the simulated keyup now).
+ Simple to implement, works as expected with most userspace apps with
  no changes to them; and if an app wants to know the repeatness of an
  event or held-down-ness of a key, it can do that.
- Repeatness of the event is hidden behind a new API.

What do you think? Or any other ideas?

2 and 4 seem nicest to me.
(I don't know how feasible 2 would be on X server side, though)

-- 
Anssi Hannula
