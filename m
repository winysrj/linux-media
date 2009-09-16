Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-10.arcor-online.net ([151.189.21.50]:54366 "EHLO
	mail-in-10.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755416AbZIQAAn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Sep 2009 20:00:43 -0400
Subject: Re: fix G_STD and G_PARM default handler - breaks bttv radio
From: hermann pitton <hermann-pitton@arcor.de>
To: James Blanford <jimmybgood9@yahoo.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <20090916193237.3a9ed7a3@blackbart.localnet.prv>
References: <20090916193237.3a9ed7a3@blackbart.localnet.prv>
Content-Type: text/plain
Date: Thu, 17 Sep 2009 01:50:43 +0200
Message-Id: <1253145043.3265.6.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi James,

Am Mittwoch, den 16.09.2009, 19:32 -0400 schrieb James Blanford:
> Howdy folks,
> 
> I have a Winfast 2000xp analog tuner card with a stereo radio.  It
> stopped working on the upgrade from 2.6.30 to 2.6.31.  I identified the
> above patch to v4l2-ioctl.c as the culprit.  It seems to have an
> identifier of V4L/DVB (12429).  Git commit:
> 9bedc7f7fe803c17d26b5fcf5786b50a7cf40def
> 
> I'll be happy to test patches.
> 
>    -  Jim
> 

it is a pleasure to see that at least one more guy did note it.

Hans provided a fix immediately after I came to the same result by
mercurial bisect.

http://www.spinics.net/lists/linux-media/msg10133.html

Note, only v4l1 radio apps were broken, not v4l2 ones like mplayer and kradio.

The fix should go to the kernels soon.

Cheers,
Hermann


