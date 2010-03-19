Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:42520 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906Ab0CSTEQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Mar 2010 15:04:16 -0400
Received: by vws11 with SMTP id 11so558744vws.19
        for <linux-media@vger.kernel.org>; Fri, 19 Mar 2010 12:04:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <829197381003191112i762baf17ta2658d859a858a76@mail.gmail.com>
References: <83e56201383c6a99ea51dafcd2794dfe.squirrel@webmail.xs4all.nl>
	 <201003190904.53867.laurent.pinchart@ideasonboard.com>
	 <50cd74a798bbf96501cd40b90d2a2b93.squirrel@webmail.xs4all.nl>
	 <4BA38088.1020006@redhat.com>
	 <30353c3d1003190849v35b57dcai9ab11ff1362b4f46@mail.gmail.com>
	 <4BA3B7A9.2050405@redhat.com>
	 <30353c3d1003191100q2446edeekb161dba45624489a@mail.gmail.com>
	 <829197381003191112i762baf17ta2658d859a858a76@mail.gmail.com>
Date: Fri, 19 Mar 2010 12:04:12 -0700
Message-ID: <a3ef07921003191204w60bc955bye34dd53fabbc0b97@mail.gmail.com>
Subject: Re: RFC: Drop V4L1 support in V4L2 drivers
From: VDR User <user.vdr@gmail.com>
To: v4l-dvb <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Keeping v4l1 because some guys are still using some ancient setup is
not a good reason.  Keeping v4l1 because some app devs still haven't
bothered to update their apps is not a good reason, especially given
the amount of time they've had to complete this task.  Keeping v4l1
because package maintainers haven't bothered to update their packages
is not a good reason.

To put it simply, v4l1 is just dragging along dead weight.  It has
been replaced by something better and there's no reasonable excuse to
keep dragging it along.  There will always be someone complaining
because there will always be someone neglecting to make the transition
until the last possible second or resisting change even when it's for
the better.

App devs that haven't bothered to update -- you've had plenty of time
to get it done.  If you app breaks, it's not v4l's fault at this
point.

Users still on ancient hardware -- consider updating to cheap newer
alternatives but don't expect v4l to be held back because you refuse
to move forward.  Or politely request old drivers be converted.

Package maintainers -- if it's too much of a hassle to keep your
package(s) updated, consider giving that responsibility to someone
else.

The points made in this thread make it pretty obvious that dumping
v4l1 altogether is easily for the best and has only very minimal
negative impact.  And the negatives aren't anything that can't be
resolved completely with a little commitment to do so.

Best regards,
Derek
