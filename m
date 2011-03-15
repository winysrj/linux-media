Return-path: <mchehab@pedra>
Received: from chybek.jannau.net ([83.169.20.219]:60407 "EHLO
	chybek.jannau.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756836Ab1COMS2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Mar 2011 08:18:28 -0400
Date: Tue, 15 Mar 2011 13:11:27 +0100
From: Janne Grunau <j@jannau.net>
To: Christian Ulrich <chrulri@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] DVB-APPS: azap gets -p argument
Message-ID: <20110315121126.GD8113@aniel>
References: <AANLkTimexhCMBSd7UNr1gizgbnarwS9kucZC0nWSBJxX@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimexhCMBSd7UNr1gizgbnarwS9kucZC0nWSBJxX@mail.gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

On Sat, Mar 05, 2011 at 03:16:51AM +0100, Christian Ulrich wrote:
> 
> I've written a patch against the latest version of azap in the hg
> repository during the work of my Archos Gen8 DVB-T / ATSC project.
> 
> Details of patch:
> - add -p argument from tzap to azap
> - thus ts streaming to dvr0 includes the pat/pmt

I would prefer if you simply add PAT/PMT filters to -r. I'll send a
patch which does the same for [cst]zap. The reulting files without
PAT/PMT are simply invalid. It wasn't a serious problem as long as
the used codecs were always mpeg2 video and mpeg1 layer 2 audio but
that has changed.
Since people use "[acst]zap -r" + cat/dd/... for recording we should
make the life of playback software easier by producing valid files.

patch looks good otherwise. thanks

Janne
