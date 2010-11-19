Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:12529 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755232Ab0KSVkN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Nov 2010 16:40:13 -0500
Date: Fri, 19 Nov 2010 16:39:43 -0500
From: Jarod Wilson <jarod@redhat.com>
To: Nicolas Kaiser <nikai@nikai.net>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/media: nuvoton: fix chip id probe v2
Message-ID: <20101119213943.GI5022@redhat.com>
References: <20101116211953.238012db@absol.kitzblitz>
 <20101116215408.GA17140@redhat.com>
 <4CE33527.8090800@infradead.org>
 <20101117113525.1ded029c@absol.kitzblitz>
 <20101119191644.GF5022@redhat.com>
 <20101119214240.6b87dad7@absol.kitzblitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101119214240.6b87dad7@absol.kitzblitz>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Fri, Nov 19, 2010 at 09:42:40PM +0100, Nicolas Kaiser wrote:
> Make sure we have a matching chip id high and one or the other
> of the chip id low values.
> Print the values if the probe fails.
> 
> Signed-off-by: Nicolas Kaiser <nikai@nikai.net>

That works for me, thanks much.

Acked-by: Jarod Wilson <jarod@redhat.com>

-- 
Jarod Wilson
jarod@redhat.com

