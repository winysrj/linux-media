Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31245 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751194Ab2H3T4W (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Aug 2012 15:56:22 -0400
Date: Thu, 30 Aug 2012 15:56:12 -0400
From: Jarod Wilson <jarod@redhat.com>
To: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org, mchehab@redhat.com, sean@mess.org
Subject: Re: [PATCH 0/8] rc-core: patches for 3.7
Message-ID: <20120830195612.GA13026@redhat.com>
References: <20120825214520.22603.37194.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120825214520.22603.37194.stgit@localhost.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Aug 25, 2012 at 11:46:47PM +0200, David Härdeman wrote:
> This is two minor winbond-cir fixes as well as the first six patches
> from my previous patchbomb.
> 
> The latter have been modified so that backwards compatibility is retained
> as much as possible (the format of the sysfs files do not change for
> example).

I've read through the set, and it all seems to make sense to me, but I
haven't actually tried it out with any of the hardware I've got. I assume
its been tested on various other hardware though.

Side note: my life has been turned a wee bit upside down, been busy
dealing with some fairly big changes, and that's still ongoing, thus the
relative lack of repsonsiveness on, well, anything, lately.


-- 
Jarod Wilson
jarod@redhat.com

