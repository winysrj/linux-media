Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:26022 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752168Ab0JSRwg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Oct 2010 13:52:36 -0400
Date: Tue, 19 Oct 2010 13:52:35 -0400
From: Jarod Wilson <jarod@redhat.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Srinivasa.Deevi@conexant.com,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 3/3] cx231xx: Remove IR support from the driver
Message-ID: <20101019175235.GC16942@redhat.com>
References: <cover.1287442245.git.mchehab@redhat.com>
 <20101018205258.5336e5d1@pedra>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101018205258.5336e5d1@pedra>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, Oct 18, 2010 at 08:52:58PM -0200, Mauro Carvalho Chehab wrote:
> Polaris design uses MCE support. Instead of reinventing the wheel,
> just let mceusb handle the remote controller.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

Acked-by: Jarod Wilson <jarod@redhat.com>

-- 
Jarod Wilson
jarod@redhat.com

