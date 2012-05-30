Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:65010 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575Ab2E3TvI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 May 2012 15:51:08 -0400
Received: by vbbff1 with SMTP id ff1so137984vbb.19
        for <linux-media@vger.kernel.org>; Wed, 30 May 2012 12:51:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1338407260-14367-1-git-send-email-martin.blumenstingl@googlemail.com>
References: <1338154013-5124-3-git-send-email-martin.blumenstingl@googlemail.com>
 <1338407260-14367-1-git-send-email-martin.blumenstingl@googlemail.com>
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date: Wed, 30 May 2012 21:50:46 +0200
Message-ID: <CAFBinCDfGnpFC17aMmE=pa1t9_H0p0v0GqNFnQNJLrPjTG0xuw@mail.gmail.com>
Subject: Re: [PATCH] [media] em28xx: Show a warning if the board does not
 support remote controls
To: linux-media@vger.kernel.org
Cc: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

thanks to Fabio and Ezequiel for the suggestions.
This is the latest version of my patch.

It basically shows this when connecting my stick
(of course only if I remove my other patch):
[ 1597.796028] em28xx #0: chip ID is em2884
[ 1597.849321] em28xx #0: Identified as Terratec Cinergy HTC Stick (card=82)
... (snip) ...
[ 1597.851680] em28xx #0: Remote control support is not available for this card.

Looks good, since we don't need to duplicate the card/model ID.
But we still get all required information.

Regards,
Martin
