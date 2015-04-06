Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:57149 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752654AbbDFJu0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 6 Apr 2015 05:50:26 -0400
Message-ID: <1428313821.634.116.camel@x220>
Subject: Re: [PATCH v2 1/4] break kconfig dependency loop
From: Paul Bolle <pebolle@tiscali.nl>
To: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Gerd Hoffmann <kraxel@redhat.com>, dri-devel@lists.freedesktop.org,
	virtio-dev@lists.oasis-open.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	mst@redhat.com, open list <linux-kernel@vger.kernel.org>,
	airlied@redhat.com,
	"open list:MEDIA INPUT INFRA..." <linux-media@vger.kernel.org>
Date: Mon, 06 Apr 2015 11:50:21 +0200
In-Reply-To: <87wq1wot9b.fsf@intel.com>
References: <1427894130-14228-1-git-send-email-kraxel@redhat.com>
	 <1427894130-14228-2-git-send-email-kraxel@redhat.com>
	 <87wq1wot9b.fsf@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2015-04-01 at 16:47 +0300, Jani Nikula wrote:
> I think part of the problem is that "select" is often used not as
> documented [1] but rather as "show my config in menuconfig for
> convenience even if my dependency is not met, and select the dependency
> even though I know it can screw up the dependency chain".

Perhaps people use select because it offers, given the problem they
face, a reasonable way to make the kconfig tools generate a
sensible .config. It helps them to spend less time fiddling with Kconfig
files. And they expect that it helps others to configure their build
more easily, as it might save those others some work.

> In the big picture, it feels like menuconfig needs a way to display
> items whose dependencies are not met, and a way to recursively enable
> said items and all their dependencies when told.

How could that work its way through (multiple levels of) things like:
    depends on FOO || (BAZ && BAR)

> This would reduce the
> resistance to sticking with "select" when clearly "depends" is what's
> meant.

I had drafted a rather verbose response to this. But I think I'm not
really sure what you're saying here, probably because "select" and
"depends on" are rather different. How would you know that the actual
intention was to use "depends on"?


Paul Bolle

