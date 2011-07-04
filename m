Return-path: <mchehab@pedra>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:2523 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324Ab1GDGbE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2011 02:31:04 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Hans de Goede <hdegoede@redhat.com>
Subject: Re: New ctrl framework also enumerates classes
Date: Mon, 4 Jul 2011 08:30:58 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <4E115C4E.804@redhat.com>
In-Reply-To: <4E115C4E.804@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107040830.58788.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Monday, July 04, 2011 08:23:10 Hans de Goede wrote:
> Hi All,
> 
> One last thing before I really leave on vacation which just popped
> in my mind as something which I had not mentioned yet.
> 
> The new ctrl framework also enumerates classes when enumerating
> ctrls with the next flag. I wonder if this is intentional?

It's absolutely intentional. It's needed to produce the headers of the
tabs in e.g. qv4l2. It's been part of the spec for several years now.

> IOW if this is a feature or a bug?
> 
> Either way this confuses various userspace apps, gtk-v4l prints
> warnings about an unknown control type,

It should just skip such types.

> and v4l2ucp gets a very
> messed up UI because of this change. Thus unless there are
> really strong reasons to do this, I suggest we skip classes
> when enumerating controls.

Those apps should be fixed. If apps see an unknown type, then they should
always just skip such controls (and later add support for it, of course).

Another control type (bitmask) will be merged soon as well, so the same
problem will occur with that, but this is all really an application bug.
Apps should be tested with vivi: that driver has all control types that we
have, so that's a good driver to test with.

Regards,

	Hans
