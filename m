Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:42750 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbZH0RR5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Aug 2009 13:17:57 -0400
MIME-Version: 1.0
In-Reply-To: <4A96BD05.1080205@googlemail.com>
References: <20090827045710.2d8a7010@pedra.chehab.org>
	 <4A96BD05.1080205@googlemail.com>
Date: Thu, 27 Aug 2009 13:17:57 -0400
Message-ID: <829197380908271017x4247a550t44155a46c7e23c79@mail.gmail.com>
Subject: Re: [RFC] Infrared Keycode standardization
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Peter Brouwer <pb.maillists@googlemail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Input <linux-input@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Aug 27, 2009 at 1:06 PM, Peter
Brouwer<pb.maillists@googlemail.com> wrote:
> Mauro Carvalho Chehab wrote:
>
> Hi Mauro, All
>
> Would it be an alternative to let lirc do the mapping and just let the
> driver pass the codes of the remote to the event port.
> That way you do not need to patch the kernel for each new card/remote that
> comes out.
> Just release a different map file for lirc for the remote of choice.
>
> Peter

The biggest challenge with that approach is that lirc is still
maintained out-of-kernel, and the inputdev solution does not require
lirc at all (which is good for inexperienced end users who want their
product to "just work").

Keeping the remote definitions in-kernel also helps developers adding
support for new products, since they can be sure that both the device
and its remote will appear in the same kernel version (they are
inherently in-sync compared to cases where the distribution upgrades
the kernel but not necessarily the lircd version they bundle).

The other big issue is that right now remotes get associated
automaticallywith products as part of the device profile.  While this
has the disadvantage that there is not a uniform mechanism to specify
a different remote than the one that ships with the product, it does
have the advantage of the product working "out-of-the-box" with
whatever remote it came with.  It's a usability issue, but what I
would consider a pretty important one.

That said, if we had a way to have some sort of remote control
signature that can be associated with lirc remote control definitions,
which can be referenced in-kernel, that would solve the above
mentioned problem of making the product work by default with the
remote it shipped with.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
