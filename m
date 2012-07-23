Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.masin.eu ([80.188.199.19]:33795 "EHLO mail.masin.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752463Ab2GWNg6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jul 2012 09:36:58 -0400
From: =?utf-8?Q?Radek_Ma=C5=A1=C3=ADn?= <radek@masin.eu>
Date: Mon, 23 Jul 2012 15:36:55 +0200
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: linux-media@vger.kernel.org
Message-ID: <1343050615472267500@masin.eu>
In-Reply-To: <CAGoCfixPZjbdG8kKEuWoVHatJ8wO7rQjzzDK+cP8F6KM9Ta0jw@mail.gmail.com>
References: <1343029203238273500@masin.eu>
 <CAGoCfixPZjbdG8kKEuWoVHatJ8wO7rQjzzDK+cP8F6KM9Ta0jw@mail.gmail.com>
Subject: Re: CX25821 driver in kernel 3.4.4 problem
MIME-Version: 1.0
Content-Type: text/plain;	charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

   Hello,
thank you for answer. Problems occurs on all channels and don't
depend on number of channels used. I have tried to run only one
channel, but it didn't help. 

I bought this card from dx.com for 65$. 

May be, I'll be able to provide access to my testing system with 
this card, if it is enought.

Regards
Radek Masin

Dne Po, 07/23/2012 02:20 odp., Devin Heitmueller <dheitmueller@kernellabs.com> napsal(a):
> On Mon, Jul 23, 2012 at 3:40 AM, Radek Mašín <radek@masin.eu> wrote:
> > Hello,
> > may be one more problem. I use Zoneminder software for capturing pictures from card and occasionally
> > I get corrupted picture. Please take a look for attached files.
> 
> Looks like the IRQ handler wasn't servicing fast enough, causing parts
> of a frame to get dropped.  Does this only happen when you have a
> bunch of streams running in parallel?
> 
> This sort of performance issue would be very difficult to debug
> without one of the developers having a board.  From what I understand
> the code provided by Conexant was merged essentially as-is (with some
> codingstyle cleanups and zero testing), with no upstream developers
> actually having the hardware.
> 
> You're probably out of luck unless you're willing to pay somebody to
> get a board and debug the problem.
> 
> Devin
> 
> --
> Devin J. Heitmueller - Kernel Labs
> http://www.kernellabs.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
