Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:31269 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755635Ab1EZOv3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 May 2011 10:51:29 -0400
Message-ID: <4DDE68F6.8080901@redhat.com>
Date: Thu, 26 May 2011 10:51:34 -0400
From: Jarod Wilson <jarod@redhat.com>
MIME-Version: 1.0
To: Dan Carpenter <error27@gmail.com>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	"open list:MEDIA INPUT INFRA..." <linux-media@vger.kernel.org>,
	kernel-janitors@vger.kernel.org
Subject: Re: [patch] [media] rc/redrat3: dereferencing null pointer
References: <20110526085508.GG14591@shale.localdomain>
In-Reply-To: <20110526085508.GG14591@shale.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Dan Carpenter wrote:
> In the original code, if the allocation failed we dereference "rr3"
> when it was NULL.

D'oh, yeah, thanks for the fix.

Acked-by: Jarod Wilson <jarod@redhat.com>

-- 
Jarod Wilson
jarod@redhat.com


