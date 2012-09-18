Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39197 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932678Ab2IRDkX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Sep 2012 23:40:23 -0400
Received: by iahk25 with SMTP id k25so5831132iah.19
        for <linux-media@vger.kernel.org>; Mon, 17 Sep 2012 20:40:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAnFQG_SrXyr8MtPDujciE2=QRQK8dAK_SPBE3rC_c-XNSC00w@mail.gmail.com>
References: <CAAnFQG_SrXyr8MtPDujciE2=QRQK8dAK_SPBE3rC_c-XNSC00w@mail.gmail.com>
Date: Mon, 17 Sep 2012 23:40:22 -0400
Message-ID: <CAGoCfiy4Ybymdd4Mym1JB3gwW9Suqdj3w6bEdMpxWWBHPhUvTQ@mail.gmail.com>
Subject: Re: Terratec Cinergy T PCIe Dual doesn;t work nder the Xen hypervisor
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Javier Marcet <jmarcet@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Sep 17, 2012 at 8:05 PM, Javier Marcet <jmarcet@gmail.com> wrote:
> Initially I thought Xen would be the cause of the problem, but after
> having written on
> the Xen development mailing list and talked about it with a couple
> developers, it isn't
> very clear where the problem is. So far I haven't been able to get the
> smallest warning
> or error.

This is a very common problem when attempting to use any PCI/PCIe
tuner under a hypervisor.  Essentially the issue is all of the
virtualization solutions provide very poor interrupt latency, which
results in the data being lost.

Devices delivering a high bitrate stream of data in realtime are much
more likely for this problem to be visible since such devices have
very little buffering (it's not like a hard drive controller where it
can just deliver the data slower).  The problem is not specific to the
cx23885 - pretty much all of the PCI/PCIe bridges used in tuner cards
work this way, and they cannot really be blamed for expecting to run
in an environment with really crappy interrupt latency.

I won't go as far as to say, "abandon all hope", but you're not really
likely to find any help in this forum.

Regards,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
