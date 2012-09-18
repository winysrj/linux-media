Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:56905 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166Ab2IRTBm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Sep 2012 15:01:42 -0400
Received: by obbuo13 with SMTP id uo13so238837obb.19
        for <linux-media@vger.kernel.org>; Tue, 18 Sep 2012 12:01:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGoCfixqaSY4MFosg=uCwGMRRmbQhYE5gUBdPGFddCpKHDRtwg@mail.gmail.com>
References: <CAAnFQG_SrXyr8MtPDujciE2=QRQK8dAK_SPBE3rC_c-XNSC00w@mail.gmail.com>
 <CAGoCfiy4Ybymdd4Mym1JB3gwW9Suqdj3w6bEdMpxWWBHPhUvTQ@mail.gmail.com>
 <CAAnFQG8fDnmGN2_sfrhU8tB_kiuheSmXPqVq5wdmh73vB8EtdA@mail.gmail.com> <CAGoCfixqaSY4MFosg=uCwGMRRmbQhYE5gUBdPGFddCpKHDRtwg@mail.gmail.com>
From: Javier Marcet <jmarcet@gmail.com>
Date: Tue, 18 Sep 2012 21:01:21 +0200
Message-ID: <CAAnFQG-zwQ9uizt4QjVFMmBcdEvrTSDL4-UHQppqC-_hyXqt8A@mail.gmail.com>
Subject: Re: Terratec Cinergy T PCIe Dual doesn;t work nder the Xen hypervisor
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Sep 18, 2012 at 8:56 PM, Devin Heitmueller
<dheitmueller@kernellabs.com> wrote:

>> You can see the original thread where this was found, together with a
>> working patch, here:
>>
>> http://lists.xen.org/archives/html/xen-devel/2012-01/msg01927.html
>
> As far as I can read, the patch has never been confirmed to work.  The
> user mentioned upgrading to an updated kernel and seeing a slight
> decrease in load:
>
> http://lists.xen.org/archives/html/xen-devel/2012-01/msg02166.html
>
> Further, the reason many of the drivers in question require the memory
> to be in the 0-4GB memory region is due to some hardware not being
> able to DMA to memory > 4GB.  Such a change would have to be tested
> with every board that does scatter/gather, and the framework would
> likely have to change to explicitly allow the board driver to specify
> whether it supports memory > 4GB.
>
> In short, this is a useful bit of information, but not clear whether
> it would actually solve the underlying problem.
>
> Again, I would be happy to be proven wrong, but there appears to still
> be quite a bit of work required for such.  I would suggest trying the
> patch yourself to see if it has any visible effect on the problem.

I'm sorry I was not explicit. I have tested it, I have it working
right now, flawlessly. It even worked after resuming from S3!


-- 
Javier Marcet <jmarcet@gmail.com>
