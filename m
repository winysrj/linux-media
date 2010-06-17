Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:64036 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759467Ab0FQJDQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jun 2010 05:03:16 -0400
Received: by pwi1 with SMTP id 1so4169266pwi.19
        for <linux-media@vger.kernel.org>; Thu, 17 Jun 2010 02:03:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100616205745.GA22103@linux-m68k.org>
References: <AANLkTiny9YXXT185VbNuw-z6aZDdIfS50UxFLERdlY-z@mail.gmail.com>
	<AANLkTinkDzTJfaFHx1bsGsdWlJnVGqa0n2VWdLvNBJRB@mail.gmail.com>
	<20100616205745.GA22103@linux-m68k.org>
Date: Thu, 17 Jun 2010 10:03:16 +0100
Message-ID: <AANLkTik-CVBuwVbXLlAQ1Vso4RlnAzSOzvkcIEhfR7uO@mail.gmail.com>
Subject: Re: Trouble getting DVB-T working with Portuguese transmissions
From: =?UTF-8?Q?Pedro_C=C3=B4rte=2DReal?= <pedro@pedrocr.net>
To: Richard Zidlicky <rz@linux-m68k.org>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jun 16, 2010 at 9:57 PM, Richard Zidlicky <rz@linux-m68k.org> wrote:
> On Wed, Jun 16, 2010 at 11:43:09AM +0100, Pedro Côrte-Real wrote:
>
>> status  C Y  | signal  66% | snr   0% | ber 2097151 | unc 0 |
>> status SC YL | signal  65% | snr   0% | ber 2097151 | unc 0 | FE_HAS_LOCK
>> status SC YL | signal  65% | snr   0% | ber 2097151 | unc 0 | FE_HAS_LOCK
>> status SC YL | signal  65% | snr   0% | ber 2097151 | unc 0 | FE_HAS_LOCK
>> status SC YL | signal  64% | snr   0% | ber 2097151 | unc 0 | FE_HAS_LOCK
>> status SC YL | signal  65% | snr   0% | ber 2097151 | unc 0 | FE_HAS_LOCK
>> status SC YL | signal  65% | snr   0% | ber 2097151 | unc 0 | FE_HAS_LOCK
>> status SC YL | signal  65% | snr   0% | ber 2097151 | unc 0 | FE_HAS_LOCK
>> status SC YL | signal  64% | snr   0% | ber 2097151 | unc 0 | FE_HAS_LOCK
>
> the ber is very strange. It should be 0 or very close.

What are the ber and the unc? And does the 0% snr make sense? Why the
% scale for that?

> Did you try kaffeine or w_scan?

I did try both of those. kaffeine I haven't been able to get to work
at all and w_scan found the frequency but not the channels, much like
scan. I'll try those again.

There was something that happened for only a brief moment that allowed
the scan to work but after a reboot it went back to the same. What
could be missing from the frontend/demux config?

Pedro
