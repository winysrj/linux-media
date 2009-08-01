Return-path: <linux-media-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:57019 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568AbZHANXa (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 1 Aug 2009 09:23:30 -0400
Received: from smtp08.web.de (fmsmtp08.dlan.cinetic.de [172.20.5.216])
	by fmmailgate03.web.de (Postfix) with ESMTP id 3F9F6109505A8
	for <linux-media@vger.kernel.org>; Sat,  1 Aug 2009 15:23:30 +0200 (CEST)
Received: from [217.228.207.67] (helo=[172.16.99.2])
	by smtp08.web.de with asmtp (TLSv1:AES256-SHA:256)
	(WEB.DE 4.110 #277)
	id 1MXEYc-0004ry-00
	for linux-media@vger.kernel.org; Sat, 01 Aug 2009 15:23:30 +0200
Message-ID: <4A7441CE.5000200@magic.ms>
Date: Sat, 01 Aug 2009 15:23:26 +0200
From: emagick@magic.ms
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: Patch for  stack/DMA problems in Cinergy T2 drivers (2)
References: <4A735330.1000406@magic.ms> <20090731214046.GA28139@linuxtv.org> <4A73FC6F.8000709@magic.ms>
In-Reply-To: <4A73FC6F.8000709@magic.ms>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I've found another bug in the Cinergy T2 driver: originally (ie, e.g. in
kernel 2.6.23), the structure containing "struct dvbt_set_parameters_msg param"
was allocated with kzalloc, now "struct dvbt_set_parameters_msg param" lives
on the stack. However, the "flags" member of that structure is not initialized
to zero (as was done by kzalloc)!

-emagick

