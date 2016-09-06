Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:57455 "EHLO vena.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754196AbcIFM2u (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Sep 2016 08:28:50 -0400
Date: Tue, 6 Sep 2016 06:28:44 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Markus Heiser <markus.heiser@darmarit.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jani Nikula <jani.nikula@intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH 3/3] doc-rst:c-domain: function-like macros index entry
Message-ID: <20160906062844.767e0d33@lwn.net>
In-Reply-To: <1472657372-21039-4-git-send-email-markus.heiser@darmarit.de>
References: <1472657372-21039-1-git-send-email-markus.heiser@darmarit.de>
        <1472657372-21039-4-git-send-email-markus.heiser@darmarit.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 31 Aug 2016 17:29:32 +0200
Markus Heiser <markus.heiser@darmarit.de> wrote:

> For function-like macros, sphinx creates 'FOO (C function)' entries.
> With this patch 'FOO (C macro)' are created for function-like macros,
> which is the same for object-like macros.

As others have pointed out, we generally want to hide the difference
between functions and macros, so this is probably one change we don't
want.

Thanks,

jon
