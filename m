Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:33675 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756500Ab3ANSM2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Jan 2013 13:12:28 -0500
Received: by mail-qa0-f46.google.com with SMTP id r4so1672810qaq.19
        for <linux-media@vger.kernel.org>; Mon, 14 Jan 2013 10:12:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <50F447E0.4060009@gmail.com>
References: <50F447E0.4060009@gmail.com>
Date: Mon, 14 Jan 2013 13:12:27 -0500
Message-ID: <CAGoCfix5RmX04moG4WF4DDibBSkXmE4_-O6S=zdJ+bVoFv9USw@mail.gmail.com>
Subject: Re: Problem between DMB-TH USB dongle drivers and Frontend broken
 (DVBv3 migrate to DVBv5)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: "nise.design" <nise.design@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jan 14, 2013 at 1:01 PM, nise.design <nise.design@gmail.com> wrote:
> After google search I think the problem may be come from connection between
> DMB-TH drivers and dvb_frontend.c broken. I wanted to know any example code
> or instruction about DVBv3 driver connect to dvb_frontend.c.  Thank you for
> any advice.

Before suggesting that this is the cause, you should do a kenrel
bisect and identify whether it worked before the patch series in
question, but fails after it is applied.  That will tell you whether
the patch[es] are really the problem, or whether you're just
speculating.

Devin
-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
