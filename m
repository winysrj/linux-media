Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:46373 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754193Ab2BFLso (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Feb 2012 06:48:44 -0500
Received: by qcqw6 with SMTP id w6so3303884qcq.19
        for <linux-media@vger.kernel.org>; Mon, 06 Feb 2012 03:48:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20120205185233.3ca5024a@tiber>
References: <20120203171250.52278c25@junior>
	<CAH4Ag-BZ+Csasy=yk5sNt7_Q5maFuxga2PqeXtJrRYvVLa8zzA@mail.gmail.com>
	<20120205185233.3ca5024a@tiber>
Date: Mon, 6 Feb 2012 11:48:43 +0000
Message-ID: <CAH4Ag-BL3V2th8tu78iE3toCo2SxbRHVpNzMB6jEfs2C5iuzBQ@mail.gmail.com>
Subject: Re: TBS 6920 remote
From: Simon Jones <sijones2010@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Thanks. It seems that there was a bug in their driver which prevented
> some keys from working, but AFIACT it's fixed now. The code is GPL so is
> it just lack of interest/demand that's stopped it from going into the
> main kernel?

They have an NDA with a chip supplier so can't release the full
source, I think there is a binary blob somewhere that makes it so you
can't include them.

> I think I'll pass on having to maintain a 3rd party driver whenever the
> Debian kernel upgrades. The remote is missing some quite important keys
> like Play, so they seem to have only considered it for live viewing, not
> for PVRs. I'll probably end up buying a separate USB remote or
> continuing to use a portable keyboard.

I have an MCE remote, ebay has HP remote and receiver cheap enough,
they are also rc6 encoding so you can use one-for-all remote etc easy
enough, and drivers are in kernel so only a manor change to lirc to
get it working.

You don't have to use lirc but I couldn't be bothered trying to map
the keys in X.
