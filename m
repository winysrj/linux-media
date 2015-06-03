Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42932 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751748AbbFCKRx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Jun 2015 06:17:53 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <55677568.4070603@gmail.com>
References: <55677568.4070603@gmail.com> <5564C269.2000003@gmail.com> <20150526150400.10241.25444.stgit@warthog.procyon.org.uk> <20150526150407.10241.89123.stgit@warthog.procyon.org.uk> <360.1432807690@warthog.procyon.org.uk>
To: Malcolm Priestley <tvboxspy@gmail.com>
Cc: dhowells@redhat.com, crope@iki.fi, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 2/2] ts2020: Provide DVBv5 API signal strength
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <23159.1433326669.1@warthog.procyon.org.uk>
Date: Wed, 03 Jun 2015 11:17:49 +0100
Message-ID: <23160.1433326669@warthog.procyon.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Malcolm Priestley <tvboxspy@gmail.com> wrote:

> Yes, also, the workqueue appears not to be initialized when using the dvb
> attached method.

I'm not sure what you're referring to.  It's initialised in ts2020_probe()
just after the ts2020_priv struct is allocated - the only place it is
allocated.

David
