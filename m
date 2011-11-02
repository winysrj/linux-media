Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54508 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751572Ab1KBKDU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 2 Nov 2011 06:03:20 -0400
Message-ID: <4EB1157D.2000602@redhat.com>
Date: Wed, 02 Nov 2011 11:03:41 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 4/6] v4l2-event: Don't set sev->fh to NULL on unsubscribe
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

<resend with correct subject, sorry for the confusing wrong subject with the previous mail>

Hi,

hverkuil wrote:

 >On Thursday, October 27, 2011 13:18:01 Hans de Goede wrote:
>> 1: There is no reason for this after v4l2_event_unsubscribe releases the
>> spinlock nothing is holding a reference to the sev anymore except for the
>> local reference in the v4l2_event_unsubscribe function.
>
> Not true. v4l2-ctrls.c may still have a reference to the sev through the
> ev_subs list in struct v4l2_ctrl. The send_event() function checks for a
> non-zero fh.

Ah, yes. You're right v4l2-ctrls.c may still hold a reference after
releasing the spinlock.

*But* setting sev->fh to NULL and checking for this in v4l2-ctrls: send_event(),
or doing something similar, is not only not needed it is outright wrong.
v4l2_event_unsubscribe() and v4l2-ctrls: send_event() don't hold any shared
lock, so any form of test then use in v4l2-ctrls: send_event() is inherent racy.

Here is the relevant code from v4l2-ctrls: send_event():

	if (sev->fh && (sev->fh != fh ||
			(sev->flags & V4L2_EVENT_SUB_FL_ALLOW_FEEDBACK)))
		v4l2_event_queue_fh(sev->fh, &ev);

Now lets say that v4l2_event_unsubscribe and v4l2-ctrls: send_event() race
on the same sev, then the following could happens:

1) send_event checks sev->fh, finds it is not NULL
<thread switch>
2) v4l2_event_unsubscribe sets sev->fh NULL
3) v4l2_event_unsubscribe calls v4l2_ctrls del_event function, this blocks
    as the thread calling send_event holds the ctrl_lock
<thread switch>
4) send_event calls v4l2_event_queue_fh(sev->fh, &ev) which not is equivalent
    to calling: v4l2_event_queue_fh(NULL, &ev)
5) oops, NULL pointer deref.

Now again without setting sev->fh to NULL in v4l2_event_unsubscribe and
without the (now senseless since always true) sev->fh != NULL check in
send_event:

1) send_event is about to call v4l2_event_queue_fh(sev->fh, &ev)
<thread switch>
2) v4l2_event_unsubscribe removes sev->list from the fh->subscribed list
<thread switch>
3) send_event calls v4l2_event_queue_fh(sev->fh, &ev)
4) v4l2_event_queue_fh blocks on the fh_lock spinlock
<thread switch>
5) v4l2_event_unsubscribe unlocks the fh_lock spinlock
6) v4l2_event_unsubscribe calls v4l2_ctrls del_event function, this blocks
    as the thread calling send_event holds the ctrl_lock
<thread switch>
8) v4l2_event_queue_fh takes the fh_lock
7) v4l2_event_queue_fh calls v4l2_event_subscribed, does not find it since
    sev->list has been removed from fh->subscribed already -> does nothing
9) v4l2_event_queue_fh releases the fh_lock
10) the caller of send_event releases the ctrl lock (mutex)
<thread switch>
11) v4l2_ctrls del_event takes the ctrl lock
12) v4l2_ctrls del_event removes sev->node from the ev_subs list
13) v4l2_ctrls del_event releases the ctrl lock
14) v4l2_event_unsubscribe frees the sev, to which no references are being
     held anymore

> All that is needed is to find some different way of letting send_event()
> know that this sev is no longer used. Perhaps by making sev->list empty?

Actually as explained above the fix is to not do any checks and let both
"subsystems" take care of their own locking / consistency without any
interactions (other then that v4l2_ctrls should not hold any references
to the sev after its del op has completed).

I'll update the patch to also remove the sev->fh check from v4l2_ctrls:
send_event() and update the commit message.

Regards,

Hans
