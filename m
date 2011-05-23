Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41979 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865Ab1EWUTu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 May 2011 16:19:50 -0400
Received: by eyx24 with SMTP id 24so1927226eyx.19
        for <linux-media@vger.kernel.org>; Mon, 23 May 2011 13:19:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4DDAC0C2.7090508@redhat.com>
References: <4DDAC0C2.7090508@redhat.com>
Date: Mon, 23 May 2011 16:19:48 -0400
Message-ID: <BANLkTinjqbU0rYnG42afw+9FywT9PBhutQ@mail.gmail.com>
Subject: Re: [ANNOUNCE] experimental alsa stream support at xawtv3
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, May 23, 2011 at 4:17 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Due to the alsa detection code that I've added at libv4l2util (at v4l2-utils)
> during the weekend, I decided to add alsa support also on xawtv3, basically
> to provide a real usecase example. Of course, for it to work, it needs the
> very latest v4l2-utils version from the git tree.
>
> I've basically added there the code that Devin wrote for tvtime, with a few
> small fixes and with the audio device auto-detection.

If any of these fixes you made apply to the code in general, I will be
happy to merge them into our tvtime tree.  Let me know.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
