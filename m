Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f174.google.com ([209.85.218.174]:33000 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623AbZEWIZh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 May 2009 04:25:37 -0400
MIME-Version: 1.0
In-Reply-To: <4A1719DE.4060009@unsolicited.net>
References: <4A1719DE.4060009@unsolicited.net>
Date: Sat, 23 May 2009 11:25:37 +0300
Message-ID: <84144f020905230125n32e9533dk112db9b31763e15c@mail.gmail.com>
Subject: Re: USB/DVB - Old Technotrend TT-connect S-2400 regression tracked
	down
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: David <david@unsolicited.net>
Cc: linux-media@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	dbrownell@users.sourceforge.net,
	Alan Stern <stern@rowland.harvard.edu>, leonidv11@gmail.com,
	Greg KH <gregkh@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, May 23, 2009 at 12:32 AM, David <david@unsolicited.net> wrote:
> I reported this DVB-S card breaking between 2.6.26 and 2.6.27. I've
> finally had time to do some digging, and the regression is caused by:
>
>    b963801164618e25fbdc0cd452ce49c3628b46c8 USB: ehci-hcd unlink speedups
>
> ..that was introduced in 2.6.27. Reverting this change in 2.6.29-rc5
> makes the card work happily again.

[ Note: David meant 2.6.30-rc5 here. ]

Thanks for doing the bisect!

On Sat, May 23, 2009 at 12:32 AM, David <david@unsolicited.net> wrote:
> I don't know enough about USB protocols to speculate on whether there
> may be a better fix, but hopefully someone cleverer than me can get to
> the bottom of the problem?

Lets start with cc'ing the right people. :-)

                                Pekka
