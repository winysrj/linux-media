Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:51310 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752626Ab2GRPTq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Jul 2012 11:19:46 -0400
Received: by yhmm54 with SMTP id m54so1662915yhm.19
        for <linux-media@vger.kernel.org>; Wed, 18 Jul 2012 08:19:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <10659368.KqSHeLc7Gn@avalon>
References: <20120713173708.GB17109@thunk.org>
	<201207172132.22937.hverkuil@xs4all.nl>
	<1433177.IUeFs9YjWS@avalon>
	<10659368.KqSHeLc7Gn@avalon>
Date: Wed, 18 Jul 2012 11:19:44 -0400
Message-ID: <CAGoCfiwX-NAbAzGdYVfN_OW7MQ8gX1UxxMBrL+mXhgqkFfcuyg@mail.gmail.com>
Subject: Re: [Workshop-2011] Media summit at the Kernel Summit - was: Fwd: Re:
 [Ksummit-2012-discuss] Organising Mini Summits within the Kernel Summit
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: workshop-2011@linuxtv.org, Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jul 18, 2012 at 10:00 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Another ambiguity for your list: what should a driver return in TRY_FMT/S_FMT
> if the requested format is not supported (possible behaviours include
> returning the currently selected format or a default format).

Whatever gets decided in terms of eliminating the ambiguity, we should
definitely do a v4l2-compliance test for this.  I've seen drivers in
the past that return -EINVAL if the requested format is not supported
(which resulted in various userland apps inventing their own
workarounds over the years).

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
