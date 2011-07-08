Return-path: <mchehab@localhost>
Received: from smtp-out.google.com ([216.239.44.51]:54031 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168Ab1GHUQz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jul 2011 16:16:55 -0400
Received: from hpaq5.eem.corp.google.com (hpaq5.eem.corp.google.com [172.25.149.5])
	by smtp-out.google.com with ESMTP id p68KGr9w017183
	for <linux-media@vger.kernel.org>; Fri, 8 Jul 2011 13:16:54 -0700
Received: from pwi16 (pwi16.prod.google.com [10.241.219.16])
	by hpaq5.eem.corp.google.com with ESMTP id p68KGoBc026985
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-media@vger.kernel.org>; Fri, 8 Jul 2011 13:16:52 -0700
Received: by pwi16 with SMTP id 16so2174751pwi.40
        for <linux-media@vger.kernel.org>; Fri, 08 Jul 2011 13:16:50 -0700 (PDT)
Date: Fri, 8 Jul 2011 13:16:49 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
To: "JAIN, AMBER" <amber@ti.com>
cc: "Hiremath, Vaibhav" <hvaibhav@ti.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: RE: [GIT PULL for v3.0] OMAP_VOUT bug fixes and code cleanup
In-Reply-To: <5A47E75E594F054BAF48C5E4FC4B92AB037BD02DC8@dbde02.ent.ti.com>
Message-ID: <alpine.DEB.2.00.1107081316220.7059@chino.kir.corp.google.com>
References: <1308771169-10741-1-git-send-email-hvaibhav@ti.com> <4E0E153F.5000303@redhat.com> <5A47E75E594F054BAF48C5E4FC4B92AB037BD02799@dbde02.ent.ti.com> <alpine.DEB.2.00.1107061342380.2622@chino.kir.corp.google.com> <19F8576C6E063C45BE387C64729E739404E3486239@dbde02.ent.ti.com>
 <5A47E75E594F054BAF48C5E4FC4B92AB037BD02DC8@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

On Thu, 7 Jul 2011, JAIN, AMBER wrote:

> I think what David wants to say is that if we do not have DMA 
> restrictions on OMAP we should have not used GFP_DMA flag for page 
> allocation at first place. Is my understanding correct David?
> 

Right, and that's what the patch is doing.
