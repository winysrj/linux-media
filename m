Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f52.google.com ([209.85.215.52]:44370 "EHLO
        mail-lf0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751521AbdIUIhn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Sep 2017 04:37:43 -0400
Date: Thu, 21 Sep 2017 10:37:39 +0200
From: Johan Hovold <johan@kernel.org>
To: Andrey Konovalov <andreyknvl@google.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Oleh Kravchenko <oleg@kaa.org.ua>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Johan Hovold <johan@kernel.org>, linux-media@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Kostya Serebryany <kcc@google.com>,
        syzkaller <syzkaller@googlegroups.com>
Subject: Re: usb/media/cx231xx: null-ptr-deref in cx231xx_usb_probe
Message-ID: <20170921083739.GI3198@localhost>
References: <CAAeHK+zQm2DJT-1POrnB+1OFGVdTCOg+rpZODW=UPyLM1Ysr=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAeHK+zQm2DJT-1POrnB+1OFGVdTCOg+rpZODW=UPyLM1Ysr=g@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Sep 20, 2017 at 08:54:08PM +0200, Andrey Konovalov wrote:
> Hi!
> 
> I've got the following report while fuzzing the kernel with syzkaller.
> 
> On commit ebb2c2437d8008d46796902ff390653822af6cc4 (Sep 18).
> 
> The null-ptr-deref happens on assoc_desc->bFirstInterface, where
> assoc_desc = udev->actconfig->intf_assoc[0]. There seems to be no
> check that the device actually contains an Interface Association
> Descriptor.

That is indeed a bug; I'll respond to this mail with a fix.

Thanks,
Johan
