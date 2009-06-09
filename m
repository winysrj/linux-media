Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-02.arcor-online.net ([151.189.21.42]:37529 "EHLO
	mail-in-02.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750727AbZFIBA2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Jun 2009 21:00:28 -0400
Subject: Re: RFC - Locking resources between V4L and DVB interfaces
From: hermann pitton <hermann-pitton@arcor.de>
To: Rusty Scott <rustys@ieee.org>
Cc: linux-media@vger.kernel.org
In-Reply-To: <1243367475.15846.19.camel@godzilla>
References: <1243367475.15846.19.camel@godzilla>
Content-Type: text/plain
Date: Tue, 09 Jun 2009 02:52:15 +0200
Message-Id: <1244508735.3918.29.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Rusty,

Am Dienstag, den 26.05.2009, 13:51 -0600 schrieb Rusty Scott:
> Hello all,
> I talked to Mauro offline about this issue and he indicated that it was
> an area that could use some attention.  So I have decided to take this
> issue on and am looking for comments about how this should work.
> 
> Issue: The DVB and V4L interfaces are considered different devices from
> a system standpoint.  However they often share a hardware resource, such
> as a tuner, on many cards.  There is currently no locking on the shared
> resource, so one interface could interfere with the resources already in
> use by the other.
> 
> My experience in the code tree and API are not very in depth.  I've only
> helped maintain some card specific code to this point.  I'm looking for
> comments and information on various ways to accomplish this and possible
> gotchas to watch out for.  Any pointers, suggestions or other help on
> this would be appreciated.
> 
> Thanks,
> 
> Rusty
> 

if it is only about Mauro trying to distribute some work, it is ok, but
if it should be only about some exams done soon, better forget about it.

I don't expect the latter, but it would sound very similar.

So, you start with Steven's & friends multi frontend usage on the cx88.

If you are still looking for work, the md8080 Medion Quad(ro) and some
other at least triple devices on the saa7134 driver might be interesting
concerning existing hardware based on reference designs.
(This may include limitations only resolved in later chipsets,
eventually...)

Cheers,
Hermann




