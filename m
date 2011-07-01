Return-path: <mchehab@pedra>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:2648 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756569Ab1GAQVk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Jul 2011 12:21:40 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Hans de Goede <hdegoede@redhat.com>
Subject: Re: Some comments on the new autocluster patches
Date: Fri, 1 Jul 2011 18:21:33 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <4E0DE283.2030107@redhat.com>
In-Reply-To: <4E0DE283.2030107@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107011821.33960.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Friday, July 01, 2011 17:06:43 Hans de Goede wrote:
> Hi Hans (et all),
> 
> I've been working on doing a much needed cleanup to the pwc driver,
> converting it to videobuf2 and using the new ctrl framework.
> 
> I hope to be able to send a pull request for this, this weekend.

Thanks!

> I saw your pull request and I'm looking forward to be able to
> play with ctrl events. I do have some comments on your autofoo
> cluster patches and related changes though.
> 
> First of all there is:
> "v4l2-ctrls: fix and improve volatile control handling."
> 
> I must admit I was a bit confused about needing to set
> cur.val rather then just val from the g_volatile_ctrl op
> myself at first too, but I've gotten used to it now :)
> 
> With that said I'm not quite sure I like to proposed change
> though, where g_ctrl will return the new value as long as the
> control is volatile and then jump to the old cur val when
> it turns non volatile (ie autogain is turned off) this seems
> wrong to me, it will certainly surprise both driver writers
> and v4l2 app users alike!
> 
> Also this requires special care taking by drivers when ie
> autogain gets turned off, either they need to update cur.val
> with the real current value, or they need to send the cur.val
> to the device at this point to ensure the device's setting
> and cur.val match.
> 
> Actually this brings me to the second point, making ie gain
> non volatile as soon as autogain gets turned off, can be wrong,
> as the gain may have changed between the last g_volatile_ctrl
> call and the autogain getting turned off. I admit that
> your solution of simply not updating cur.val and at all as long
> as the ctrl is volatile and then jump back to cur.val avoids
> this, but I find that less then ideal.
> 
> The entire model of having a separate manual value (stored in
> cur.val) and an autocontrolled value stored in val as long
> as the control is volatile, seems to assume a device with
> 2 separate registers for gain, one with the active gain,
> and one with a manual gain preset. Where in auto mode only
> the active gain is controlled and switching to manual
> gain mode copies the manual gain value to the active gain.
> 
> This is IMHO a pretty limited model of reality, I know
> you have experience with a device which happens to work
> like that, but many do not work like that.

The problem with the old approach was that cur.val was overwritten. So you
lost that information completely. The new approach keeps that value and
it is up to the driver what to do when the autogain is switched off.

In s_ctrl you can either use val (this is either a new manual gain value
set by the application, or the last manual gain value), or you can do
something like this:

if (autogain->cur.val == 1 && autogain->val == 0 && !gain->is_new)
	gain->val = read_gain();

But I also see my patch below :-)

> Actually the pwc has 2 registers, but when switching to
> manual mode, it updates the manual setting register, with
> the last value set in the active register by the autogain,
> so the other way around then your model assumes.

One possible problem with this approach BTW is that those gain values
set by the autogain on the chip are not always reliable. If I toggle the
autogain quickly from false to true to false, then the gain value after
I switch back to false from e.g. the saa7115 is usually bogus.

> 
> 
> But we should not be looking at existing hardware at all,
> instead we should be looking at the user experience, and
> build our model from there. Drivers will have to cope
> with all the different variations on this theme at the
> driver level IMHO.
> 
> And looking from the users perspective the right choice
> is obvious IMHO. When the user turns of auto-foo, then
> following the principle of least surprise, the right
> thing to do is to leave the control at its current
> setting, because likely the user wants to make some
> adjustments to the auto-foo chosen value for foo.
> Rather then to start over with some $random (from the
> users perspective) value for foo. Imagine that
> auto-foo has been on since driver loading, then the
> value in cur.val has never been seen by the user before,
> yet switching to manual all of a sudden switches
> to this unseen value -> confused user

Is this the least surprise? First of all: generally user-visible controls
like gain are not normally refreshed, so the value you see is the value the
user set the last time. Calling g_volatile_ctrl when switching back to manual
gain would actually unexpectedly change the value. Another reason for not doing
this is that the user might have painstakingly determined a great manual gain
value, which is completely undone if he switches on autogain mode and then
switches it off again.

It's not so simple...

Think of a TV: the manual values don't change when you turn on or off an
autofoo control. Frankly, I think that volatile behavior for writable controls
is dubious at best. Perhaps we should add a flag that you need to explicitly
set in order to get the volatile value. E.g. G_CTRL(V4L2_CID_GAIN) gives the
normal manual gain, and G_CTRL(V4L2_CID_GAIN | V4L2_CTRL_FLAG_VOLATILE) gives
the 'volatile' gain.

Or just add a proper read-only volatile control like AUTOGAIN_GAIN (ugly name).

> I suggest that when an auto-foo control gets turned of
> the code calls g_volatile_ctrl one last time after
> actually turning it off and stores the result in cur.val

I would prefer to make this optional by passing an extra flag or
something like that to v4l2_ctrl_autocluster. It's easy enough to do
in the control framework, but hardware varies too much to assume that
this is what you always want.

> Actually in my current pwc code I've done this by moving
> the clearing of the volatile flag to the g_volatile_ctrl
> op, when g_volatile_ctrl-foo gets called and auto-foo is
> off, then g_volatile_ctrl-foo clears the volatile flag.
> 
> This avoid needlessly calling g_volatile_ctrl-foo if
> auto-foo gets turned off, but no one cares about the
> value of foo after that.

I think I need to see the code first.
 
> Note that this depends on the old behavior of
> g_volatile_ctrl setting cur.val rather then just val.

This new behavior is definitely better and I want to keep that.

Below is a patch for v4l2-ctrls.c that changes the behavior in just the
way you want it.

It's on top of my 'core8c' branch:

http://git.linuxtv.org/hverkuil/media_tree.git?a=shortlog;h=refs/heads/core8c

Regards,

	Hans

diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index 37a50e5..65d9be7 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -1915,6 +1915,15 @@ static int try_set_ext_ctrls(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
 			if (master->cluster[j])
 				master->cluster[j]->is_new = 0;
 
+		if (has_op(master, g_volatile_ctrl) && !is_cur_manual(master)) {
+			for (j = 0; j < master->ncontrols; j++)
+				cur_to_new(master->cluster[j]);
+			if (!call_op(master, g_volatile_ctrl))
+				for (j = 1; j < master->ncontrols; j++)
+					if (master->cluster[j]->is_volatile)
+						master->cluster[j]->is_new = 1;
+		}
+
 		/* Copy the new caller-supplied control values.
 		   user_to_new() sets 'is_new' to 1. */
 		do {
