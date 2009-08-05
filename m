Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f213.google.com ([209.85.217.213]:47742 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032AbZHES6X (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Aug 2009 14:58:23 -0400
Received: by gxk9 with SMTP id 9so403647gxk.13
        for <linux-media@vger.kernel.org>; Wed, 05 Aug 2009 11:58:23 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 5 Aug 2009 14:58:23 -0400
Message-ID: <829197380908051158i52af640cn1b87bfe90c0890b8@mail.gmail.com>
Subject: RE: em28xx: fix: some webcams don't have audio inputs
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mauro,

I just noticed this patch:

em28xx: fix: some webcams don't have audio inputs
http://linuxtv.org/hg/v4l-dvb/rev/fe5eeff6644d

I have to wonder what the EM28XX_R00_CHIPCFG contained on this
particular device, since this cause should have already been handled
by the elseif() block on line 507:

} else if ((cfg & EM28XX_CHIPCFG_AUDIOMASK) == 0x00) {
    /* The device doesn't have vendor audio at all */
   dev->has_alsa_audio = 0;
   dev->audio_mode.has_audio = 0;
   return 0;
}

On a related note, is there some rationale you can offer as to why you
are committing patches directly into the v4l-dvb mainline without any
peer review, unlike *every* other developer in the linuxtv project?  I
know it may seem redundant to you since you are the person acting on
the PULL requests, but it would provide an opportunity for the other
developers to offer comments on your patches *before* they go into the
mainline.

I for one have had to fix a number of regressions you introduced into
the codebase which may have been avoided if the patches had been peer
reviewed.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
