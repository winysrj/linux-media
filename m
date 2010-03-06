Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:47763 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753272Ab0CFOrD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Mar 2010 09:47:03 -0500
Message-ID: <4B926AE3.6000809@infradead.org>
Date: Sat, 06 Mar 2010 11:46:59 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: linux-media@vger.kernel.org, Henrik Kurelid <henrik@kurelid.se>
Subject: Re: [PATCH] firedtv: add parameter to fake ca_system_ids in CA_INFO
References: <tkrat.dc97d52c76a2dc07@s5r6.in-berlin.de> <tkrat.a8cdf995cdc06e83@s5r6.in-berlin.de> <4B925E25.2070105@infradead.org> <4B92623C.2060302@s5r6.in-berlin.de> <4B926358.7080400@s5r6.in-berlin.de>
In-Reply-To: <4B926358.7080400@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Stefan Richter wrote:
> Stefan Richter wrote:
>> I already posted an updated version of the patch which correctly defines
>> num_fake_ca_system_ids as an unsigned long.
> 
> err, unsigned int of course, as http://patchwork.kernel.org/patch/82912/.

Ah, ok. This is one of the things that Patchwork doesn't handle nice: it doesn't show
any hint that a patch might be superseded by a newer one.

-- 

Cheers,
Mauro
