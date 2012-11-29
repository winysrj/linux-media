Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp205.alice.it ([82.57.200.101]:58725 "EHLO smtp205.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753766Ab2K2WPK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Nov 2012 17:15:10 -0500
Date: Thu, 29 Nov 2012 23:14:56 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Jean-Francois Moine <moinejf@free.fr>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] gspca - ov534: Fix the light frequency filter
Message-Id: <20121129231456.569fd4b4ebf1eca3840b076b@studenti.unina.it>
In-Reply-To: <50B729FF.6020402@redhat.com>
References: <20121122124652.3a832e33@armhf>
	<20121123180909.021c55a8c3795329836c42b7@studenti.unina.it>
	<20121123191232.7ed9c546@armhf>
	<50B729FF.6020402@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 29 Nov 2012 10:25:19 +0100
Hans de Goede <hdegoede@redhat.com> wrote:

> Hi Jean-Francois, Antonio Ospite,
> 
> Could it be that you're both right, and that the register
> Jean-Francois suggest is used (0x13) and uses in his patch
> is for enabling / disabling the light-freq filter, where
> as the register which were used before this patch
> (0x2a, 0x2b) are used to select the light frequency to
> filter for?
>

I too thought about something along this line after looking in the
"OV7670 Implementation Guide": there is a relationship between the
banding filter and the maximum exposure, and the latter is somewhat
related to dummy lines/pixels. So this would make sense.

> That would explain everything the 2 50 / 60 hz testers are
> seeing. This assumes that reg 0x13 has the filter always
> enabled before the patch, and the code before the patch
> simply changes the filter freq to such a value it
> effectively disables the filter for 50 Hz. This also
> assumes that the default values in 0x2a and 0x2b are
> valid for 60hz, which explains why Jean Francois' patch
> works for 60 Hz, so with all this combined we should
> have all pieces of the puzzle ...
> 
> Anyone wants to do a patch to prove I'm right (or wrong :)
> ?

I contacted Fabian Alexander Calderon off-list using the email address
in the tested-by line in the patch sent by Jean-Francois, I am waiting
for a reply from him.

I can cook something which uses register 0x13 and still makes the
filter apply on 50Hz, but I'll test for an actual test before
submitting it.

Thanks,
   Antonio

-- 
Antonio Ospite
http://ao2.it

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
