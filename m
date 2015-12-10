Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:58659 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751054AbbLJKF1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Dec 2015 05:05:27 -0500
Date: Thu, 10 Dec 2015 07:57:33 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Maury Markowitz <maury.markowitz@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: dtv-scan-table has two ATSC files?
Message-ID: <20151210075733.4abdcd16@recife.lan>
In-Reply-To: <BF55C1DA-2E39-4ACA-92C0-4E512E10196F@gmail.com>
References: <201512081149525312370@gmail.com>
	<56687B09.4050004@kapsi.fi>
	<BF55C1DA-2E39-4ACA-92C0-4E512E10196F@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 9 Dec 2015 20:04:57 -0500
Maury Markowitz <maury.markowitz@gmail.com> escreveu:

> I’m making some updates to the ATSC dtv-scan-tables. Two questions:
> 
> 1)
> Why do we have "us-ATSC-center-frequencies-8VSB” *and* "us-NTSC-center-frequencies-8VSB”? They appear to be identical. The later could, theoretically, list NTSC encoded channels instead of 8VSB, but doesn’t actually do that. Suggest removing it?

Hmm... maybe we could, instead, keep one of them as a "complete" ATSC 
possible channel list, and the other ones with the unregulated channels
stripped.

> 
> 2)
> A number of the channel listings in those files have not been used for television use for several years now. Specifically channels 2 to 6 and everything from 51 and up were long ago sold off to cell phone use.
> 
> Additionally, channel 37 was *never* used, at least in the US and Canada, because it interfered with radio astronomy (IIRC it was sitting on one of the Lyman lines).

For terrestrial TV, those are unused, but perhaps the ATSC/NTSC
channeling might still be used by some cable operator.

Also, those channeling files work on other Countries outside America,
like South Korea.

> 
> Since scanning through all of these channels will no longer work, perhaps it would be time to remove them? It reduces the total scan list from 80 channels to only 45, and would greatly improve scan times.--

I rename one of the files to "us-ATSC-T-center-frequencies-8VSB" with just
the channels that are actually regulated for terrestrial (air) broadcast,
and keep the other file renamed to let is be clearer. Something like:
"us-ATSC-C-center-frequencies-8VSB" or even keeping it named as 
"us-NTSC-center-frequencies-8VSB".

Regards,
Mauro
