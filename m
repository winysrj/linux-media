Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gh0-f180.google.com ([209.85.160.180]:63931 "EHLO
	mail-gh0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754388Ab2E3UVM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 May 2012 16:21:12 -0400
Received: by ghbz12 with SMTP id z12so237840ghb.11
        for <linux-media@vger.kernel.org>; Wed, 30 May 2012 13:21:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFBinCDfGnpFC17aMmE=pa1t9_H0p0v0GqNFnQNJLrPjTG0xuw@mail.gmail.com>
References: <1338154013-5124-3-git-send-email-martin.blumenstingl@googlemail.com>
	<1338407260-14367-1-git-send-email-martin.blumenstingl@googlemail.com>
	<CAFBinCDfGnpFC17aMmE=pa1t9_H0p0v0GqNFnQNJLrPjTG0xuw@mail.gmail.com>
Date: Wed, 30 May 2012 17:21:10 -0300
Message-ID: <CALF0-+Wx61AGEqrexkGtJS5q5dW1jNxCjDCpkLtUS7kZpUyhnA@mail.gmail.com>
Subject: Re: [PATCH] [media] em28xx: Show a warning if the board does not
 support remote controls
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Martin,

On Wed, May 30, 2012 at 4:50 PM, Martin Blumenstingl
<martin.blumenstingl@googlemail.com> wrote:
> Hello,
>
> thanks to Fabio and Ezequiel for the suggestions.
> This is the latest version of my patch.
>
> It basically shows this when connecting my stick
> (of course only if I remove my other patch):
> [ 1597.796028] em28xx #0: chip ID is em2884
> [ 1597.849321] em28xx #0: Identified as Terratec Cinergy HTC Stick (card=82)
> ... (snip) ...
> [ 1597.851680] em28xx #0: Remote control support is not available for this card.
>
> Looks good, since we don't need to duplicate the card/model ID.
> But we still get all required information.
>

When sending new versions of a patch you should mark them as [PATCH
v2], [PATCH v3], etc in the subject.
This way maintainers can follow the patch evolution.

You can search through the mailing list for an example. Here's a random example:
http://www.spinics.net/lists/linux-media/msg47876.html

I'm not saying you should re-send this patch, it's just for you to
know for future patches.

Hope it helps,
Ezequiel.
