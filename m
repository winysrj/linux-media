Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:38273 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbZENMPA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 May 2009 08:15:00 -0400
Date: Thu, 14 May 2009 09:14:56 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Uri Shkolnik <urishk@yahoo.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] [0905_01_2] Siano: make single kernel object (module)
Message-ID: <20090514091456.4e5fc623@pedra.chehab.org>
In-Reply-To: <13295.91916.qm@web110809.mail.gq1.yahoo.com>
References: <13295.91916.qm@web110809.mail.gq1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 12 May 2009 07:15:54 -0700 (PDT)
Uri Shkolnik <urishk@yahoo.com> escreveu:

> 
> This patch consolidates the components to single
> kernel object (module)

As already said, you shouldn't be merging the modules. Let the user compile
only the components he needs, to allow generating smaller kernel



Cheers,
Mauro
