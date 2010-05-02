Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f198.google.com ([209.85.211.198]:41730 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727Ab0EBSTO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 May 2010 14:19:14 -0400
Received: by ywh36 with SMTP id 36so824852ywh.4
        for <linux-media@vger.kernel.org>; Sun, 02 May 2010 11:19:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201005022013.03216.hverkuil@xs4all.nl>
References: <201005012312.14082.hverkuil@xs4all.nl>
	 <k2w829197381005021025ra9b453bfv54900a16ae5fb580@mail.gmail.com>
	 <y2l829197381005021049ze19f886cyedeeb79da4d87229@mail.gmail.com>
	 <201005022013.03216.hverkuil@xs4all.nl>
Date: Sun, 2 May 2010 14:19:13 -0400
Message-ID: <p2z829197381005021119t44d57891n2d9e87927932d893@mail.gmail.com>
Subject: Re: em28xx & sliced VBI
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, May 2, 2010 at 2:13 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Why not just nuke everything related to sliced VBI? Just leave a comment
> saying that you should look at older versions if you want to resurrect sliced
> vbi. That's what version control systems are for.

I would have no objection to this.  The sliced VBI support was present
long before I added the raw VBI support.

> I hate code that doesn't do anything. It pollutes the source, it confuses the
> reader and it increases the size for no good reason. And people like me spent
> time flogging a dead horse :-(
>
> Sliced VBI really only makes sense in combination with compressed video
> streams. Or perhaps on SoCs where you don't want to process the raw VBI.

Agreed, which is why nobody I know who is actively using VBI on em28xx
actually cares whether it's sliced or raw.  If somebody comes around
who has a commercial interest in seeing sliced VBI work on the chip,
KernelLabs would be happy to revisit the issue.  Otherwise, there are
much better things we could be spending our time on.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
