Return-path: <linux-media-owner@vger.kernel.org>
Received: from ms.lwn.net ([45.79.88.28]:48754 "EHLO ms.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933000AbdCaOq6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 31 Mar 2017 10:46:58 -0400
Date: Fri, 31 Mar 2017 08:46:55 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Markus Heiser <markus.heiser@darmarit.de>
Cc: Jani Nikula <jani.nikula@intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        John Youn <johnyoun@synopsys.com>, linux-usb@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Takashi Iwai <tiwai@suse.de>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Oliver Neukum <oneukum@suse.com>,
        Martyn Welch <martyn.welch@collabora.co.uk>,
        Alexander Dahl <post@lespocky.de>,
        Jonathan Cameron <jic23@kernel.org>
Subject: Re: [PATCH 02/22] docs-rst: convert usb docbooks to ReST
Message-ID: <20170331084655.0e7c53e5@lwn.net>
In-Reply-To: <D5D8BF1C-755B-4D56-B744-6A155C5B2313@darmarit.de>
References: <4f2a7480ba9a3c89e726869fddf17e31cf82b3c7.1490813422.git.mchehab@s-opensource.com>
        <327dcce56a725c7f91f542f2ff97995504d26526.1490813422.git.mchehab@s-opensource.com>
        <7D76BCB2-53F5-4BD4-8205-5A4852164C91@darmarit.de>
        <87y3vn2mzk.fsf@intel.com>
        <D5D8BF1C-755B-4D56-B744-6A155C5B2313@darmarit.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 30 Mar 2017 11:20:14 +0200
Markus Heiser <markus.heiser@darmarit.de> wrote:

> @Jon: what do you think about a bulk conversion?

I'm a bit leery of it, to tell the truth.  We're trying to create a
better set of kernel docs, and I'm far from convinced that dumping a
bunch of unloved stuff there in a mechanical way will get us there.

Each of those docs needs to be looked at, and, first of all, we need to
decide whether it's worth keeping or not.  Nobody wants to delete docs,
but old and unmaintained stuff doesn't help our users, IMO.  For the
stuff we want to keep, we need to look at how it fits into the new
scheme, probably split it up, etc.

It's a lot slower, but we've been getting rid of 3-6 template files in
each of the last few cycles, so we are getting there.  I don't think we
need to just give up on the rest.

Thanks,

jon
