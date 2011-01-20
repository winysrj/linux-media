Return-path: <mchehab@pedra>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:43083 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753466Ab1ATCgZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Jan 2011 21:36:25 -0500
Received: by qwa26 with SMTP id 26so104806qwa.19
        for <linux-media@vger.kernel.org>; Wed, 19 Jan 2011 18:36:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AF4B8CC5C99B457AB0516910EAC3A807@RobertWindow7>
References: <1295357999-17929-1-git-send-email-manjunath.hadli@ti.com>
	<AF4B8CC5C99B457AB0516910EAC3A807@RobertWindow7>
Date: Thu, 20 Jan 2011 10:36:25 +0800
Message-ID: <AANLkTikE_H2H-U25Z9H7WYa=_UrSL9UP5RnOSr593Tzz@mail.gmail.com>
Subject: Re: [PATCH v16 3/3] davinci vpbe: board specific additions
From: Kaspter Ju <nigh0st3018@gmail.com>
To: Robert Mellen <robert.mellen@gvimd.com>
Cc: LMML <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Robert,

On Thu, Jan 20, 2011 at 12:12 AM, Robert Mellen <robert.mellen@gvimd.com> wrote:
> Are the "davinci vpbe" patches specific only to the DM644x platform? I am
> developing on the DM365 and would like to use the OSD features implemented
> in the patches. Are there plans to port these patches to the DM365? Is it
> only a matter of changing the board-specific files, such as
> board-dm365-evm.c?

[snip]

AFAIK, these patches are DM644x platform specific, If you wanna use it
on DM365,you have to change all of this for DM365 not only the
board-specific files. Maybe this is on someone's queue.

Best Regards,
Kaspter.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Kaspter Ju
