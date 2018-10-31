Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50750 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725743AbeJaT6y (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 Oct 2018 15:58:54 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20181031104912.s3tqjl3u43ou3kwo@gofer.mess.org>
References: <20181031104912.s3tqjl3u43ou3kwo@gofer.mess.org> <20181030223249.dhwhxdjipzmjxzsy@gofer.mess.org> <153778383104.14867.1567557014782141706.stgit@warthog.procyon.org.uk> <20181030110319.764f33f0@coco.lan> <8474.1540982182@warthog.procyon.org.uk>
To: Sean Young <sean@mess.org>
Cc: dhowells@redhat.com,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Brad Love <brad@nextdimension.cc>, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dvb: Allow MAC addresses to be mapped to stable device names with udev
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <10734.1540983675.1@warthog.procyon.org.uk>
Date: Wed, 31 Oct 2018 11:01:15 +0000
Message-ID: <10735.1540983675@warthog.procyon.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sean Young <sean@mess.org> wrote:

> > How do I tell?  If it's all zeros it's not there?
> 
> The mac gets populated through read_mac_address member of
> dvb_usb_device_properties.

That doesn't seem to be true for all drivers. The cx23885 driver does things
differently, for instance.

David
