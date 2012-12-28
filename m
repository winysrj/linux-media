Return-path: <linux-media-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:32977 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752156Ab2L1N2B (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Dec 2012 08:28:01 -0500
Date: Fri, 28 Dec 2012 14:27:56 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: LMML <linux-media@vger.kernel.org>,
	Alexey Klimov <klimov.linux@gmail.com>
Subject: Re: Fw: [patch 02/03 v2] usb hid quirks for Masterkit MA901 usb
 radio
In-Reply-To: <20121228102928.4103390e@redhat.com>
Message-ID: <alpine.LNX.2.00.1212281427120.12462@pobox.suse.cz>
References: <20121228102928.4103390e@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 28 Dec 2012, Mauro Carvalho Chehab wrote:

> Hi Jiri,
> 
> There's another radio device that it is incorrectly detected as an HID driver.
> As I'll be applying the driver's patch via the media tree, do you mind if I also
> apply this hid patch there?

Hi Mauro,

please feel free to add

	Acked-by: Jiri Kosina <jkosina@suse.cz>

and take the patch through your tree.

Thanks,

-- 
Jiri Kosina
SUSE Labs
