Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47620 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751595AbbFCRP4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Jun 2015 13:15:56 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <556F2EB4.6030108@iki.fi>
References: <556F2EB4.6030108@iki.fi> <556F1A02.9020203@gmail.com> <55677568.4070603@gmail.com> <5564C269.2000003@gmail.com> <20150526150400.10241.25444.stgit@warthog.procyon.org.uk> <20150526150407.10241.89123.stgit@warthog.procyon.org.uk> <360.1432807690@warthog.procyon.org.uk> <23160.1433326669@warthog.procyon.org.uk> <31746.1433349441@warthog.procyon.org.uk>
To: Antti Palosaari <crope@iki.fi>
Cc: dhowells@redhat.com, Malcolm Priestley <tvboxspy@gmail.com>,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 2/2] ts2020: Provide DVBv5 API signal strength
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <388.1433351750.1@warthog.procyon.org.uk>
Date: Wed, 03 Jun 2015 18:15:50 +0100
Message-ID: <389.1433351750@warthog.procyon.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Antti Palosaari <crope@iki.fi> wrote:

> Malcolm misses some pending patches where attach() is wrapped to I2C model
> probe().
> http://git.linuxtv.org/cgit.cgi/anttip/media_tree.git/log/?h=ts2020

Aha!  That explains it.

	ts2020: register I2C driver from legacy media attach

removes the allocation from attach() in the branch I'm working on top of.

David
