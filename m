Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33301 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755141Ab2BXT2a (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Feb 2012 14:28:30 -0500
Message-ID: <4F47E4B1.10405@redhat.com>
Date: Fri, 24 Feb 2012 17:27:45 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Michael Krufky <mkrufky@linuxtv.org>
CC: Mike Isely <isely@pobox.com>,
	linux-media <linux-media@vger.kernel.org>,
	Communications nexus for pvrusb2 driver <pvrusb2@isely.net>,
	stable@kernel.org
Subject: Re: pvrusb2: fix 7MHz & 8MHz DVB-T tuner support for HVR1900 rev
 D1F5
References: <CAOcJUbwqtvWy+O5guZBj7T2f61=8oe+gwqH6Fbifu1PVz+THzQ@mail.gmail.com>
In-Reply-To: <CAOcJUbwqtvWy+O5guZBj7T2f61=8oe+gwqH6Fbifu1PVz+THzQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 07-02-2012 15:08, Michael Krufky escreveu:
> There are some new revisions of the HVR-1900 around whose DVB-T
> support is broken without this small bug-fix.  Please merge asap -
> this fix needs to go to stable kernels as well.  It applies cleanly
> against *all* recent kernels.
> 
> The following changes since commit 805a6af8dba5dfdd35ec35dc52ec0122400b2610:
> 
>   Linux 3.2 (2012-01-04 15:55:44 -0800)
> 
> are available in the git repository at:
>   git://linuxtv.org/mkrufky/hauppauge surrey
> 
> Michael Krufky (1):
>       pvrusb2: fix 7MHz & 8MHz DVB-T tuner support for HVR1900 rev D1F5
> 
>  drivers/media/video/pvrusb2/pvrusb2-devattr.c |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)

> The D1F5 revision of the WinTV HVR-1900 uses a tda18271c2 tuner
> instead of a tda18271c1 tuner as used in revision D1E9. To
> account for this, we must hardcode the frontend configuration
> to use the same IF frequency configuration for both revisions
> of the device.

No, you don't need to hardcode the IF. Just use the get_if_frequency
callback at the demod, and it will work with whatever frequency you
use at the tuner.

Regards,
Mauro
