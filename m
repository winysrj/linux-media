Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f42.google.com ([209.85.213.42]:60903 "EHLO
	mail-yw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753165Ab2F2Tzd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jun 2012 15:55:33 -0400
Received: by yhfq11 with SMTP id q11so4482044yhf.1
        for <linux-media@vger.kernel.org>; Fri, 29 Jun 2012 12:55:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201206291910.000512@ms2.cniteam.com>
References: <201206291649.000461@ms2.cniteam.com>
	<CAGoCfiwqJ93O5iHW96tJHFZ7uNdvKAwk==3R2YGUnwy=i-rQPg@mail.gmail.com>
	<201206291719.000478@ms2.cniteam.com>
	<CAGoCfixAUwMjGm3nUZvkhj+cY0GraxR2sqq+TUu9m+DO4SoVjQ@mail.gmail.com>
	<201206291757.000492@ms2.cniteam.com>
	<CAGoCfiwby3tn5Zh1cyEbnW-Jag6SXbCKg89SMkxMyPKD29JEfg@mail.gmail.com>
	<201206291910.000512@ms2.cniteam.com>
Date: Fri, 29 Jun 2012 15:55:32 -0400
Message-ID: <CAGoCfiyB3AGix4s3db5iNkeHUaPd1p2UVQBPYwdmA9LKxhmqgg@mail.gmail.com>
Subject: Re: AverTVHD Volar Max (h286DU)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: aschuler@bright.net
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jun 29, 2012 at 3:10 PM,  <aschuler@bright.net> wrote:
> Great info. I'm less familiar with the way that Cable is
> transmitted, but I do understand that ATSC carries multiple
> channels per frequency. Are you suggesting that I could
> capture a single stream from a single tuner which would
> contain several channels, and pull the CC data for all of
> those channels from a single stream? Would QAM work similarly?
> ( Assuming the feed is unencrypted )

Yes, QAM is very similar.  On many cable systems, while there may be
fifteen or twenty unencrypted channels, they are spread across only
three our four actual frequencies (meaning 3-4 tuners could grab
effectively all the unencrypted channels at the same time).

> I've found that most, if not all, cable boxes do not pass
> through CC data, because they are meant to interpret it and
> pass it on with customized formatting and whatnot, so another
> scaling challenge will be finding a feed that I can use
> without a cable box. OTA broadcasts have been my testing
> ground because they are so readily available.

Yeah, the fact that many cable boxes don't provide a way to expose CC
data other than their inserting the decoded text into the video is
pretty frustrating.  Bear in mind though that since you don't care
about the video then as long as the cable box has standard definition
outputs then it may very well include the CC data (HD component and
HDMI don't have a way to send CC data, but the older standard def
outputs still do).

You should definitely look at the Cablecard based devices such as the
HD HomeRun Prime, Ceton InfiniTV, or Hauppauge DCR-2650.  These
devices will allow you to get to the unencrypted streams including CC
data (assuming that the channel is marked "copy freely").

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
