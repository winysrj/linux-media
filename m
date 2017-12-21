Return-path: <linux-media-owner@vger.kernel.org>
Received: from ms.lwn.net ([45.79.88.28]:40658 "EHLO ms.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752884AbdLUVIo (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Dec 2017 16:08:44 -0500
Date: Thu, 21 Dec 2017 14:08:43 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v4 00/18] kernel-doc: add supported to document nested
 structs
Message-ID: <20171221140843.5e4bcffd@lwn.net>
In-Reply-To: <cover.1513599193.git.mchehab@s-opensource.com>
References: <cover.1513599193.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 18 Dec 2017 10:30:01 -0200
Mauro Carvalho Chehab <mchehab@s-opensource.com> wrote:

> This is a rebased version of my patch series that add support for
> nested structs on kernel-doc. With this version, it won't produce anymore
> hundreds of identical warnings, as patch 17 removes the warning
> duplication.
> 
> Excluding warnings about duplicated Note: section at hash.h, before
> this series, it reports 166 kernel-doc warnings. After this patch series,
> it reports 123 kernel-doc warnings, being 51 from DVB. I have already a patch
> series that will cleanup those new DVB warnings due to nested structs.
> 
> So, the net result is that the number of warnings is reduced with
> this version.

This seems like a great set of improvements overall, and I love getting
rid of all that old kernel-doc code.  I will note that it makes a full
htmldocs build take 20-30 seconds longer, which is not entirely
welcome, but so be it.  Someday, I guess, $SOMEBODY should see if there's
some low-hanging optimization fruit there.

Applied, thanks.

jon
