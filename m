Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37196 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753640Ab1HFQKn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Aug 2011 12:10:43 -0400
Received: by fxh19 with SMTP id 19so3819517fxh.19
        for <linux-media@vger.kernel.org>; Sat, 06 Aug 2011 09:10:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110806160526.GA2666@achter.swolter.sdf1.org>
References: <20110806144444.GA11588@achter.swolter.sdf1.org>
	<CAGoCfiw8R_RsYdHucMqRCXPndZGO7bG=0ogw9k9vpd-xYuPtAw@mail.gmail.com>
	<20110806160526.GA2666@achter.swolter.sdf1.org>
Date: Sat, 6 Aug 2011 12:10:40 -0400
Message-ID: <CAGoCfiwEYaoUT05U5=wDr5ti8m+7WPts09QEd6yJczhYUyLDWw@mail.gmail.com>
Subject: Re: Support for Hauppauge WinTV HVR-3300
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Steve Wolter <swolter@sdf.lonestar.org>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Aug 6, 2011 at 12:05 PM, Steve Wolter <swolter@sdf.lonestar.org> wrote:
> Fair enough, thanks for the feedback, I think that project is out of my
> scope for now. I'm mainly interested in the analog demodulation at the
> moment, have the DVB capacity mainly for future use. Do you know anything
> about the analog TV decoder in there? Is this decoupled from the DVB
> stuff and could be made to work on its own?

The support for dvb is indeed decoupled from analog.  However, the
cx23888 is different enough from the cx23885 where work needs to be
done on the core driver before analog could work.  Steven Toth did a
bunch of this work in a private tree, but it hasn't been merged into
the mainline kernel yet (and given how onerous the upstream submission
process has become, it is unclear when that will actually happen).

http://kernellabs.com/hg/~stoth/cx23888-encoder/

In other words, even for analog you would need a bunch of patches in
the mainline cx23885 driver before anything would start to work.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
