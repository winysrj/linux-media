Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:2716 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755220Ab2IQPmB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Sep 2012 11:42:01 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH 1/4] videobuf2-core: Replace BUG_ON and return an error at vb2_queue_init()
Date: Mon, 17 Sep 2012 17:41:24 +0200
Cc: Ezequiel Garcia <elezegarcia@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
References: <1347889437-15073-1-git-send-email-elezegarcia@gmail.com> <201209171610.43862.hverkuil@xs4all.nl> <20120917093636.635feb96@lwn.net>
In-Reply-To: <20120917093636.635feb96@lwn.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209171741.24310.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon September 17 2012 17:36:36 Jonathan Corbet wrote:
> On Mon, 17 Sep 2012 16:10:43 +0200
> Hans Verkuil <hverkuil@xs4all.nl> wrote:
> 
> > Why WARN_ON_ONCE? I'd want to see this all the time, not just once.
> > 
> > It's certainly better than BUG_ON, but I'd go for WARN_ON.
> 
> I like WARN_ON_ONCE better, myself.  Avoids the risk of spamming the logs,
> and once is enough to answer that "why doesn't my camera work?" question.
> Don't feel all that strongly about it, though...

However, videobuf2-core.c is a core function of a core module. So it will
give this warning once for one driver, then another is loaded with the same
problem and you'll get no warnings anymore. It makes sense in a driver, but
not here IMHO. Unless I'm missing something.

Neither is this likely to ever spam the logs. It's called only when the device
is initialized.

Regards,

	Hans
