Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail81.extendcp.co.uk ([79.170.40.81]:55292 "EHLO
	mail81.extendcp.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754041Ab2BFQjH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Feb 2012 11:39:07 -0500
Received: from 188-222-111-86.zone13.bethere.co.uk ([188.222.111.86] helo=junior)
	by mail81.extendcp.com with esmtpa (Exim 4.77)
	id 1RuRam-00019I-FX
	for linux-media@vger.kernel.org; Mon, 06 Feb 2012 16:39:01 +0000
Date: Mon, 6 Feb 2012 16:38:59 +0000
From: Tony Houghton <h@realh.co.uk>
To: linux-media@vger.kernel.org
Subject: Re: TBS 6920 remote
Message-ID: <20120206163859.6de6b071@junior>
In-Reply-To: <CAH4Ag-AkTUWuawF=yDnb-UzXY5G4B6pVoK2qd7ODGia57CEjNQ@mail.gmail.com>
References: <20120203171250.52278c25@junior>
	<CAH4Ag-BZ+Csasy=yk5sNt7_Q5maFuxga2PqeXtJrRYvVLa8zzA@mail.gmail.com>
	<20120205185233.3ca5024a@tiber>
	<CAH4Ag-BL3V2th8tu78iE3toCo2SxbRHVpNzMB6jEfs2C5iuzBQ@mail.gmail.com>
	<20120206133520.788eeb3f@junior>
	<CAH4Ag-AkTUWuawF=yDnb-UzXY5G4B6pVoK2qd7ODGia57CEjNQ@mail.gmail.com>
Reply-To: linux-media@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 6 Feb 2012 14:25:33 +0000
Simon Jones <sijones2010@gmail.com> wrote:

> > The 6920 uses a Conexant chipset and everything except the remote
> > works with a standard kernel, but I did have to install the
> > firmware manually. Is the binary part for the remote? I would have
> > thought it was only for other chipsets.
> 
> Apologies then, I thought they were still maintaining a separate tree,
> maybe am confusing myself with a different manufacturer that wouldn't
> release the source.

They do seem to be maintaining their own tree, but the tarball (which is
within a zip) containing the driver code has a GPL COPYING file. There
may be some closed source drivers for other products in their range
somewhere in there, and if there is a version/copy of the Conexant
drivers in there perhaps it's modified to support their remote or
supplied just for completeness.
