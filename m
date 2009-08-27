Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:46857 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbZH0SeL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Aug 2009 14:34:11 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.58.0908271124470.11911@shell2.speakeasy.net>
References: <20090827045710.2d8a7010@pedra.chehab.org>
	 <4A96BD05.1080205@googlemail.com>
	 <829197380908271017x4247a550t44155a46c7e23c79@mail.gmail.com>
	 <Pine.LNX.4.58.0908271124470.11911@shell2.speakeasy.net>
Date: Thu, 27 Aug 2009 14:34:11 -0400
Message-ID: <829197380908271134q26b2d44eg2e8c87a844d2b0b5@mail.gmail.com>
Subject: Re: [RFC] Infrared Keycode standardization
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Trent Piepho <xyzzy@speakeasy.org>
Cc: Peter Brouwer <pb.maillists@googlemail.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Input <linux-input@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Aug 27, 2009 at 2:29 PM, Trent Piepho<xyzzy@speakeasy.org> wrote:
> On Thu, 27 Aug 2009, Devin Heitmueller wrote:
>> The biggest challenge with that approach is that lirc is still
>> maintained out-of-kernel, and the inputdev solution does not require
>> lirc at all (which is good for inexperienced end users who want their
>> product to "just work").
>
> If distros started packing lirc as a basic system daemon things would
> generally just work too.  After all, there is plenty of other user space
> software one needs to do anything.

Sure, and when that day comes my opinion will change.  In the
meantime, users will see a regression (their remotes will stop working
whereas they worked before the upgrade).

>> The other big issue is that right now remotes get associated
>> automaticallywith products as part of the device profile.  While this
>> has the disadvantage that there is not a uniform mechanism to specify
>> a different remote than the one that ships with the product, it does
>> have the advantage of the product working "out-of-the-box" with
>> whatever remote it came with.  It's a usability issue, but what I
>> would consider a pretty important one.
>
> lirc isn't limited to one remote at a time.  You can have many different
> remotes supported at once.  So it's not always necessary to know which
> remote you have before the remote will work.

I recognize that lirc can support multiple remotes.  However, at a
minimum the lirc receiver should work out of the box with the remote
the product comes with.  And that means there needs to be some way in
the driver to associate the tuner with some remote control profile
that has its layout defined in lirc.  Sure, if the user wants to then
say "I want to use this different remote instead..." then that should
be supported as well if the user does the appropriate configuration.

While I can appreciate the desire to support all sorts of advanced
configurations, this shouldn't be at the cost of the simple
configurations not working out-of-the-box.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
