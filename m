Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:25000 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751076Ab0JSRwN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Oct 2010 13:52:13 -0400
Date: Tue, 19 Oct 2010 13:52:11 -0400
From: Jarod Wilson <jarod@redhat.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Srinivasa.Deevi@conexant.com,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/3] cx231xx: Only register USB interface 1
Message-ID: <20101019175211.GB16942@redhat.com>
References: <cover.1287442245.git.mchehab@redhat.com>
 <20101018205259.171bd8ed@pedra>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101018205259.171bd8ed@pedra>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, Oct 18, 2010 at 08:52:59PM -0200, Mauro Carvalho Chehab wrote:
> Interface 0 is used by IR. The current driver starts initializing
> on it, finishing on interface 6. Change the logic to only handle
> interface 1. This allows another driver (mceusb) to take care of
> the IR interface.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

Looks good.

Reviewed-by: Jarod Wilson <jarod@redhat.com>

-- 
Jarod Wilson
jarod@redhat.com

