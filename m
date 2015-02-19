Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f173.google.com ([209.85.214.173]:45238 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595AbbBSQFn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Feb 2015 11:05:43 -0500
Received: by mail-ob0-f173.google.com with SMTP id uy5so16062057obc.4
        for <linux-media@vger.kernel.org>; Thu, 19 Feb 2015 08:05:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20150219124037.GA3500@gofer.mess.org>
References: <1424116126-14052-1-git-send-email-pdowner@prospero-tech.com>
	<1424116126-14052-2-git-send-email-pdowner@prospero-tech.com>
	<20150219124037.GA3500@gofer.mess.org>
Date: Thu, 19 Feb 2015 16:05:42 +0000
Message-ID: <CAE6wzSJ5pshY0atiYKp2m7EG7G5_V5meKJNbYS7=5DK+7EfU9A@mail.gmail.com>
Subject: Re: [RFC PATCH 1/1] [media] pci: Add support for DVB PCIe cards from
 Prospero Technologies Ltd.
From: Philip Downer <pdowner@prospero-tech.com>
To: Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Feb 19, 2015 at 12:40 PM, Sean Young <sean@mess.org> wrote:
> On Mon, Feb 16, 2015 at 07:48:46PM +0000, Philip Downer wrote:
> -snip-
>> +     dev = rc_allocate_device();
>> +
>> +     if (!ir || !dev)
>> +             goto err_out_free;
>> +
>> +     ir->dev = dev;
>> +
>> +     snprintf(ir->name, sizeof(ir->name), "prospero IR");
>> +     snprintf(ir->phys, sizeof(ir->phys), "pci-%s/ir0", pci_name(pci));
>> +
>> +     dev->input_name = ir->name;
>> +     dev->input_phys = ir->phys;
>> +     dev->input_id.bustype = BUS_PCI;
>> +     dev->input_id.version = 1;
>> +     dev->input_id.vendor = pci->vendor;
>> +     dev->input_id.product = pci->device;
>> +
>> +     dev->dev.parent = &pci->dev;
>> +     dev->map_name = RC_MAP_LIRC;
>
> RC_MAP_LIRC isn't really a useful default; no remote will work with that.
> Other drivers default to RC_MAP_RC6_MCE if no remote was provided with
> the product. I don't know if this is good choice, but at least it is
> consistent.
>
>> +
>> +     dev->driver_name = "prospero";
>> +     dev->priv = p;
>> +     dev->open = prospero_ir_open;
>> +     dev->close = prospero_ir_close;
>> +     dev->driver_type = RC_DRIVER_IR_RAW;
>> +     dev->timeout = 10 * 1000 * 1000;
>
> There is a MS_TO_NS() macro for this.

Ok, thanks Sean, those changes have been made and will be included
when I submit the next RFC patch.

Thanks again,

-- 
Philip Downer
+44 (0)7879 470 969
pdowner@prospero-tech.com
