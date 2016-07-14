Return-path: <linux-media-owner@vger.kernel.org>
Received: from v-smtpgw1.han.skanova.net ([81.236.60.204]:44406 "EHLO
	v-smtpgw1.han.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897AbcGNPKI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jul 2016 11:10:08 -0400
Subject: Re: uvcvideo
To: Charles Stegall <stegall@bayou.uni-linz.ac.at>,
	linux-media@vger.kernel.org
References: <20160714141624.GA5718@bayou.uni-linz.ac.at>
From: Torbjorn Jansson <torbjorn.jansson@mbox200.swipnet.se>
Message-ID: <39843503-ce01-3377-e990-39ca9a4fe850@mbox200.swipnet.se>
Date: Thu, 14 Jul 2016 17:10:04 +0200
MIME-Version: 1.0
In-Reply-To: <20160714141624.GA5718@bayou.uni-linz.ac.at>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2016-07-14 16:16, Charles Stegall wrote:
>
> this happens ...
>
> modprobe uvcvideo
> modprobe: ERROR: could not insert 'uvcvideo': Exec format error
>
did you get any interesting output in dmesg ?
like problem loading modules or symbol errors?

this sounds a bit like a problem i had where dmesg showed some symbol 
conflicts when i built drivers via media_build.
but i'm no expert on this.

