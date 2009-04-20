Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:58449 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753991AbZDTPGO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Apr 2009 11:06:14 -0400
Date: Mon, 20 Apr 2009 12:06:05 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Uri Shkolnik <urishk@yahoo.com>
Cc: LinuxML <linux-media@vger.kernel.org>
Subject: Re: [PATCH] [0904_6] Siano: smsdvb - new device status mechanism
Message-ID: <20090420120605.1364a365@pedra.chehab.org>
In-Reply-To: <664474.9228.qm@web110810.mail.gq1.yahoo.com>
References: <664474.9228.qm@web110810.mail.gq1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 5 Apr 2009 01:30:42 -0700 (PDT)
Uri Shkolnik <urishk@yahoo.com> wrote:

> 
> # HG changeset patch
> # User Uri Shkolnik <uris@siano-ms.com>
> # Date 1238694624 -10800
> # Node ID 4a0b207a424af7f05d8eb417a698a82a61dd086f
> # Parent  eb9fed366b2bb2b8a99760f52b9c0e40d72a71e0
> siano: smsdvb - new device status mechanism
> [PATCH] [0904_6] Siano: smsdvb - new device status mechanism
> 
> From: Uri Shkolnik <uris@siano-ms.com>
> 
> This is quite large patch, but it atomic. The patch introduces
> new , and much better way to be updated about SMS device status.
> Instead of pulling (by submitting statistics_request message),
> the driver use the information which is pushed by the device.
> Changes are: updated statistics structure (header file) and
> the implementation in the smsdvb which use this information.

Due to the requested changes on the previous patch changing the licensing
terms, this patch doesn't apply anymore.

Also, in big patches like this one, it is a good idea to split codingstyle only
changes from the real code changes, in order to speedup analysing time by the
reviewers. On my case, I use some advanced diff tools (like kdiff3) to hide
codingstyle changes for such patches, but this works only if the patch applies
cleanly.

Cheers,
Mauro
