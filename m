Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:57712 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755320Ab0JNU7X (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Oct 2010 16:59:23 -0400
Date: Thu, 14 Oct 2010 16:59:21 -0400
From: Jarod Wilson <jarod@redhat.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [PATCH] V4L/DVB: ir: properly handle an error at input_register
Message-ID: <20101014205921.GB2178@redhat.com>
References: <4CB76E0E.7000704@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CB76E0E.7000704@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, Oct 14, 2010 at 05:54:38PM -0300, Mauro Carvalho Chehab wrote:
> Be sure to rollback all init if input register fails.
> 
> Cc: Maxim Levitsky <maximlevitsky@gmail.com>
> Cc: Jarod Wilson <jarod@redhat.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

Good catch. /me kicks self for missing that one.

Acked-by: Jarod Wilson <jarod@redhat.com>


-- 
Jarod Wilson
jarod@redhat.com

