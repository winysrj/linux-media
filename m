Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f47.google.com ([209.85.215.47]:40419 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176Ab3KXSOs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Nov 2013 13:14:48 -0500
Received: by mail-la0-f47.google.com with SMTP id ep20so2280455lab.6
        for <linux-media@vger.kernel.org>; Sun, 24 Nov 2013 10:14:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAA9z4Lbro=UjZjcjK1e51ikVG7Q2XU9Ei1XWPELCq47iGowkWg@mail.gmail.com>
References: <20130603171607.73d0b856@endymion.delvare>
	<20130603172150.1aaf1904@endymion.delvare>
	<CAHFNz9LX0WzmO1zvn51Ge8VQkfiPrao3AQVLprhqrp1V-0h=fQ@mail.gmail.com>
	<CAA9z4Lbro=UjZjcjK1e51ikVG7Q2XU9Ei1XWPELCq47iGowkWg@mail.gmail.com>
Date: Sun, 24 Nov 2013 23:44:46 +0530
Message-ID: <CAHFNz9L2VcZcc5bw3L4ABH98q82KGTEp__2=O2zXu-yLDQ184A@mail.gmail.com>
Subject: Re: [PATCH 2/3] femon: Display SNR in dB
From: Manu Abraham <abraham.manu@gmail.com>
To: Chris Lee <updatelee@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Nov 24, 2013 at 11:32 PM, Chris Lee <updatelee@gmail.com> wrote:
> This is a frustration of mine. Some report it in SNR others report it
> in terms of % (current snr / (max_snr-min_snr)) others its completely
> random.
>
> Seems many dvb-s report arbitrary % which is stupid and many atsc
> report snr by 123 would be 12.3db. But there isnt any standardization
> around.
>
> imo everything should be reported in terms of db, why % was ever
> chosen is beyond logic.


Because dB terminology did not fit all frontends. For some it does
fit, but again not all. Some frontends by default don't have a dB
specification; some reverse engineered ones unable to.
