Return-path: <mchehab@localhost>
Received: from devils.ext.ti.com ([198.47.26.153]:56192 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757413Ab1GKNgh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jul 2011 09:36:37 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: David Rientjes <rientjes@google.com>, "JAIN, AMBER" <amber@ti.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 11 Jul 2011 19:05:58 +0530
Subject: RE: [GIT PULL for v3.0] OMAP_VOUT bug fixes and code cleanup
Message-ID: <19F8576C6E063C45BE387C64729E739404E35E3B8A@dbde02.ent.ti.com>
References: <1308771169-10741-1-git-send-email-hvaibhav@ti.com>
 <4E0E153F.5000303@redhat.com>
 <5A47E75E594F054BAF48C5E4FC4B92AB037BD02799@dbde02.ent.ti.com>
 <alpine.DEB.2.00.1107061342380.2622@chino.kir.corp.google.com>
 <19F8576C6E063C45BE387C64729E739404E3486239@dbde02.ent.ti.com>
 <5A47E75E594F054BAF48C5E4FC4B92AB037BD02DC8@dbde02.ent.ti.com>
 <alpine.DEB.2.00.1107081316220.7059@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1107081316220.7059@chino.kir.corp.google.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>


> -----Original Message-----
> From: David Rientjes [mailto:rientjes@google.com]
> Sent: Saturday, July 09, 2011 1:47 AM
> To: JAIN, AMBER
> Cc: Hiremath, Vaibhav; Mauro Carvalho Chehab; linux-media@vger.kernel.org;
> Andrew Morton
> Subject: RE: [GIT PULL for v3.0] OMAP_VOUT bug fixes and code cleanup
> 
> On Thu, 7 Jul 2011, JAIN, AMBER wrote:
> 
> > I think what David wants to say is that if we do not have DMA
> > restrictions on OMAP we should have not used GFP_DMA flag for page
> > allocation at first place. Is my understanding correct David?
> >
> 
> Right, and that's what the patch is doing.
[Hiremath, Vaibhav] I do not remember now how that flag got added. However, now I would say that it was a miss; or rather, it could be "copy-paste mistake".

Thanks,
Vaibhav

