Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:47122 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742Ab2IRSed (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Sep 2012 14:34:33 -0400
Received: by obbuo13 with SMTP id uo13so205909obb.19
        for <linux-media@vger.kernel.org>; Tue, 18 Sep 2012 11:34:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGoCfiy4Ybymdd4Mym1JB3gwW9Suqdj3w6bEdMpxWWBHPhUvTQ@mail.gmail.com>
References: <CAAnFQG_SrXyr8MtPDujciE2=QRQK8dAK_SPBE3rC_c-XNSC00w@mail.gmail.com>
 <CAGoCfiy4Ybymdd4Mym1JB3gwW9Suqdj3w6bEdMpxWWBHPhUvTQ@mail.gmail.com>
From: Javier Marcet <jmarcet@gmail.com>
Date: Tue, 18 Sep 2012 20:34:12 +0200
Message-ID: <CAAnFQG8fDnmGN2_sfrhU8tB_kiuheSmXPqVq5wdmh73vB8EtdA@mail.gmail.com>
Subject: Re: Terratec Cinergy T PCIe Dual doesn;t work nder the Xen hypervisor
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Sep 18, 2012 at 5:40 AM, Devin Heitmueller
<dheitmueller@kernellabs.com> wrote:

Hi Devin,

> This is a very common problem when attempting to use any PCI/PCIe
> tuner under a hypervisor.  Essentially the issue is all of the
> virtualization solutions provide very poor interrupt latency, which
> results in the data being lost.
>
> Devices delivering a high bitrate stream of data in realtime are much
> more likely for this problem to be visible since such devices have
> very little buffering (it's not like a hard drive controller where it
> can just deliver the data slower).  The problem is not specific to the
> cx23885 - pretty much all of the PCI/PCIe bridges used in tuner cards
> work this way, and they cannot really be blamed for expecting to run
> in an environment with really crappy interrupt latency.
>
> I won't go as far as to say, "abandon all hope", but you're not really
> likely to find any help in this forum.

I can't say how happy I am that you were wrong in your guess. Quoting
Konrad Rzeszutek Wilk:

"""
The issue as I understand is that the DVB drivers allocate their
buffers from 0->4GB most (all the time?) so they never have to do
bounce-buffering.

While the pv-ops one ends up quite frequently doing the
bounce-buffering, which implies that the DVB drivers end up allocating
their buffers above the 4GB.
This means we end up spending some CPU time (in the guest) copying the
memory from >4GB to 0-4GB region (And vice-versa).
"""

You can see the original thread where this was found, together with a
working patch, here:

http://lists.xen.org/archives/html/xen-devel/2012-01/msg01927.html


-- 
Javier Marcet <jmarcet@gmail.com>
