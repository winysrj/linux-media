Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48148 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959Ab2IRS42 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Sep 2012 14:56:28 -0400
Received: by iahk25 with SMTP id k25so166275iah.19
        for <linux-media@vger.kernel.org>; Tue, 18 Sep 2012 11:56:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAnFQG8fDnmGN2_sfrhU8tB_kiuheSmXPqVq5wdmh73vB8EtdA@mail.gmail.com>
References: <CAAnFQG_SrXyr8MtPDujciE2=QRQK8dAK_SPBE3rC_c-XNSC00w@mail.gmail.com>
	<CAGoCfiy4Ybymdd4Mym1JB3gwW9Suqdj3w6bEdMpxWWBHPhUvTQ@mail.gmail.com>
	<CAAnFQG8fDnmGN2_sfrhU8tB_kiuheSmXPqVq5wdmh73vB8EtdA@mail.gmail.com>
Date: Tue, 18 Sep 2012 14:56:28 -0400
Message-ID: <CAGoCfixqaSY4MFosg=uCwGMRRmbQhYE5gUBdPGFddCpKHDRtwg@mail.gmail.com>
Subject: Re: Terratec Cinergy T PCIe Dual doesn;t work nder the Xen hypervisor
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Javier Marcet <jmarcet@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Sep 18, 2012 at 2:34 PM, Javier Marcet <jmarcet@gmail.com> wrote:
> I can't say how happy I am that you were wrong in your guess. Quoting
> Konrad Rzeszutek Wilk:

Well, you haven't proven me wrong yet.  :-)

> """
> The issue as I understand is that the DVB drivers allocate their
> buffers from 0->4GB most (all the time?) so they never have to do
> bounce-buffering.
>
> While the pv-ops one ends up quite frequently doing the
> bounce-buffering, which implies that the DVB drivers end up allocating
> their buffers above the 4GB.
> This means we end up spending some CPU time (in the guest) copying the
> memory from >4GB to 0-4GB region (And vice-versa).
> """
>
> You can see the original thread where this was found, together with a
> working patch, here:
>
> http://lists.xen.org/archives/html/xen-devel/2012-01/msg01927.html

As far as I can read, the patch has never been confirmed to work.  The
user mentioned upgrading to an updated kernel and seeing a slight
decrease in load:

http://lists.xen.org/archives/html/xen-devel/2012-01/msg02166.html

Further, the reason many of the drivers in question require the memory
to be in the 0-4GB memory region is due to some hardware not being
able to DMA to memory > 4GB.  Such a change would have to be tested
with every board that does scatter/gather, and the framework would
likely have to change to explicitly allow the board driver to specify
whether it supports memory > 4GB.

In short, this is a useful bit of information, but not clear whether
it would actually solve the underlying problem.

Again, I would be happy to be proven wrong, but there appears to still
be quite a bit of work required for such.  I would suggest trying the
patch yourself to see if it has any visible effect on the problem.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
