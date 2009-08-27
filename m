Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail8.sea5.speakeasy.net ([69.17.117.10]:47318 "EHLO
	mail8.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752644AbZH0S26 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Aug 2009 14:28:58 -0400
Date: Thu, 27 Aug 2009 11:29:00 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
cc: Peter Brouwer <pb.maillists@googlemail.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Input <linux-input@vger.kernel.org>
Subject: Re: [RFC] Infrared Keycode standardization
In-Reply-To: <829197380908271017x4247a550t44155a46c7e23c79@mail.gmail.com>
Message-ID: <Pine.LNX.4.58.0908271124470.11911@shell2.speakeasy.net>
References: <20090827045710.2d8a7010@pedra.chehab.org>  <4A96BD05.1080205@googlemail.com>
 <829197380908271017x4247a550t44155a46c7e23c79@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 27 Aug 2009, Devin Heitmueller wrote:
> The biggest challenge with that approach is that lirc is still
> maintained out-of-kernel, and the inputdev solution does not require
> lirc at all (which is good for inexperienced end users who want their
> product to "just work").

If distros started packing lirc as a basic system daemon things would
generally just work too.  After all, there is plenty of other user space
software one needs to do anything.

> The other big issue is that right now remotes get associated
> automaticallywith products as part of the device profile.  While this
> has the disadvantage that there is not a uniform mechanism to specify
> a different remote than the one that ships with the product, it does
> have the advantage of the product working "out-of-the-box" with
> whatever remote it came with.  It's a usability issue, but what I
> would consider a pretty important one.

lirc isn't limited to one remote at a time.  You can have many different
remotes supported at once.  So it's not always necessary to know which
remote you have before the remote will work.
