Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57284 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759579Ab0FPUzY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Jun 2010 16:55:24 -0400
Received: by wyb40 with SMTP id 40so6085211wyb.19
        for <linux-media@vger.kernel.org>; Wed, 16 Jun 2010 13:55:22 -0700 (PDT)
Date: Wed, 16 Jun 2010 22:57:45 +0200
From: Richard Zidlicky <rz@linux-m68k.org>
To: Pedro =?iso-8859-1?Q?C=F4rte-Real?= <pedro@pedrocr.net>
Cc: linux-media@vger.kernel.org
Subject: Re: Trouble getting DVB-T working with Portuguese transmissions
Message-ID: <20100616205745.GA22103@linux-m68k.org>
References: <AANLkTiny9YXXT185VbNuw-z6aZDdIfS50UxFLERdlY-z@mail.gmail.com> <AANLkTinkDzTJfaFHx1bsGsdWlJnVGqa0n2VWdLvNBJRB@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTinkDzTJfaFHx1bsGsdWlJnVGqa0n2VWdLvNBJRB@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jun 16, 2010 at 11:43:09AM +0100, Pedro Côrte-Real wrote:

> status  C Y  | signal  66% | snr   0% | ber 2097151 | unc 0 |
> status SC YL | signal  65% | snr   0% | ber 2097151 | unc 0 | FE_HAS_LOCK
> status SC YL | signal  65% | snr   0% | ber 2097151 | unc 0 | FE_HAS_LOCK
> status SC YL | signal  65% | snr   0% | ber 2097151 | unc 0 | FE_HAS_LOCK
> status SC YL | signal  64% | snr   0% | ber 2097151 | unc 0 | FE_HAS_LOCK
> status SC YL | signal  65% | snr   0% | ber 2097151 | unc 0 | FE_HAS_LOCK
> status SC YL | signal  65% | snr   0% | ber 2097151 | unc 0 | FE_HAS_LOCK
> status SC YL | signal  65% | snr   0% | ber 2097151 | unc 0 | FE_HAS_LOCK
> status SC YL | signal  64% | snr   0% | ber 2097151 | unc 0 | FE_HAS_LOCK

the ber is very strange. It should be 0 or very close. 

Did you try kaffeine or w_scan?

Richard
