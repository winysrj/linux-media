Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([94.23.35.102]:39704 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763179Ab3ECLNC (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 May 2013 07:13:02 -0400
Date: Fri, 3 May 2013 08:12:41 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Jon Arne =?utf-8?Q?J=C3=B8rgensen?= <jonarne@jonarne.no>
Cc: Timo Teras <timo.teras@iki.fi>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: Terratec Grabby hwrev 2
Message-ID: <20130503111240.GA2291@localhost>
References: <20130326102056.63b55916@vostro>
 <20130327161049.683483f8@vostro>
 <20130328105201.7bcc7388@vostro>
 <20130328094052.26b7f3f5@redhat.com>
 <20130328153556.0b58d1aa@vostro>
 <20130328165459.6231a5b1@vostro>
 <20130501171153.GA1377@dell.arpanet.local>
 <20130502100456.2fdf42e0@vostro>
 <20130503084755.7c2f9cd1@vostro>
 <20130503091317.GE1232@dell.arpanet.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130503091317.GE1232@dell.arpanet.local>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jon,

On Fri, May 03, 2013 at 11:13:17AM +0200, Jon Arne Jørgensen wrote:
[...]
> 
> I've tested the changes, and it doesn't seem to break/change the smi2021 driver.
> I'll append this to the pending saa7115 patch and ask Ezequiel Garcia to check
> that the change doesn't break the stk1160 driver.
> 

Wow, this gm7113c are starting to appear everywhere.

Will you submit a v5 including this? In that case please drop my Tested-by
from the 3/3 patch since I need to re-test that again.

Thanks,
-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
