Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:31343 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751840Ab1GAPFi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 1 Jul 2011 11:05:38 -0400
Message-ID: <4E0DE283.2030107@redhat.com>
Date: Fri, 01 Jul 2011 17:06:43 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Some comments on the new autocluster patches
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Hans (et all),

I've been working on doing a much needed cleanup to the pwc driver,
converting it to videobuf2 and using the new ctrl framework.

I hope to be able to send a pull request for this, this weekend.

I saw your pull request and I'm looking forward to be able to
play with ctrl events. I do have some comments on your autofoo
cluster patches and related changes though.

First of all there is:
"v4l2-ctrls: fix and improve volatile control handling."

I must admit I was a bit confused about needing to set
cur.val rather then just val from the g_volatile_ctrl op
myself at first too, but I've gotten used to it now :)

With that said I'm not quite sure I like to proposed change
though, where g_ctrl will return the new value as long as the
control is volatile and then jump to the old cur val when
it turns non volatile (ie autogain is turned off) this seems
wrong to me, it will certainly surprise both driver writers
and v4l2 app users alike!

Also this requires special care taking by drivers when ie
autogain gets turned off, either they need to update cur.val
with the real current value, or they need to send the cur.val
to the device at this point to ensure the device's setting
and cur.val match.

Actually this brings me to the second point, making ie gain
non volatile as soon as autogain gets turned off, can be wrong,
as the gain may have changed between the last g_volatile_ctrl
call and the autogain getting turned off. I admit that
your solution of simply not updating cur.val and at all as long
as the ctrl is volatile and then jump back to cur.val avoids
this, but I find that less then ideal.

The entire model of having a separate manual value (stored in
cur.val) and an autocontrolled value stored in val as long
as the control is volatile, seems to assume a device with
2 separate registers for gain, one with the active gain,
and one with a manual gain preset. Where in auto mode only
the active gain is controlled and switching to manual
gain mode copies the manual gain value to the active gain.

This is IMHO a pretty limited model of reality, I know
you have experience with a device which happens to work
like that, but many do not work like that.

Actually the pwc has 2 registers, but when switching to
manual mode, it updates the manual setting register, with
the last value set in the active register by the autogain,
so the other way around then your model assumes.


But we should not be looking at existing hardware at all,
instead we should be looking at the user experience, and
build our model from there. Drivers will have to cope
with all the different variations on this theme at the
driver level IMHO.

And looking from the users perspective the right choice
is obvious IMHO. When the user turns of auto-foo, then
following the principle of least surprise, the right
thing to do is to leave the control at its current
setting, because likely the user wants to make some
adjustments to the auto-foo chosen value for foo.
Rather then to start over with some $random (from the
users perspective) value for foo. Imagine that
auto-foo has been on since driver loading, then the
value in cur.val has never been seen by the user before,
yet switching to manual all of a sudden switches
to this unseen value -> confused user

I suggest that when an auto-foo control gets turned of
the code calls g_volatile_ctrl one last time after
actually turning it off and stores the result in cur.val

Actually in my current pwc code I've done this by moving
the clearing of the volatile flag to the g_volatile_ctrl
op, when g_volatile_ctrl-foo gets called and auto-foo is
off, then g_volatile_ctrl-foo clears the volatile flag.

This avoid needlessly calling g_volatile_ctrl-foo if
auto-foo gets turned off, but no one cares about the
value of foo after that.

Note that this depends on the old behavior of
g_volatile_ctrl setting cur.val rather then just val.

Regards,

Hans
