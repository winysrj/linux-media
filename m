Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53822 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752917Ab1G2Vrb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jul 2011 17:47:31 -0400
Received: by mail-wy0-f174.google.com with SMTP id 8so462522wyg.19
        for <linux-media@vger.kernel.org>; Fri, 29 Jul 2011 14:47:30 -0700 (PDT)
References: <d2fea3477b6527f29b946f6aa5842398d72c3a1e.1311918789.git.mchehab@redhat.com> <20110729025355.2fe04c6b@redhat.com>
In-Reply-To: <20110729025355.2fe04c6b@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Message-Id: <0479BBE6-47A5-4E79-A4D5-EA7FB3440B82@wilsonet.com>
Content-Transfer-Encoding: 7bit
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Jarod Wilson <jarod@wilsonet.com>
Subject: Re: [PATCH 2/2] [media] em28xx: Fix IR unregister logic
Date: Fri, 29 Jul 2011 17:40:38 -0400
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Jul 29, 2011, at 1:53 AM, Mauro Carvalho Chehab wrote:

> The input stop() callback already calls the em28xx_ir_stop method.
> Calling it again causes an oops.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

Yep, my old em28xx HVR-950 behaves much better with this and patch 1
of the pair applied.

Acked-by: Jarod Wilson <jarod@redhat.com>

-- 
Jarod Wilson
jarod@wilsonet.com



