Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:42658 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754158Ab2CVVLt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Mar 2012 17:11:49 -0400
Message-ID: <4F6B958C.4070406@gmx.de>
Date: Thu, 22 Mar 2012 22:11:40 +0100
From: Ninja <Ninja15@gmx.de>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Various nits, fixes and hacks for mantis CA support on
 SMP
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steinar,

thanks for the help with the driver!
I started some testing and so far the changes seem to be fine, but I 
still get freezes from time to time. I have to admit that I still need 
to test if I get the same error with other applications than mythtv.

Anyway I would like to see the changes in mainline. Maybe it would be a 
good idea to add a driver module parameter so the cam stuff (wait hack, 
ts passthrough) is only activated with the parameter set.

The problem with the IRQ0 flag is still a mystery to me, I have no idea 
in which layer the problem is, but as long as the hack causes no harm 
I'm ok with it.

Regards,
Manuel
