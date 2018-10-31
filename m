Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4172 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727980AbeJaTzY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 Oct 2018 15:55:24 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20181031084327.25bd5654ij37o3b5@gofer.mess.org>
References: <20181031084327.25bd5654ij37o3b5@gofer.mess.org> <153778383104.14867.1567557014782141706.stgit@warthog.procyon.org.uk> <20181030110319.764f33f0@coco.lan> <20181030223249.dhwhxdjipzmjxzsy@gofer.mess.org> <20181030213513.51922545@coco.lan>
To: Sean Young <sean@mess.org>
Cc: dhowells@redhat.com,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Brad Love <brad@nextdimension.cc>, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dvb: Allow MAC addresses to be mapped to stable device names with udev
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <10474.1540983466.1@warthog.procyon.org.uk>
Date: Wed, 31 Oct 2018 10:57:46 +0000
Message-ID: <10475.1540983466@warthog.procyon.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sean Young <sean@mess.org> wrote:

> With this patch, with a usb Hauppauge Nova-T Stick I get:
> 
> $ tail /sys/class/dvb/*/dvb_*
> ...
> ==> /sys/class/dvb/dvb0.demux0/dvb_mac <==
> 00:00:00:00:00:00

I presume you're complaining, then, that the file exists in this instance
rather than it doesn't have the real MAC address in it?

> Having said that dvb_type does look a little nicer:
> 
> 	ATTR{dvb_type}=="demux"

So I should keep that or drop that?

David
