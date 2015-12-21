Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:59765 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751123AbbLUORf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Dec 2015 09:17:35 -0500
Subject: Re: [PATCH v3 00/23] Unrestricted media entity ID range support
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
References: <1450272758-29446-1-git-send-email-sakari.ailus@iki.fi>
 <20151216140301.GO17128@valkosipuli.retiisi.org.uk>
 <20151216153936.0227d179@recife.lan>
From: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	hverkuil@xs4all.nl
Message-ID: <567809F9.5020909@osg.samsung.com>
Date: Mon, 21 Dec 2015 11:17:29 -0300
MIME-Version: 1.0
In-Reply-To: <20151216153936.0227d179@recife.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/16/2015 02:39 PM, Mauro Carvalho Chehab wrote:
> Em Wed, 16 Dec 2015 16:03:01 +0200
> Sakari Ailus <sakari.ailus@iki.fi> escreveu:
> 
>> Hi Javier,
>>
>> On Wed, Dec 16, 2015 at 03:32:15PM +0200, Sakari Ailus wrote:
>>> This is the third version of the unrestricted media entity ID range
>>> support set. I've taken Mauro's comments into account and fixed a number
>>> of bugs as well (omap3isp memory leak and omap4iss stream start).
> 
> Patches merged on my experimental tree:
> 
> 	ssh://linuxtv.org/git/mchehab/experimental.git
> 
> branch media-controller-rc4
> 
> I had to do some rebase, as you were using some older changeset.
> Also, several documentation tags were with troubles (renamed
> vars not renamed there).
> 
> Next time, please check the documentation with:
> 	make DOCBOOKS=device-drivers.xml htmldocs 2>&1
> 
>> Javier: Mauro told me you might have OMAP4 hardware. Would you be able to
>> test the OMAP4 ISS with these patches?
> 

Sakari, I used to have an OMAP4 board (OMAP4460 Panda ES) but I don't
have it anymore, only OMAP3 and AM335x boards using TI SoCs for now.

> As Sakari patches were rebased, it would be good to test them again
> on omap3.
>

Mauro, I tested your latest media-controller-rc4 branch that contains
Sakari's patches and both graph enumration and video capture work on
my OMAP3 IGEPv2 board.

> Regards,
> Mauro
> 

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
