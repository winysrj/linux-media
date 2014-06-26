Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:44229 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750898AbaFZUHY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Jun 2014 16:07:24 -0400
Date: Thu, 26 Jun 2014 22:07:20 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com
Subject: Re: [PATCH 00/49] rc-core: my current patch queue
Message-ID: <20140626200720.GA17722@hardeman.nu>
References: <20140403232420.27099.94872.stgit@zeus.muc.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140403232420.27099.94872.stgit@zeus.muc.hardeman.nu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Apr 04, 2014 at 01:31:15AM +0200, David Härdeman wrote:
>The following patches is what I currenly have in my queue:
>
>Patches 1 - 6 should be ok to be committed right now, they contain
>some fixes and some reverts (of the NEC32 and generic scancode
>functionality).
>
>Patches 7 - 9 are in no hurry and can wait for 3.16, some testing
>would be nice even though I believe they are ok.
>
>Patches 10 and 11 are RFC's for the NEC32 scancode handling.
>
>The remaining patches are more of an FYI. It's basically the same
>patchset that I've posted a long time ago, but respun to apply to
>the current tree. They implement a modern chardev for rc-core which
>allows the functionality that has so far only been available through
>the LIRC bridge to be exposed to userspace and provide a (hopefully)
>sane API for taking advantage of all the features that rc-core
>provides (RX, TX, ioctl) as well as some new features (multiple
>keymaps is probably the most important one). Lots and lots of cleanups
>as well.
>
>Enjoy :)

Mauro? Any progress on this? The patches seem to be rotting again and
there's not much activity to be seen in the rc-core area? I haven't seen
any better or alternative solutions and the current state of rc-core is
certainly not where it should be...

-- 
David Härdeman
