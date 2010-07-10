Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:56164 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316Ab0GJKe3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Jul 2010 06:34:29 -0400
Received: by wwb24 with SMTP id 24so5712249wwb.1
        for <linux-media@vger.kernel.org>; Sat, 10 Jul 2010 03:34:28 -0700 (PDT)
Message-ID: <4C384C9A.3090406@googlemail.com>
Date: Sat, 10 Jul 2010 12:34:02 +0200
From: Frank Schaefer <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Andy Walls <awalls@md.metrocast.net>
Subject: Re: Question about BTTV-video controls "whitecrush upper/lower"
References: <4C33131B.7090101@googlemail.com> <1278682566.3385.15.camel@localhost>
In-Reply-To: <1278682566.3385.15.camel@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Andy Walls schrieb:
> On Tue, 2010-07-06 at 13:27 +0200, Frank Schaefer wrote:
>   
>> Hi,
>>
>> there are two video controls in the Bttv-driver called "whitecrush
>> upper" and "whitecrush lower".
>> But what does "whitecrush" mean ? Is it the same as "white noise" ?
>> The german KDE translators are currently trying to translate these
>> strings...
>>     
>
> "White Crush" is Conexant's term for adapting to nonstandard or varying
> Sync to White level voltage differences of the incoming video signal.
> It's basically an adaptive AGC to prevent "blooming" of the video signal
> due to very high Luminance levels.
>
> The public BT878A datasheet has terse descriptions of what the registers
> settings do: they are basically upper and lower thresholds to determine
> when to adapt the automatic gain control.
>
> The public CX25840 datasheet gives a better written description of white
> crush in section 3.4.9:
>
>  http://dl.ivtvdriver.org/datasheets/video/cx25840.pdf
>
> I'm actually surprised the bttv driver has those presented as user
> controls at all.
>
> Regards,
> Andy
>   

Thank you Andy, that really helps a lot !

Regards,
Frank
