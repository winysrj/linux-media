Return-path: <linux-media-owner@vger.kernel.org>
Received: from host170-142-static.86-94-b.business.telecomitalia.it ([94.86.142.170]:44321
	"EHLO zini-associati.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042AbZCDI6O (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Mar 2009 03:58:14 -0500
Received: from zini-associati.it (localhost.localdomain [127.0.0.1])
	by zini-associati.it (Postfix) with ESMTP id E8474D1222
	for <linux-media@vger.kernel.org>; Wed,  4 Mar 2009 09:34:33 +0100 (CET)
Received: from [192.168.0.10] (unknown [192.168.0.10])
	by zini-associati.it (Postfix) with ESMTP id D0411D1220
	for <linux-media@vger.kernel.org>; Wed,  4 Mar 2009 09:34:33 +0100 (CET)
Message-ID: <49AE3D17.20401@zini-associati.it>
Date: Wed, 04 Mar 2009 09:34:31 +0100
From: vic <vic@zini-associati.it>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: lifeview NOT LV3H not working
References: <49AC472B.90202@zini-associati.it>
In-Reply-To: <49AC472B.90202@zini-associati.it>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

ciencio ha scritto:
> Hello,
> I bought the TV card in the object, it is a PCI hybrid TV-card, both 
> analogue and DVB-T.
> 
> I bought it, because on the manufacturer site they said they develop a 
> linux driver, unfortunately when I downloaded the driver (which claims 
> to be for fedora) I found the whole V4L tree to be compiled.
> 
> By the way, I tried to compiled it but it failed 'because it looked for 
> the 2.6.19 kernel sources while I'm on Ubuntu Intrepid with a 2.6.27.

While I was trying to make the card work, I found a peculiar note in the 
NotOnlyTV faq that says that the driver they provide only works on 
Fedora 6.0.

Since Fedora 6.0 is an "old" distro (Fedora is now at the 10th revision) 
and since on ubuntu intrepid, the distro I'm using, the 2.6.19 kernel 
isn't available, I wondered if and how I could manage to apply the 
modifications they did to the main tree to make the driver work on more 
recent kernels and if those modifications could be imported in the main 
tree.

I attach the link to the V4l tree NOT provide is someone more expert 
than me wants have a look.

http://www.notonlytv.net/download/driver/lv3hlv3afedora.rar

And this is their faq (not very usefull indeed)

http://www.notonlytv.net/download/faq/faq_lv3h.pdf

Last thing, how can I know if someone is working on that card or on the 
chipset that card uses?

-- 
Vic
