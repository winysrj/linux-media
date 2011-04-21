Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47297 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754390Ab1DUVDH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Apr 2011 17:03:07 -0400
Received: by fxm17 with SMTP id 17so71660fxm.19
        for <linux-media@vger.kernel.org>; Thu, 21 Apr 2011 14:03:06 -0700 (PDT)
Date: Thu, 21 Apr 2011 23:02:54 +0200
From: Steffen Barszus <steffenbpunkt@googlemail.com>
To: Lutz Sammer <johns98@gmx.net>
Cc: linux-media@vger.kernel.org, liplianin@me.by,
	abraham.manu@gmail.com
Subject: Re: [PATCH] Fixes stb0899 not locking
Message-ID: <20110421230254.5b01c85e@grobi>
In-Reply-To: <4D99B357.50804@gmx.net>
References: <4D99B357.50804@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, 04 Apr 2011 14:02:31 +0200
Lutz Sammer <johns98@gmx.net> wrote:

> Fixes stb0899 not locking.
> See http://www.spinics.net/lists/linux-media/msg30486.html ...
> 
> When stb0899_check_data is entered, it could happen, that the data is
> already locked and the data search looped.  stb0899_check_data fails
> to lock on a good frequency.  stb0899_search_data uses an extrem big
> search step and fails to lock.
> 
> The new code checks for lock before starting a new search.
> The first read ignores the loop bit, for the case that the loop bit is
> set during the search setup.  I also added the msleep to reduce the
> traffic on the i2c bus.

Any updates on this one, or does this really need to be discussed. Its
proven now, that here is a bug, there was enough discussion before. 

Can this PLEASE get applied. 

What proofs are needed, anything wrong with it , at least ANY comment
on it ? 

I'm starting to hate that its hidden trough v4l development causing that
DVB development is dead. This sucks ...

Is there any DVB developer on this list ?  Someone who can check and
comment or approve this patch ? 

Thanks !
