Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:43588 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750965Ab0JSRua (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Oct 2010 13:50:30 -0400
Date: Tue, 19 Oct 2010 13:50:29 -0400
From: Jarod Wilson <jarod@redhat.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Srinivasa.Deevi@conexant.com,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/3] mceusb: add support for cx231xx-based IR (e. g.
 Polaris)
Message-ID: <20101019175029.GA16942@redhat.com>
References: <cover.1287442245.git.mchehab@redhat.com>
 <20101018205257.46cf3e8c@pedra>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101018205257.46cf3e8c@pedra>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, Oct 18, 2010 at 08:52:57PM -0200, Mauro Carvalho Chehab wrote:
> For now, it adds support for Conexant EVK and for Pixelview.
> We should probably find a better way to specify all Conexant
> Polaris devices, to avoid needing to repeat this setup on
> both mceusb and cx231xx-cards.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

Looks good to me.

Reviewed-by: Jarod Wilson <jarod@redhat.com>

-- 
Jarod Wilson
jarod@redhat.com

