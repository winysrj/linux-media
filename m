Return-path: <mchehab@pedra>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:48104 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754142Ab0IHVQU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Sep 2010 17:16:20 -0400
Date: Wed, 8 Sep 2010 23:16:17 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Input <linux-input@vger.kernel.org>,
	linux-media@vger.kernel.org, Jarod Wilson <jarod@redhat.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	Jiri Kosina <jkosina@suse.cz>, Ville Syrjala <syrjala@sci.fi>
Subject: Re: [PATCH 4/6] Input: winbond-cir - switch to using new keycode
 interface
Message-ID: <20100908211617.GB13938@hardeman.nu>
References: <20100908073233.32365.74621.stgit@hammer.corenet.prv>
 <20100908074200.32365.98120.stgit@hammer.corenet.prv>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100908074200.32365.98120.stgit@hammer.corenet.prv>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Wed, Sep 08, 2010 at 12:42:00AM -0700, Dmitry Torokhov wrote:
> Switch the code to use new style of getkeycode and setkeycode
> methods to allow retrieving and setting keycodes not only by
> their scancodes but also by index.
> 
> Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
> ---
> 
>  drivers/input/misc/winbond-cir.c |  248 +++++++++++++++++++++++++-------------
>  1 files changed, 163 insertions(+), 85 deletions(-)

Thanks for doing the conversion for me, but I think you can skip this 
patch. The driver will (if I understood your patchset correctly) still 
work with the old get/setkeycode ioctls and I have a patch lined up that 
converts winbond-cir.c to use ir-core which means all of the input 
related code is removed.


-- 
David Härdeman
