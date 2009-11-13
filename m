Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.viadmin.org ([195.145.128.101]:34768 "EHLO www.viadmin.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754777AbZKMSK2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Nov 2009 13:10:28 -0500
Date: Fri, 13 Nov 2009 19:10:23 +0100
From: "H. Langos" <henrik-dvb@prak.org>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>,
	linux-media@vger.kernel.org, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Organizing ALL device data in linuxtv wiki
Message-ID: <20091113181023.GA31295@www.viadmin.org>
References: <20091112173130.GV31295@www.viadmin.org> <20091113160850.GY31295@www.viadmin.org> <4AFD8B9A.7000309@hoogenraad.net> <829197380911130845y7a18ca25k266159c3af031a3e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <829197380911130845y7a18ca25k266159c3af031a3e@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Nov 13, 2009 at 11:45:07AM -0500, Devin Heitmueller wrote:
> On Fri, Nov 13, 2009 at 11:38 AM, Jan Hoogenraad
> <jan-conceptronic@hoogenraad.net> wrote:
> > Would it be possible to store this information in the CODE archives, and
> > extract it from there ?
> > Right now, I end up putting essentially the same information into structures
> > in the driver and into documentation.

It would be possible. But that would require the driver developers 
to agree on a machine readable format. Either in the code or in the 
documentation. (BTW Which documentation would that be? I thought the code
was the only Documentation :-) )

> > This is hard to keep synchronised.
> >
> > Basic information like device IDs, vendors, demod types, tuners, etc is
> > already in place in the driver codes.
> >
> > Getting data from the hg archives (including development branches) sounds
> > like a cleaner solution.
> 
> The challenge you run into there is that every driver organizes its
> table of products differently, and the driver source code does not
> expose what features the device supports in any easily easily parsed
> manner.  Also, it does not indicate what the hardware supports which
> is not supported by the Linux driver.
> 
> So for example, you can have a hybrid USB device that supports
> ATSC/QAM and analog NTSC.  The driver won't really tell you these
> things, nor will it tell you that the hardware also supports IR but
> the Linux driver does not.
> 
> It's one of those ideas that sounds reasonable until you look at how
> the actual code defines devices.

Yeap. I agree whole heartedly. For some simle drivers you can read that
information from the source. But most drivers support e.g. more than one
tuner and the information which device has which tuner, is not part of
the driver anymore. Rather the driver looks onto the device's i2c bus
to find out which tuner is present. At least this is what I gathered
from browsing through the driver code in order to get my device 
table up to date. (see
http://www.linuxtv.org/wiki/index.php/Talk:DVB-T_USB_Devices#Adding_supported_devices_from_kernel_sources
) I don't actually have a clue. So don't take my word for it.

cheers
-henrik


