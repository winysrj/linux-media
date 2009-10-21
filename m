Return-path: <linux-media-owner@vger.kernel.org>
Received: from gv-out-0910.google.com ([216.239.58.190]:3050 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734AbZJUMzj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Oct 2009 08:55:39 -0400
Received: by gv-out-0910.google.com with SMTP id r4so715833gve.37
        for <linux-media@vger.kernel.org>; Wed, 21 Oct 2009 05:55:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <546639.71742.qm@web32702.mail.mud.yahoo.com>
References: <546639.71742.qm@web32702.mail.mud.yahoo.com>
Date: Wed, 21 Oct 2009 08:55:43 -0400
Message-ID: <829197380910210555j6d1643cdid50abf5c0fc54b53@mail.gmail.com>
Subject: Re: Kworld 315U help?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Franklin Meng <fmeng2002@yahoo.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Oct 21, 2009 at 1:35 AM, Franklin Meng <fmeng2002@yahoo.com> wrote:
> I was wondering if someone would be able to help me with getting the analog and inputs for the Kworld 315U working.  I was able to get the digital part working with help from Douglas Schilling and wanted to get the remaining portions of the device working.
>
> I have traces but have not made much progress.  In addition I also have some questions about the information that the parse_em28xx.pl skips and does not decode.
>
> For example here is some of the data that doesn't seem to be decoded..
> unknown: 40 03 00 00 a0 00 01 00 >>> 08
> unknown: c0 02 00 00 a0 00 01 00 <<< d0
> unknown: 40 03 00 00 a0 00 01 00 >>> 08
> unknown: c0 02 00 00 a0 00 01 00 <<< d0
> unknown: 40 03 00 00 a0 00 01 00 >>> 22
> unknown: c0 02 00 00 a0 00 01 00 <<< 01
> unknown: 40 03 00 00 a0 00 01 00 >>> 04
> unknown: c0 02 00 00 a0 00 02 00 <<< 1a eb
> unknown: 40 03 00 00 a0 00 01 00 >>> 20
> unknown: c0 02 00 00 a0 00 01 00 <<< 46
> unknown: 40 03 00 00 a0 00 01 00 >>> 14
> unknown: c0 02 00 00 a0 00 04 00 <<< 4e 07 01 00
>
> Anyways, any help that can be provided is appreciated.

Those look like i2c commands to the onboard eeprom, which is at i2c
address 0xa0.  For example:

unknown: 40 03 00 00 a0 00 01 00 >>> 04       // set eeprom read offset to 0x04
unknown: c0 02 00 00 a0 00 02 00 <<< 1a eb  // read two bytes back from eeprom

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
