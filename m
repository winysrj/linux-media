Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:48524 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753465Ab0FCHDd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Jun 2010 03:03:33 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1OK4Sc-0003il-Sd
	for linux-media@vger.kernel.org; Thu, 03 Jun 2010 09:03:26 +0200
Received: from 193.160.199.2 ([193.160.199.2])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Thu, 03 Jun 2010 09:03:26 +0200
Received: from bjorn by 193.160.199.2 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Thu, 03 Jun 2010 09:03:26 +0200
To: linux-media@vger.kernel.org
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Subject: Re: [Bugme-new] [Bug 16077] New: Drop is video frame rate in kernel .34
Date: Thu, 03 Jun 2010 09:03:17 +0200
Message-ID: <87r5kod2dm.fsf@nemi.mork.no>
References: <bug-16077-10286@https.bugzilla.kernel.org/>
	<20100602140916.759d7159.akpm@linux-foundation.org>
	<4C072451.7090001@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab <mchehab@infradead.org> writes:
> Em 02-06-2010 18:09, Andrew Morton escreveu:
>> On Sun, 30 May 2010 14:29:55 GMT
>> bugzilla-daemon@bugzilla.kernel.org wrote:
>> 
>>> https://bugzilla.kernel.org/show_bug.cgi?id=16077
>> 
>> 2.6.33 -> 2.6.34 performance regression in dvb webcam frame rates.
>
> I don't think this is a regression. Probably, the new code is allowing a higher
> resolution. As the maximum bandwidth from the sensor to the USB bridge doesn't
> change, and a change from QVGA to VGA implies on 4x more pixels per frame, as
> consequence, the number of frames per second will likely reduce by a factor of 4x.
>
> I've asked the reporter to confirm what resolutions he is setting on 2.6.33
> and on 2.6.34, just to double check if my thesis is correct.

Well, the two video clips attached to the bug shows the same resolution
but a much, much lower video (and overall) bitrate in 2.6.34.  Output
from mediainfo:

General
Complete name                    : 2.6.33-02063303-generic #02063303.ogv
Format                           : OGG
File size                        : 672 KiB
Duration                         : 6s 331ms
Overall bit rate                 : 870 Kbps

Video
ID                               : 20423689 (0x137A409)
Format                           : Theora
Duration                         : 6s 333ms
Bit rate                         : 714 Kbps
Width                            : 320 pixels
Height                           : 240 pixels
Display aspect ratio             : 4:3
Frame rate                       : 30.000 fps
Bits/(Pixel*Frame)               : 0.310
Stream size                      : 552 KiB (82%)
Writing library                  : Xiph.Org libtheora 1.1 20090822 (Thusnelda)

Audio
ID                               : 1459180980 (0x56F955B4)
Format                           : Vorbis
Format settings, Floor           : 1
Duration                         : 6s 331ms
Bit rate mode                    : Constant
Bit rate                         : 112 Kbps
Channel(s)                       : 2 channels
Sampling rate                    : 44.1 KHz
Stream size                      : 86.6 KiB (13%)
Writing library                  : libVorbis 20090709 (UTC 2009-07-09)

General
Complete name                    : 2.6.34-999-generic #201005121008.ogv
Format                           : OGG
File size                        : 276 KiB
Duration                         : 15s 424ms
Overall bit rate                 : 146 Kbps

Video
ID                               : 12773534 (0xC2E89E)
Format                           : Theora
Duration                         : 15s 433ms
Bit rate                         : 19.8 Kbps
Width                            : 320 pixels
Height                           : 240 pixels
Display aspect ratio             : 4:3
Frame rate                       : 30.000 fps
Bits/(Pixel*Frame)               : 0.009
Stream size                      : 37.2 KiB (14%)
Writing library                  : Xiph.Org libtheora 1.1 20090822 (Thusnelda)

Audio
ID                               : 1010301390 (0x3C37F9CE)
Format                           : Vorbis
Format settings, Floor           : 1
Duration                         : 15s 424ms
Bit rate mode                    : Constant
Bit rate                         : 112 Kbps
Channel(s)                       : 2 channels
Sampling rate                    : 44.1 KHz
Stream size                      : 211 KiB (76%)
Writing library                  : libVorbis 20090709 (UTC 2009-07-09)


Bjørn

