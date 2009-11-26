Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:51940 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759320AbZKZIDu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Nov 2009 03:03:50 -0500
Date: 26 Nov 2009 09:01:00 +0100
From: lirc@bartelmus.de (Christoph Bartelmus)
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
Message-ID: <BDcbizrJjFB@christoph>
In-Reply-To: <4BFB11CF-1835-4AFA-BDC6-F42288A9A6F4@wilsonet.com>
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was: Re: [PATCH 1/3 v2] lirc core device driver infrastructure
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

on 25 Nov 09 at 12:44, Jarod Wilson wrote:
[...]
> Ah, but the approach I'd take to converting to in-kernel decoding[*] would
> be this:
[...]
> [*] assuming, of course, that it was actually agreed upon that in-kernel
> decoding was the right way, the only way, all others will be shot on sight.

I'm happy to see that the discussion is getting along.
But I'm still a bit hesitant about the in-kernel decoding. Maybe it's just  
because I'm not familiar at all with input layer toolset.

1. For sure in-kernel decoding will require some assistance from userspace  
to load the mapping from IR codes to keys. So, if there needs to be a tool  
in userspace that does some kind of autodetection, why not have a tool  
that does some autodetection and autoconfigures lircd for the current  
device. Lots of code duplication in kernel saved. What's the actual  
benefit of in-kernel decoding?

2. What would be the format of the key map? lircd.conf files already exist  
for a lot of remote controls. Will we have a second incompatible format to  
map the keys in-kernel? Where are the tools that create the key maps for  
new remotes?

Maybe someone can shed some light on this.

Christoph
