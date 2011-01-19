Return-path: <mchehab@pedra>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:45935 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754046Ab1ASQmn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Jan 2011 11:42:43 -0500
Received: by qyj19 with SMTP id 19so832394qyj.19
        for <linux-media@vger.kernel.org>; Wed, 19 Jan 2011 08:42:42 -0800 (PST)
References: <1295205650.2400.27.camel@localhost>  <1295234982.2407.38.camel@localhost>  <848D2317-613E-42B1-950D-A227CFF15C5B@wilsonet.com> <1295439718.2093.17.camel@morgan.silverblock.net> <alpine.DEB.1.10.1101190714570.5396@ivanova.isely.net>
In-Reply-To: <alpine.DEB.1.10.1101190714570.5396@ivanova.isely.net>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Message-Id: <399CBB46-ACEB-403F-BAD5-87FD286D057B@wilsonet.com>
Content-Transfer-Encoding: 7bit
Cc: Andy Walls <awalls@md.metrocast.net>, linux-media@vger.kernel.org,
	Jarod Wilson <jarod@redhat.com>,
	Jean Delvare <khali@linux-fr.org>, Janne Grunau <j@jannau.net>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
From: Jarod Wilson <jarod@wilsonet.com>
Subject: Re: [GIT PATCHES for 2.6.38] Zilog Z8 IR unit fixes
Date: Wed, 19 Jan 2011 11:42:57 -0500
To: Mike Isely <isely@isely.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Jan 19, 2011, at 8:20 AM, Mike Isely wrote:

> This probing behavior does not happen for HVR-1950 (or HVR-1900) since 
> there's only one possible IR configuration there.

Just to be 100% clear, the device I'm poking it is definitely an
HVR-1950, using ir_scheme PVR2_IR_SCHEME_ZILOG, so the probe bits
shouldn't coming into play with anything I'm doing. Only just now
started looking at the pvrusb2 code. Wow, there's a LOT of it. ;)

-- 
Jarod Wilson
jarod@wilsonet.com



