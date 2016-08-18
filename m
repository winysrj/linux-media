Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:34717 "EHLO vena.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755144AbcHSBV7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 Aug 2016 21:21:59 -0400
Date: Thu, 18 Aug 2016 15:30:31 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Markus Heiser <markus.heiser@darmarit.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jani Nikula <jani.nikula@intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-doc@vger.kernel.org
Subject: Re: [RFC PATCH 0/5] doc-rst: improvements Sphinx's C-domain
Message-ID: <20160818153031.73961d77@lwn.net>
In-Reply-To: <1471270108-29314-1-git-send-email-markus.heiser@darmarit.de>
References: <1471270108-29314-1-git-send-email-markus.heiser@darmarit.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 15 Aug 2016 16:08:23 +0200
Markus Heiser <markus.heiser@darmarit.de> wrote:

> this is my approach to eliminate some distortions we have with the c/cpp Sphinx
> domains. The C domain is simple: it assumes that all functions, enums, etc
> are global, e. g. there should be just one function called "ioctl", or "open".
> With the 'name' option e.g.:
> 
>     .. c:function:: int ioctl( int fd, int request )
>        :name: VIDIOC_LOG_STATUS
> 
> we can rename those functions. Another nice feature around this *global*
> namespace topic is, that the *duplicate C object description* warnings for
> function declarations are moved to the nitpicky mode.

So these all look reasonable to me.  A lot of it seems aimed at making the
media docs go better; Mauro, have you tried it out and does it, indeed,
have this effect?

Thanks,

jon
