Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:22798 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755535Ab0GINgb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 9 Jul 2010 09:36:31 -0400
Subject: Re: Question about BTTV-video controls "whitecrush upper/lower"
From: Andy Walls <awalls@md.metrocast.net>
To: Frank Schaefer <fschaefer.oss@googlemail.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <4C33131B.7090101@googlemail.com>
References: <4C33131B.7090101@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 09 Jul 2010 09:36:06 -0400
Message-ID: <1278682566.3385.15.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2010-07-06 at 13:27 +0200, Frank Schaefer wrote:
> Hi,
> 
> there are two video controls in the Bttv-driver called "whitecrush
> upper" and "whitecrush lower".
> But what does "whitecrush" mean ? Is it the same as "white noise" ?
> The german KDE translators are currently trying to translate these
> strings...

"White Crush" is Conexant's term for adapting to nonstandard or varying
Sync to White level voltage differences of the incoming video signal.
It's basically an adaptive AGC to prevent "blooming" of the video signal
due to very high Luminance levels.

The public BT878A datasheet has terse descriptions of what the registers
settings do: they are basically upper and lower thresholds to determine
when to adapt the automatic gain control.

The public CX25840 datasheet gives a better written description of white
crush in section 3.4.9:

 http://dl.ivtvdriver.org/datasheets/video/cx25840.pdf

I'm actually surprised the bttv driver has those presented as user
controls at all.

Regards,
Andy

> Thanks,
> Frank


