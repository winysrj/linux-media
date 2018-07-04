Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.anw.at ([195.234.102.72]:53434 "EHLO smtp.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752719AbeGDUUn (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 4 Jul 2018 16:20:43 -0400
Subject: Re: [PATCH v3 0/3] IOCTLs in ddbridge.
To: Daniel Scheller <d.scheller.oss@gmail.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com, Jonathan Corbet <corbet@lwn.net>,
        Andrew Morton <akpm@linux-foundation.org>
References: <20180512112432.30887-1-d.scheller.oss@gmail.com>
 <20180704130831.1073f094@coco.lan> <20180704190832.17141b60@lt530>
From: "Jasmin J." <jasmin@anw.at>
Message-ID: <088c71b4-f817-92b9-be4b-465f4f87579f@anw.at>
Date: Wed, 4 Jul 2018 22:20:32 +0200
MIME-Version: 1.0
In-Reply-To: <20180704190832.17141b60@lt530>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mauro!

> Patch looks ok, although it would be great to get some acks there.
I have no time to test this, but I know Daniel does all this tests and in fact
he is currently adapting changes done by DD in their repo, modifying them to
work in the current media-tree version and submits them to the list. So this
is more or less work to keep the kernel driver in sync with the DD repo.

Please remember this from Daniels patch submit message:
  Patch 3 (re)implements the IOCTL handling into ddbridge. This is
  basically code that was there since literally forever, but had to be
  removed along with the initial ddbridge-0.9.x bump.
So he is adding back the original ioctl's, which are nowadays more used because
of (also from the patch submit message):
  The whole functionality gets more important these days since ie. the
  new MaxSX8 cards may require updating from time to time since these
  cards implement the demod/tuner communication in their FPGA

So if you need an ack:
Acked-by: Jasmin Jessich <jasmin@anw.at>

> If you're fine with anything else in this series, please be so kind and
> pick this stuff up and I'll shove such doc up afterwards as a separate
> patch. This whole thing is being posted for over a year now, ...
Please Mauro, merge this now and I am sure Daniel will add the missing
documentation!
Keep also in mind, that we all do this in our spare time and we do this because
DD was and is not willing to submit their own drivers!
Do your really believe that it is helpful when patches are rodding months for
no reason? This is often demotivating and thus some maintainers may give up
only because of that.
I am extremely happy, that Daniel took over and made it happen, that we get the
DD drivers into the Kernel and thus, we can use DD HW and also other HW in
parallel. This would be not possible with the drivers from DD.

BR,
   Jasmin
