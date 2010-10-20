Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.10]:53223 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393Ab0JTNpv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Oct 2010 09:45:51 -0400
From: "Hans-Peter Jansen" <hpj@urpla.net>
To: Stefan Seyfried <stefan.seyfried@googlemail.com>
Subject: Re: [opensuse-kernel] Unloading cx8802 results in crash of ir_core:ir_unregister_class
Date: Wed, 20 Oct 2010 15:45:28 +0200
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org, opensuse-kernel@opensuse.org
References: <201010201231.24173.hpj@urpla.net> <20101020142620.181ea010@susi.home.s3e.de>
In-Reply-To: <20101020142620.181ea010@susi.home.s3e.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201010201545.28696.hpj@urpla.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wednesday 20 October 2010, 14:26:20 Stefan Seyfried wrote:
> On Wed, 20 Oct 2010 12:31:23 +0200
>
> "Hans-Peter Jansen" <hpj@urpla.net> wrote:
> > Welcome to openSUSE 11.1 - Kernel 2.6.34.7-4-pae (ttyS0)
> >
> > Any ideas, what's going wrong here?
>
> Your kernel is ancient. Please try reproducing with a recent kernel
> from the Kernel:HEAD repo. If it still happens, let's debug it. If it
> doesn't, create a bugreport against the SUSE kernel and hope that
> they backport the fix.

Stefan is right, .36-rc8 doesn't suffer from this anymore. If somebody 
could point me to a patch, that might have fixed it, I would happily 
test it.

Now to get the usual suspects work with this kernel: aufs2, vmware, 
nvidia. Ohh, well.

Thanks,
Pete
