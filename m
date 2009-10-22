Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:65501 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324AbZJVEQd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Oct 2009 00:16:33 -0400
Received: by fxm18 with SMTP id 18so8662199fxm.37
        for <linux-media@vger.kernel.org>; Wed, 21 Oct 2009 21:16:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <114221.71254.qm@web32706.mail.mud.yahoo.com>
References: <510991.99153.qm@web32703.mail.mud.yahoo.com>
	 <114221.71254.qm@web32706.mail.mud.yahoo.com>
Date: Thu, 22 Oct 2009 00:16:36 -0400
Message-ID: <829197380910212116k7c14069fuebecd6bf3075983@mail.gmail.com>
Subject: Re: Kworld 315U help?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Franklin Meng <fmeng2002@yahoo.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Oct 22, 2009 at 12:03 AM, Franklin Meng <fmeng2002@yahoo.com> wrote:
> Here are some more stuff in the trace that was not decoded by the parse_em28xx script..
>
> So what we know from this list of unknowns...
>
> 0xa0 is the eeprom
> 0x4a is the SAA
> 0x42 ??.
> 0xd0 ??
> 0x20 ??
> 0xc6 ??
> 0xc4 ??
> 0xc2 Thomson tuner.

c4 and c6 are probably also the tuner.  I know that K-World makes some
products with the same name but different regions.  Is your version of
the 315U an ATSC hybrid tuner?  If so, then one of those addresses is
probably the demod.

Also, the trace you sent is just an excerpt, but it's possible that
the driver is probing for devices and the requests are failing because
the hardware isn't present (the Windows driver supports a variety of
different hardware combinations).  Usually you can tell by looking for
a read from register 0x05 immediately after the i2c read.  If register
0x05 is nonzero, then the i2c read operation failed.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
