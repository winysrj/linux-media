Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8802 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754462Ab0EHWpt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 8 May 2010 18:45:49 -0400
Message-ID: <4BE5E995.4070003@redhat.com>
Date: Sat, 08 May 2010 19:45:41 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: LMML <linux-media@vger.kernel.org>,
	Sarah Sharp <sarah.a.sharp@intel.com>
Subject: Re: Status of the patches under review (85 patches) and some misc
 notes about the devel procedures
References: <20100507093916.2e2ef8e3@pedra> <20100508083127.73a72af7@tele>
In-Reply-To: <20100508083127.73a72af7@tele>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jean-Francois Moine wrote:
> On Fri, 7 May 2010 09:39:16 -0300
> Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
> 
>> 		== Gspca patches - Waiting Jean-Francois Moine
>> <moinejf@free.fr> submission/review == 
>>
>> Feb,24 2010: gspca pac7302: add USB PID range based on
>> heuristics                   http://patchwork.kernel.org/patch/81612
>> May, 3 2010: gspca: Try a less bandwidth-intensive alt
>> setting.                     http://patchwork.kernel.org/patch/96514
> 
> Hello Mauro,
> 
> I don't think the patch about pac7302 should be applied.

> 
> The patch about the gspca main is in my last git pull request.

(c/c Sarah)

I also didn't like this patch strategy. It seems a sort of workaround
for xHCI, instead of a proper fix.

I'll mark this patch as rejected, and wait for a proper fix.

-- 

Cheers,
Mauro
