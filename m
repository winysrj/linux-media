Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f221.google.com ([209.85.220.221]:59176 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754289AbZKRJz2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Nov 2009 04:55:28 -0500
Received: by fxm21 with SMTP id 21so950672fxm.21
        for <linux-media@vger.kernel.org>; Wed, 18 Nov 2009 01:55:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <200911181042.40579.laurent.pinchart@ideasonboard.com>
References: <1258504731-8430-1-git-send-email-laurent.pinchart@ideasonboard.com>
	 <829197380911180056i5102b87bw2926a7b38608570d@mail.gmail.com>
	 <4c8e56e69e0b1619dd4e5c32d45b8374.squirrel@webmail.xs4all.nl>
	 <200911181042.40579.laurent.pinchart@ideasonboard.com>
Date: Wed, 18 Nov 2009 04:55:32 -0500
Message-ID: <829197380911180155s65b66353t6b6094cca5a95192@mail.gmail.com>
Subject: Re: v4l: Use the video_drvdata function in drivers
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	mchehab@infradead.org, sakari.ailus@maxwell.research.nokia.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Nov 18, 2009 at 4:42 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> I will setup a test tree to help maintainers test the changes. I can split
> some patches if needed, but how would that help exactly ?

Hello Laurent,

In this case, splitting up the patch would just make it easier to
review, and potentially to check in changes for specific bridges as
they are validated (as opposed to all at once).  However, even just
having all your changes in a tree that can be checked out and tested
by users is probably "good enough" and would still provide
considerable value.

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
