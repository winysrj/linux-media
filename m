Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-17.arcor-online.net ([151.189.21.57]:38504 "EHLO
	mail-in-17.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758027AbZLFDis (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 5 Dec 2009 22:38:48 -0500
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
	IR  system?
From: hermann pitton <hermann-pitton@arcor.de>
To: Jon Smirl <jonsmirl@gmail.com>
Cc: Christoph Bartelmus <lirc@bartelmus.de>, dmitry.torokhov@gmail.com,
	awalls@radix.net, j@jannau.net, jarod@redhat.com,
	jarod@wilsonet.com, khc@pm.waw.pl, kraxel@redhat.com,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, mchehab@redhat.com, superm1@ubuntu.com
In-Reply-To: <9e4733910912041628g5bedc9d2jbee3b0861aeb5511@mail.gmail.com>
References: <20091204220708.GD25669@core.coreip.homeip.net>
	 <BEJgSGGXqgB@lirc>
	 <9e4733910912041628g5bedc9d2jbee3b0861aeb5511@mail.gmail.com>
Content-Type: text/plain
Date: Sun, 06 Dec 2009 04:36:33 +0100
Message-Id: <1260070593.3236.6.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am Freitag, den 04.12.2009, 19:28 -0500 schrieb Jon Smirl:
> On Fri, Dec 4, 2009 at 6:01 PM, Christoph Bartelmus <lirc@bartelmus.de> wrote:
> > BTW, I just came across a XMP remote that seems to generate 3x64 bit scan
> > codes. Anyone here has docs on the XMP protocol?
> 
> Assuming a general purpose receiver (not one with fixed hardware
> decoding), is it important for Linux to receive IR signals from all
> possible remotes no matter how old or obscure? Or is it acceptable to
> tell the user to throw away their dedicated remote and buy a universal
> multi-function one?  Universal multi-function remotes are $12 in my
> grocery store - I don't even have to go to an electronics store.

finally we have some point here, IMHO, that is not acceptable and I told
you previously not to bet on such. Start some poll and win it, and I'll
shut up :)

To be frank, you are quite mad at this point, or deliver working other
remotes to __all__ for free.

Cheers,
Hermann




