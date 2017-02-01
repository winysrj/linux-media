Return-path: <linux-media-owner@vger.kernel.org>
Received: from ms.lwn.net ([45.79.88.28]:36614 "EHLO ms.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751192AbdBAUKQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 1 Feb 2017 15:10:16 -0500
Date: Wed, 1 Feb 2017 13:10:15 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Markus Heiser <markus.heiser@darmarit.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        "linux-doc @ vger . kernel . org List" <linux-doc@vger.kernel.org>,
        "linux-media @ vger . kernel . org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH] doc-rst: fixed cleandoc target when used with O=dir
Message-ID: <20170201131015.202327c9@lwn.net>
In-Reply-To: <1485856661-23095-1-git-send-email-markus.heiser@darmarit.de>
References: <1485856661-23095-1-git-send-email-markus.heiser@darmarit.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 31 Jan 2017 10:57:41 +0100
Markus Heiser <markus.heiser@darmarit.de> wrote:

> The cleandocs target won't work if I use a different output folder::
> 
>   $ make O=/tmp/kernel SPHINXDIRS="process" cleandocs
>   make[1]: Entering directory '/tmp/kernel'
>   make[3]: *** No rule to make target 'clean'.  Stop.
>   ... Documentation/Makefile.sphinx:100: recipe for target 'cleandocs' failed

Applied, thanks.

jon
