Return-path: <linux-media-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39972 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750750AbbFKRaF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jun 2015 13:30:05 -0400
Date: Thu, 11 Jun 2015 19:30:03 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, bp@suse.de,
	tomi.valkeinen@ti.com, bhelgaas@google.com,
	linux-media@vger.kernel.org, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 0/3] linux: address broken PAT drivers
Message-ID: <20150611173003.GA23057@wotan.suse.de>
References: <1433809222-28261-1-git-send-email-mcgrof@do-not-panic.com>
 <20150608215712.3c9c0548@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150608215712.3c9c0548@recife.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jun 08, 2015 at 09:57:12PM -0300, Mauro Carvalho Chehab wrote:
> Em Mon, 08 Jun 2015 17:20:19 -0700
> "Luis R. Rodriguez" <mcgrof@do-not-panic.com> escreveu:
> 
> > From: "Luis R. Rodriguez" <mcgrof@suse.com>
> > 
> > Mauro,
> > 
> > since the ivtv patch is already acked by the driver maintainer
> > and depends on an x86 symbol that went through Boris' tree are you
> > OK in it going through Boris' tree?
> 
> Sure. I just find a minor issues there. After they got solved, feel
> free to submit to Boris with my ack.

OK thanks, I just fixed that, will send now to Boris.

  Luis
