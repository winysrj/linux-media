Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:56945 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754502Ab0BVEHJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Feb 2010 23:07:09 -0500
Received: by bwz1 with SMTP id 1so1347657bwz.21
        for <linux-media@vger.kernel.org>; Sun, 21 Feb 2010 20:07:08 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 21 Feb 2010 23:07:07 -0500
Message-ID: <829197381002212007q342fc01bm1c528a2f15027a1e@mail.gmail.com>
Subject: Chroma gain configuration
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I am doing some work on the saa711x driver, and ran into a case where
I need to disable the chroma AGC and manually set the chroma gain.

I see there is an existing boolean control called V4L2_CID_CHROMA_AGC,
which would be the logical candidate for allowing the user to disable
the chroma AGC.  However, once this is done I still need to expose the
ability to set the gain manually (bits 6-0 of register 0x0f).

Is there some existing control I am just missing?  Or do I need to do
this through a private control.

I'm asking because it seems a bit strange that someone would introduce
a v4l2 standard control to disable the AGC but not have the ability to
manually set the gain once it was disabled.

Suggestions welcome.  I obviously would only want to introduce a
private control if absolutely necessary.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
