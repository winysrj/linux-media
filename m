Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qg0-f52.google.com ([209.85.192.52]:35029 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753553AbbKQNcz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Nov 2015 08:32:55 -0500
Received: by qgec40 with SMTP id c40so5194915qge.2
        for <linux-media@vger.kernel.org>; Tue, 17 Nov 2015 05:32:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJ2oMh++Rhcvqs+nmCPRrTUmKkze69t1tJmK3KBRvhoBC6qYjg@mail.gmail.com>
References: <CAJ2oMhLN1T5GL3OhdcOLpK=t74NpULTz4ezu=fZDOEaXYVoWdg@mail.gmail.com>
	<564ADD04.90700@xs4all.nl>
	<CAJ2oMh++Rhcvqs+nmCPRrTUmKkze69t1tJmK3KBRvhoBC6qYjg@mail.gmail.com>
Date: Tue, 17 Nov 2015 08:32:54 -0500
Message-ID: <CALzAhNUFGKoTOcQ90yRbCybapg+nA_7958OM0Mh_ksBo-_nPcg@mail.gmail.com>
Subject: Re: cobalt & dma
From: Steven Toth <stoth@kernellabs.com>
To: Ran Shalit <ranshalit@gmail.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Is the cobalt or other pci v4l device have the chip datasheet
> available so that we can do a reverse engineering and gain more
> understanding about the register read/write for the dma transactions ?
> I made a search but it seems that the PCIe chip datasheet for these
> devices is not available anywhere.

Generally you wouldn't need it, and I'm not sure it would help having it.

Get to grips with the fundamentals and don't worry about cobalt registers.

DMA programming is highly chip specific, but in general terms its
highly similar in concept on any PCIe controller. Every
driver+controller uses virtual/physical bus addresses that need to be
understood, scatter gather list created and programmed into the h/w,
interrupts serviced, buffer/transfer completion identification and
transfer sizes.

Look hard enough at any of the PCI/E drivers in the media tree and
you'll see each of them implementing their own versions of the above.

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
