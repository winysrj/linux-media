Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:52004 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753005AbcKRVMy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Nov 2016 16:12:54 -0500
Date: Fri, 18 Nov 2016 22:12:52 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Olliver Schinagl <oliver@schinagl.nl>
Cc: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>
Subject: Re: [PATCH dtv-scan-tables] Rename pl-Krosno_Sucha_Gora with only
 ASCII characters
Message-ID: <20161118221252.37882d92@free-electrons.com>
In-Reply-To: <3081b3c9-4822-a40f-b119-5a75b65e3869@schinagl.nl>
References: <1479157550-983-1-git-send-email-thomas.petazzoni@free-electrons.com>
        <3081b3c9-4822-a40f-b119-5a75b65e3869@schinagl.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Fri, 18 Nov 2016 22:05:02 +0100, Olliver Schinagl wrote:

> I agree for consistency sake and ease of use, to use plain ascii for 
> pl-Krosno_Sucha_Gora as well. If someone feels that we should follow 
> proper spelling using UTF-8, someone should fix up and correct all names 
> in 1 rename patch.
> 
> Also there are various downstream users, which may simply not support 
> UTF-8. So by using ascii we also reduce the risk of trouble there.
> 
> Thank you for the patch and it has been merged.

Thanks a lot!

I think encoding the correct name of the city in the file name is not a
good idea. File name encoding is always problematic. Instead, what
would be better is to have the proper city name inside the file itself.
This way, you can specify that for the entire database, the files are
encoded in UTF-8.

Best regards,

Thomas
-- 
Thomas Petazzoni, CTO, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
