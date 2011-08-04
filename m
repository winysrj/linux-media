Return-path: <linux-media-owner@vger.kernel.org>
Received: from ist.d-labs.de ([213.239.218.44]:45248 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753415Ab1HDKVh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 4 Aug 2011 06:21:37 -0400
Date: Thu, 4 Aug 2011 12:21:29 +0200
From: Florian Mickler <florian@mickler.org>
To: Patrick Boettcher <pboettcher@kernellabs.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Dan Carpenter <error27@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: vp702x
Message-ID: <20110804122129.45a8b37f@schatten.dmk.lab>
In-Reply-To: <alpine.LRH.2.00.1108030937250.5518@pub4.ifh.de>
References: <20110802173942.6f951c95@schatten.dmk.lab>
	<alpine.LRH.2.00.1108030937250.5518@pub4.ifh.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Wed, 3 Aug 2011 09:39:46 +0200 (CEST)
Patrick Boettcher <pboettcher@kernellabs.com> wrote:

> Hi Florian,
> 
> 
> I'm not sure whether I still have exactly this box. There were two 
> versions and I got rid of at least one of them.
> 
> I moved recently into a new house and right now a lot of things are hidden 
> in some boxes somewhere... I'll try to find some time to check it. Don't 
> ask me when that will be :).
> 

ok, thanks for the heads up nonetheless. 

Mauro, what to do? Currently it will bug on
driver probe like the vp7045 (which Tino confirmed works now again
with my recent patch).

Before the patchseries it would use on-stack dma buffers (don't know
about the actual harm of these, at least a WARN from libdma, but
rumours are that they may format your disk if the moon aligns with
the sun and a special unspecified planet). 

Regards,
Flo


> regards,
> --
> 
> Patrick Boettcher - Kernel Labs
> http://www.kernellabs.com/
