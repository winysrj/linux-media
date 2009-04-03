Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:45299 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754755AbZDCLyN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Apr 2009 07:54:13 -0400
Date: Fri, 3 Apr 2009 08:54:03 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Uri Shkolnik <urishk@yahoo.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] siano: smsdvb - add support for old dvb-core version
Message-ID: <20090403085403.29c50b7a@pedra.chehab.org>
In-Reply-To: <216221.27575.qm@web110810.mail.gq1.yahoo.com>
References: <216221.27575.qm@web110810.mail.gq1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Uri,

I didn't started yet to analyse your patch series, but the subject of this
message called my attention.

Backport patches is something that should never go upstream.

On Fri, 3 Apr 2009 04:36:09 -0700 (PDT)
Uri Shkolnik <urishk@yahoo.com> wrote:

> # HG changeset patch
> # User Uri Shkolnik <uris@siano-ms.com>
> # Date 1238758726 -10800
> # Node ID c582116cfbb96671629143fced33e3f88c28b3c7
> # Parent  856813745905e07d9fc6be5e136fdf7060c6fc37
> siano: smsdvb - add support for old dvb-core version
> 
> From: Uri Shkolnik <uris@siano-ms.com>
> 
> Multiple user takes the new driver sources from the LinuxTV
> repository, but neglect to upgrade the dvb-core (this is
> true especially for tiny and embedded device). This patch
> enables the smsdvb to work with older version of dvb-core.
> 
> This patch also add one more handling of message endianity.

Never mix two different issues on the same patch.

In this specific case, since the backport patch will be removed from upstream
submission, the message endian changes should be on a separate patch, in order
to get its way upstream.

Cheers,
Mauro
