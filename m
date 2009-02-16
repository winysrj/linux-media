Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:2931 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253AbZBPSIL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Feb 2009 13:08:11 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: wk <handygewinnspiel@gmx.de>
Subject: Re: DVB-API v5 questions and no dvb developer answering ?
Date: Mon, 16 Feb 2009 19:08:15 +0100
Cc: linux-media@vger.kernel.org
References: <4999A6DD.7030707@gmx.de>
In-Reply-To: <4999A6DD.7030707@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902161908.15698.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 16 February 2009 18:48:13 wk wrote:
> The last week two guys were kindly asking here on the list where to find
> a written DVB-API v5 documentation,
> but nobody of the dvb driver community was answering.
>
> http://www.mail-archive.com/linux-media@vger.kernel.org/msg01350.html
> http://www.mail-archive.com/linux-media@vger.kernel.org/msg01300.html
>
> Does that mean that:
> - dvb developers are currently not interested in application developers
> integrating new DVB-API v5? or..
> - no dvb developer reading that list knows something about
> documentation? or..
> - does it simply not exist, so who is working on that api documentation
> stuff?

I do know that the main dvb devs involved in this api are very busy lately, 
but that's no excuse for not providing a document in the Documentation/dvb 
directory.

Steve, Mike, spend a few hours in a weekend to document this API!

Proper documentation should be a hard requirement before allowing new APIs 
in the kernel IMHO.

Regards,

	Hans

>
>
> The offical documentation found on linuxtv.org is outdated and already 5
> years old, and describes only api v3.
> See http://www.linuxtv.org/downloads/linux-dvb-api-1.0.0.pdf
>
> Please read also the announcements on linuxtv:
> http://www.linuxtv.org/news.php?entry=2008-09-23.mchehab
> [quote]
> Some improvements were proposed by the LinuxTV developers, in order to
> improve the S2API, including:
> ...
> * Update DVB API documentation to reflect the API changes;"
> [/quote]
>
> But also this statement is already now five months old,
> so i guess documentation should be finished meanwhile or at least
> started and usable/redistributable..
>
> Is it possible to get some information on that topic?
>
> -Winfried
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
