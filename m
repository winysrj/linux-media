Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:52468 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753988Ab1ASQOx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Jan 2011 11:14:53 -0500
Received: by ewy5 with SMTP id 5so509648ewy.19
        for <linux-media@vger.kernel.org>; Wed, 19 Jan 2011 08:14:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTingFP9ajGckXXy2wScHHGxhz+KTyOBa-mE7SUs5@mail.gmail.com>
References: <20101207190753.GA21666@io.frii.com>
	<20110110021439.GA70495@io.frii.com>
	<AANLkTingFP9ajGckXXy2wScHHGxhz+KTyOBa-mE7SUs5@mail.gmail.com>
Date: Wed, 19 Jan 2011 11:13:24 -0500
Message-ID: <AANLkTi=59dytuN25H3DVRrPAB8GAcn6N88Ji_dkorsGB@mail.gmail.com>
Subject: Re: DViCO FusionHDTV7 Dual Express I2C write failed
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: VDR User <user.vdr@gmail.com>
Cc: Mark Zimmerman <markzimm@frii.com>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, Jan 19, 2011 at 10:59 AM, VDR User <user.vdr@gmail.com> wrote:
> Can someone please look into this and possibly provide a fix for the
> bug?  I'm surprised it hasn't happened yet after all this time but
> maybe it's been forgotten the bug existed.

You shouldn't be too surprised.  In many cases device support for more
obscure products comes not from the maintainer of the actual driver
but rather from some random user who hacked in an additional board
profile (in many cases, not doing it correctly but good enough so it
"works for them").  In cases like that, the changes get committed, the
original submitter disappears, and then when things break there is
nobody with the appropriate knowledge and the hardware to debug the
problem.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
