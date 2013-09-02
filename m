Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f178.google.com ([209.85.220.178]:52904 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366Ab3IBBpN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Sep 2013 21:45:13 -0400
Received: by mail-vc0-f178.google.com with SMTP id ha12so2744224vcb.9
        for <linux-media@vger.kernel.org>; Sun, 01 Sep 2013 18:45:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1378086079.25743.87.camel@deadeye.wl.decadent.org.uk>
References: <1378082213.25743.58.camel@deadeye.wl.decadent.org.uk>
	<1378082375.25743.61.camel@deadeye.wl.decadent.org.uk>
	<CAOMZO5C_fOqe+9a1BVWxnQ3hrYZaxf5AN4WNrOacQdkng8h-Jg@mail.gmail.com>
	<1378086079.25743.87.camel@deadeye.wl.decadent.org.uk>
Date: Sun, 1 Sep 2013 22:45:12 -0300
Message-ID: <CAOMZO5CBURyHJBtJOLHf_ia9_2tSg5iFpxf3=YMx-Med1kFA+w@mail.gmail.com>
Subject: Re: [PATCH 2/4] [media] lirc_bt829: Fix physical address type
From: Fabio Estevam <festevam@gmail.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Jarod Wilson <jarod@wilsonet.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media <linux-media@vger.kernel.org>,
	devel@driverdev.osuosl.org, Joe Perches <joe@perches.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Sep 1, 2013 at 10:41 PM, Ben Hutchings <ben@decadent.org.uk> wrote:
> On Sun, 2013-09-01 at 22:37 -0300, Fabio Estevam wrote:
>> On Sun, Sep 1, 2013 at 9:39 PM, Ben Hutchings <ben@decadent.org.uk> wrote:
>>
>> >         pci_addr_phys = pdev->resource[0].start;
>> > -       dev_info(&pdev->dev, "memory at 0x%08X\n",
>> > -                (unsigned int)pci_addr_phys);
>> > +       dev_info(&pdev->dev, "memory at 0x%08llX\n",
>> > +                (unsigned long long)pci_addr_phys);
>>
>> You could use %pa instead for printing phys_addr_t:
>>
>> dev_info(&pdev->dev, "memory at %pa\n", &pci_addr_phys);
>
> Could do, but I'm not sure it's clearer.  And all these %p formats
> defeat type-checking anyway.

IMHO using %pa looks clearer and it is also recommended in
Documentation/printk-formats.txt.
