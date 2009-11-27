Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:49341 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754099AbZK0HuJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Nov 2009 02:50:09 -0500
Date: 27 Nov 2009 08:45:00 +0100
From: christoph@bartelmus.de (Christoph Bartelmus)
To: jarod@wilsonet.com
Cc: awalls@radix.net
Cc: dmitry.torokhov@gmail.com
Cc: j@jannau.net
Cc: jarod@redhat.com
Cc: khc@pm.waw.pl
Cc: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-media@vger.kernel.org
Cc: mchehab@redhat.com
Cc: superm1@ubuntu.com
Message-ID: <BDgcYO8JjFB@christoph>
In-Reply-To: <4B0EABF8.9000902@redhat.com>
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was: Re: [PATCH 1/3 v2] lirc core device driver infrastructure
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

on 26 Nov 09 at 14:25, Mauro Carvalho Chehab wrote:
> Christoph Bartelmus wrote:
[...]
>> But I'm still a bit hesitant about the in-kernel decoding. Maybe it's just
>> because I'm not familiar at all with input layer toolset.
[...]
> I hope it helps for you to better understand how this works.

So the plan is to have two ways of using IR in the future which are  
incompatible to each other, the feature-set of one being a subset of the  
other?

When designing the key mapping in the kernel you should be aware that  
there are remotes out there that send a sequence of scan codes for some  
buttons, e.g.
http://lirc.sourceforge.net/remotes/pioneer/CU-VSX159

Christoph
