Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:32923 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752250AbZFXTX0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Jun 2009 15:23:26 -0400
Date: Wed, 24 Jun 2009 21:23:22 +0200
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: sub devices sharing same i2c address
Message-ID: <20090624192322.GA296@daniel.bse>
References: <A69FA2915331DC488A831521EAE36FE40139EDB7B2@dlee06.ent.ti.com> <20090623191052.GA302@daniel.bse> <A69FA2915331DC488A831521EAE36FE40139F9D8FA@dlee06.ent.ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A69FA2915331DC488A831521EAE36FE40139F9D8FA@dlee06.ent.ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jun 24, 2009 at 12:44:08PM -0500, Karicheri, Muralidharan wrote:
> Any reason why this is not added to upstream ? I think this is exactly
> what is needed to support this.

IIRC it does not work reliably with the legacy i2c binding model, so this
has to die first.

  Daniel
