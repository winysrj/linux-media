Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:46522 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932489AbZGPPqy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jul 2009 11:46:54 -0400
Date: Thu, 16 Jul 2009 12:46:49 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: two instances of tvp514x module required for DM6467. Any
 suggestion?
Message-ID: <20090716124649.488941bd@pedra.chehab.org>
In-Reply-To: <A69FA2915331DC488A831521EAE36FE40144F1E560@dlee06.ent.ti.com>
References: <A69FA2915331DC488A831521EAE36FE40144F1E560@dlee06.ent.ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 16 Jul 2009 10:32:17 -0500
"Karicheri, Muralidharan" <m-karicheri2@ti.com> escreveu:

> Hi,
> 
> I am working to add support for DM6467 capture driver. This evm has two tvp5147 chips with different i2c addresses. So will I be able to call v4l2_i2c_new_subdev_board() twice to have two instances of this driver running? 

Yes. If there aren't any static vars at tvp514x and you have proper locks there, this should work fine



Cheers,
Mauro
