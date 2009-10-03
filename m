Return-path: <linux-media-owner@vger.kernel.org>
Received: from static-72-93-233-3.bstnma.fios.verizon.net ([72.93.233.3]:43249
	"EHLO mail.wilsonet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753071AbZJCDKr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Oct 2009 23:10:47 -0400
Cc: linux-media@vger.kernel.org
Message-Id: <F3D79B4D-0A53-4563-A2DD-074035B21381@wilsonet.com>
From: Jarod Wilson <jarod@wilsonet.com>
To: Mikhail Ramendik <mr@ramendik.ru>
In-Reply-To: <b4619a970910021844o7ef75eeehad3a1b295131cc5@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v936)
Subject: Re: Skipping commercials?
Date: Fri, 2 Oct 2009 23:11:13 -0400
References: <b4619a970910021844o7ef75eeehad3a1b295131cc5@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Oct 2, 2009, at 9:44 PM, Mikhail Ramendik wrote:

> Hello,
>
> I would like to skip commercials in my dvb recordings.
>
> I know mythtv has some methods but I don't really want the hassle of
> mythtv setup and use. It is relatively early stage software

Um. If you say so. Been happily using it for over six years now...

> and
> besides, I prefer to have a normal window-based UI. I use kaffeine and
> except for absence of commercial skipping, like it.
>
> Ideally I would want a program to run on an already existing
> recording, to mark or cut out ads.
>
> A Windows program, comskip, exists. It is closed source and its
> configuration seems opaque. I will still try it under wine, but
> perhaps there is a better way?

MythTV is open-source. Look at the code specific to the mythcommflag  
binary. Adapt it for stand-alone use. It wouldn't even have to do the  
actual cutting, just output a cutlist something like gopchop, avidemux  
or similar could use to set cut points.

-- 
Jarod Wilson
jarod@wilsonet.com




