Return-path: <linux-media-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:58493 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799Ab0CFOO6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Mar 2010 09:14:58 -0500
Message-ID: <4B926358.7080400@s5r6.in-berlin.de>
Date: Sat, 06 Mar 2010 15:14:48 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: linux-media@vger.kernel.org, Henrik Kurelid <henrik@kurelid.se>
Subject: Re: [PATCH] firedtv: add parameter to fake ca_system_ids in CA_INFO
References: <tkrat.dc97d52c76a2dc07@s5r6.in-berlin.de> <tkrat.a8cdf995cdc06e83@s5r6.in-berlin.de> <4B925E25.2070105@infradead.org> <4B92623C.2060302@s5r6.in-berlin.de>
In-Reply-To: <4B92623C.2060302@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Stefan Richter wrote:
> I already posted an updated version of the patch which correctly defines
> num_fake_ca_system_ids as an unsigned long.

err, unsigned int of course, as http://patchwork.kernel.org/patch/82912/.
-- 
Stefan Richter
-=====-==-=- --== --==-
http://arcgraph.de/sr/
