Return-path: <mchehab@pedra>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:4592 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072Ab1GBJgg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Jul 2011 05:36:36 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: Some comments on the new autocluster patches
Date: Sat, 2 Jul 2011 11:36:31 +0200
Cc: Hans de Goede <hdegoede@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <4E0DE283.2030107@redhat.com> <4E0E6C6E.7050408@redhat.com>
In-Reply-To: <4E0E6C6E.7050408@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201107021136.31542.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Saturday, July 02, 2011 02:55:10 Mauro Carvalho Chehab wrote:
> Em 01-07-2011 12:06, Hans de Goede escreveu:
> > Hi Hans (et all),
> > 
> > I've been working on doing a much needed cleanup to the pwc driver,
> > converting it to videobuf2 and using the new ctrl framework.
> > 
> > I hope to be able to send a pull request for this, this weekend.
> > 
> > I saw your pull request and I'm looking forward to be able to
> > play with ctrl events. I do have some comments on your autofoo
> > cluster patches and related changes though.
> >
> 
> Hi Hans & Hans,
> 
> I've applied Hans V. patches at the tree, to allow them to be better
> tested. I'm not 100% comfortable with the patches, and, from my understanding
> the poll() changes are needed, in order to fix vivi behavior and add the
> event patches for ivtv. I didn't have much time to test the patches (is qv4l2
> already ready to test them?)

I have a version that I use for testing in this repo:

http://git.linuxtv.org/hverkuil/v4l-utils.git?a=shortlog;h=refs/heads/core

It's pretty ugly, though. Now that the patches are merged I'll work on cleaning
it up. I do have patches for v4l2-ctl as well to easily test control events.
That's good code and I'll commit that today.

Regarding qv4l2: as long as the poll() situation is not resolved I can't commit
it to v4l-utils anyway. It is just doesn't work in that specific situation.

> Due to that, it is probably safer to hold those patches to be merged upstream 
> at 3.2, after playing with them for a while at the development tree and at -next.

Note that the only time these patches become problematic is when you want to
wait on events, and just events. None of these patches will break existing
applications. It is also not a new problem, we had this issue ever since we
introduced DQEVENT. It's just that this new control event is more likely to
be used in situations where this issue is triggered (e.g. qv4l2-like apps).

Since this control event is also going to be used in embedded applications
(flash API and the HDMI API we are working on) I am not in favor of delaying
this an extra kernel cycle. Delaying the qv4l2 changes is another matter of
course. Those will have to wait. Hmm, I could only enable the control events
in qv4l2 for drivers that do *not* support the read/write API. That would
work, I guess. I'll have to think about that a bit.

Regards,

	Hans

> So, feel free to suggest changes without being stick to the current API, as, while
> they're not merging upstream, we can change/fix some things that aren't behaving
> well.

