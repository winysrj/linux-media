Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:65270 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933186Ab0FQT6H (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jun 2010 15:58:07 -0400
Received: by wyb33 with SMTP id 33so74055wyb.19
        for <linux-media@vger.kernel.org>; Thu, 17 Jun 2010 12:58:05 -0700 (PDT)
Date: Thu, 17 Jun 2010 22:00:37 +0200
From: Richard Zidlicky <rz@linux-m68k.org>
To: Pedro =?iso-8859-1?Q?C=F4rte-Real?= <pedro@pedrocr.net>
Cc: linux-media@vger.kernel.org
Subject: Re: Trouble getting DVB-T working with Portuguese transmissions
Message-ID: <20100617200037.GA6530@linux-m68k.org>
References: <AANLkTiny9YXXT185VbNuw-z6aZDdIfS50UxFLERdlY-z@mail.gmail.com> <AANLkTinkDzTJfaFHx1bsGsdWlJnVGqa0n2VWdLvNBJRB@mail.gmail.com> <20100616205745.GA22103@linux-m68k.org> <AANLkTik-CVBuwVbXLlAQ1Vso4RlnAzSOzvkcIEhfR7uO@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTik-CVBuwVbXLlAQ1Vso4RlnAzSOzvkcIEhfR7uO@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jun 17, 2010 at 10:03:16AM +0100, Pedro Côrte-Real wrote:
> On Wed, Jun 16, 2010 at 9:57 PM, Richard Zidlicky <rz@linux-m68k.org> wrote:
> > On Wed, Jun 16, 2010 at 11:43:09AM +0100, Pedro Côrte-Real wrote:
> >
> >> status  C Y  | signal  66% | snr   0% | ber 2097151 | unc 0 |
> >> status SC YL | signal  65% | snr   0% | ber 2097151 | unc 0 | FE_HAS_LOCK
> >> status SC YL | signal  65% | snr   0% | ber 2097151 | unc 0 | FE_HAS_LOCK
> >> status SC YL | signal  65% | snr   0% | ber 2097151 | unc 0 | FE_HAS_LOCK
> >> status SC YL | signal  64% | snr   0% | ber 2097151 | unc 0 | FE_HAS_LOCK
> >> status SC YL | signal  65% | snr   0% | ber 2097151 | unc 0 | FE_HAS_LOCK
> >> status SC YL | signal  65% | snr   0% | ber 2097151 | unc 0 | FE_HAS_LOCK
> >> status SC YL | signal  65% | snr   0% | ber 2097151 | unc 0 | FE_HAS_LOCK
> >> status SC YL | signal  64% | snr   0% | ber 2097151 | unc 0 | FE_HAS_LOCK
> >
> > the ber is very strange. It should be 0 or very close.
> 
> What are the ber and the unc? And does the 0% snr make sense? Why the
> % scale for that?

berr is supposed to be the bit error rate. The values displayed here appear to be
bogus - then again I am not familiar with this particular driver so maybe just the 
error reporting is bogus. The w_scan results also look pretty bad.

Newest kernel is allways worth a try.

Richard
