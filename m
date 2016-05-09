Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:59004 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751270AbcEIKbU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 9 May 2016 06:31:20 -0400
Date: Mon, 9 May 2016 07:31:15 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Will Manley <will@williammanley.net>
Cc: linux-media@vger.kernel.org, amy.zhou@magewell.net
Subject: Re: Driver for Magewell PCIe capture cards
Message-ID: <20160509073115.714c0c74@recife.lan>
In-Reply-To: <1462464586.3004166.599182921.0162873F@webmail.messagingengine.com>
References: <1462464586.3004166.599182921.0162873F@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Will,

Em Thu, 05 May 2016 17:09:46 +0100
Will Manley <will@williammanley.net> escreveu:

> Hi There
> 
> Magewell are a manufacturer of video-capture devices.  They have both
> USB and PCIe devices.  The USB devices use the upstream uvcvideo driver
> and Magewell currently provide proprietary drivers for their PCIe
> products.
> 
> http://www.magewell.com/
> 
> I've approached Magewell about having upstream Linux drivers for these
> PCIe devices and they are open to sharing hardware documentation and the
> sources to their proprietary drivers under an NDA for the purpose of
> developing an upstream Linux driver.  This is where I'm hoping that the
> linux driver project can help out.
> 
> My interest in this is that I want to be using Magewell PCIe capture
> cards in my company's products ( https://stb-tester.com/ ), but I don't
> want to be stuck with proprietary drivers.  I'm hoping I can facilitate
> because I have some limited kernel developer experience, but I wouldn't
> be confident enough to write an entire v4l driver myself.

The main question here is who will be developing the driver. It should
be someone with time, interest and access to the hardware and their
specs. It is probably easier if you're willing to do it, as you have
already what is needed. People at this mailing list can help you by
reviewing the patches once done, pointing you on how to correct things
that are not ok.

If you're not willing to do it yourself, then you'll likely need to 
sponsor someone to do it (either finding a hobbyist and donating him some
hardware or hiring some professional).

The need of a NDA can make it harder for hobbyists, as several won't
sign such documents. Also, the NDA should be carefully written to
allow to release the open source drivers after the job is done.

> 
> I'd originally posted this to the linux driver project mailing list[1]. 
> Greg KH suggested I repost here as there aren't many v4l developers on
> that list.
> 
> [1]:
> http://thread.gmane.org/gmane.linux.drivers.driver-project.devel/88218
> 
> Please let me know what additional information I can provide to get this
> process started.
> 
> Thanks
> 
> Will
> ---
> William Manley
> stb-tester.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Thanks,
Mauro
