Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56284 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752252AbbDAPiY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 1 Apr 2015 11:38:24 -0400
Message-ID: <1427902693.6445.29.camel@nilsson.home.kraxel.org>
Subject: Re: [PATCH v2 1/4] break kconfig dependency loop
From: Gerd Hoffmann <kraxel@redhat.com>
To: John Hunter <zhjwpku@gmail.com>
Cc: "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	virtio-dev@lists.oasis-open.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	mst@redhat.com, open list <linux-kernel@vger.kernel.org>,
	airlied@redhat.com,
	"open list:MEDIA INPUT INFRA..." <linux-media@vger.kernel.org>
Date: Wed, 01 Apr 2015 17:38:13 +0200
In-Reply-To: <CAEG8a3+Wp-jgtwKmcBhG2gVAOP2tQ5MHuJwYe-m2HwYQRB06HQ@mail.gmail.com>
References: <1427894130-14228-1-git-send-email-kraxel@redhat.com>
	 <1427894130-14228-2-git-send-email-kraxel@redhat.com>
	 <CAEG8a3+Wp-jgtwKmcBhG2gVAOP2tQ5MHuJwYe-m2HwYQRB06HQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mi, 2015-04-01 at 22:55 +0800, John Hunter wrote:
> Hi Gerd,
> I've read the patches about the virtio-gpu, it's a nice design.
> As far as I know, there are two other drivers used by qemu, CIRRUS and
> BOCHS.
> I have a question about the relationship of these three drivers, is
> that the virtio-gpu
> designed to replace the other two drivers? I mean are the CIRRUS and
> BOCHS
> going to be deprecated in the future?

qemu has a bunch of different virtual graphics cards, and these are the
drivers for them.  cirrus used to be the default gfx card until recently
(qemu older then version 2.2).  stdvga (bochs driver) is the current
default.  So expect them to be around for a while.

virtio-gpu will not replace them.

> Actually, this is a problem by Martin Peres who is the GSoC xorg
> administor. 
> My proposal is "Convert the BOCHS and CIRRUS drivers to atomic
> mode-setting".

Surely makes sense for bochs and you shouldn't find major blockers.
Not sure this is a reasonable task size for gsoc given it took me only a
few days to convert virtio-gpu to atomic modesetting.  But maybe fine if
you are new to drm kernel hacking and therefore the task includes
learning alot new stuff.

I have my doubts it'll work out for cirrus though, due to the small
amount of video memory it has (and other limitations, because we mimic
hardware from the 90ies here).  Current code is already swapping
framebuffers in and out of video ram because of that.  So atomic
modesetting, page flip, running wayland on that beast all is going to be
problematic I expect.

See also:
https://www.kraxel.org/blog/2014/10/qemu-using-cirrus-considered-harmful/

HTH,
  Gerd



