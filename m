Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:41629 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423Ab2GWMUW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jul 2012 08:20:22 -0400
Received: by ghrr11 with SMTP id r11so5343987ghr.19
        for <linux-media@vger.kernel.org>; Mon, 23 Jul 2012 05:20:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1343029203238273500@masin.eu>
References: <1343029203238273500@masin.eu>
Date: Mon, 23 Jul 2012 08:20:21 -0400
Message-ID: <CAGoCfixPZjbdG8kKEuWoVHatJ8wO7rQjzzDK+cP8F6KM9Ta0jw@mail.gmail.com>
Subject: Re: CX25821 driver in kernel 3.4.4 problem
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: =?ISO-8859-2?Q?Radek_Ma=B9=EDn?= <radek@masin.eu>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jul 23, 2012 at 3:40 AM, Radek Mašín <radek@masin.eu> wrote:
> Hello,
> may be one more problem. I use Zoneminder software for capturing pictures from card and occasionally
> I get corrupted picture. Please take a look for attached files.

Looks like the IRQ handler wasn't servicing fast enough, causing parts
of a frame to get dropped.  Does this only happen when you have a
bunch of streams running in parallel?

This sort of performance issue would be very difficult to debug
without one of the developers having a board.  From what I understand
the code provided by Conexant was merged essentially as-is (with some
codingstyle cleanups and zero testing), with no upstream developers
actually having the hardware.

You're probably out of luck unless you're willing to pay somebody to
get a board and debug the problem.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
