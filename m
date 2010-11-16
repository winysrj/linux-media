Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:10289 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756258Ab0KPVyS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Nov 2010 16:54:18 -0500
Date: Tue, 16 Nov 2010 16:54:08 -0500
From: Jarod Wilson <jarod@redhat.com>
To: Nicolas Kaiser <nikai@nikai.net>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/media: nuvoton: always true expression
Message-ID: <20101116215408.GA17140@redhat.com>
References: <20101116211953.238012db@absol.kitzblitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101116211953.238012db@absol.kitzblitz>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, Nov 16, 2010 at 09:19:53PM +0100, Nicolas Kaiser wrote:
> I noticed that the second part of this conditional is always true.
> Would the intention be to strictly check on both chip_major and
> chip_minor?
> 
> Signed-off-by: Nicolas Kaiser <nikai@nikai.net>

Hrm, yeah, looks like I screwed that one up. You're correct, the intention
was to make sure we have a matching chip id high and one or the other of
the chip id low values.

Acked-by: Jarod Wilson <jarod@redhat.com>

-- 
Jarod Wilson
jarod@redhat.com

