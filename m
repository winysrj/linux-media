Return-path: <linux-media-owner@vger.kernel.org>
Received: from mfe3.msomt.modwest.com ([204.11.245.167]:45447 "EHLO
	mfe3.msomt.modwest.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042Ab0FQDXU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Jun 2010 23:23:20 -0400
Received: from fao (unknown [190.246.185.18])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by mfe3.msomt.modwest.com (Postfix) with ESMTP id 061048A1A1
	for <linux-media@vger.kernel.org>; Wed, 16 Jun 2010 21:23:16 -0600 (MDT)
Date: Thu, 17 Jun 2010 00:23:11 -0300
From: Ramiro Morales <ramiro@rmorales.net>
To: linux-media@vger.kernel.org
Subject: Re: [PATCH] saa7134: Add support for Compro VideoMate Vista M1F
Message-ID: <20100617032307.GA3128@fao>
References: <20100612215757.GA4796@fao>
 <20100612225220.GA5574@fao>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100612225220.GA5574@fao>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Jun 12, 2010 at 07:52:22PM -0300, Ramiro Morales wrote:
> On Sat, Jun 12, 2010 at 06:57:58PM -0300, Ramiro Morales wrote:
>>
>> For a start, the PCI ID is different from the Pavel's one (185b:c900):                                                                       
>> [...]
>>   $ lspci -n |grep 01\:07\.0                                                                                                                 
>>   01:07.0 0480: 1131:7133 (rev d1)                                                                                                           
>>                                                                                                                                              
>> (btw, it's the same PCI ID as card #17: AOPEN VA1000 POWER)
>>

Since then I've learned that the IDs in CARDLIST.saa7134 aren't PCI IDs
but subsystem IDs.

> 
> These are the labels of the different components (see attached PNG
> diagram):
> 

I've created a wiki page for this card containing this and more
information:

http://linuxtv.org/wiki/index.php/Compro_VideoMate_Vista_M1F

> 
> So far, I've been unable to get either sound (it appears as an ALSA
> device but can't unmute) or the RC working but I suspect this is some
> kind of fault on my side.

Sound isn't workking yet. Remote control is working without having
to run LIRC nor inpurtlirc.

-- 
 Ramiro Morales


