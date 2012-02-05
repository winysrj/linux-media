Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail81.extendcp.co.uk ([79.170.40.81]:46576 "EHLO
	mail81.extendcp.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754969Ab2BESwc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Feb 2012 13:52:32 -0500
Received: from 188-222-111-86.zone13.bethere.co.uk ([188.222.111.86] helo=tiber)
	by mail81.extendcp.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.77)
	id 1Ru7CQ-0004lh-ND
	for linux-media@vger.kernel.org; Sun, 05 Feb 2012 18:52:30 +0000
Received: from [127.0.0.1] (helo=tiber)
	by tiber with esmtp (Exim 4.77)
	(envelope-from <h@realh.co.uk>)
	id 1Ru7CT-00053J-MW
	for linux-media@vger.kernel.org; Sun, 05 Feb 2012 18:52:33 +0000
Date: Sun, 5 Feb 2012 18:52:33 +0000
From: Tony Houghton <h@realh.co.uk>
To: linux-media@vger.kernel.org
Subject: Re: TBS 6920 remote
Message-ID: <20120205185233.3ca5024a@tiber>
In-Reply-To: <CAH4Ag-BZ+Csasy=yk5sNt7_Q5maFuxga2PqeXtJrRYvVLa8zzA@mail.gmail.com>
References: <20120203171250.52278c25@junior>
	<CAH4Ag-BZ+Csasy=yk5sNt7_Q5maFuxga2PqeXtJrRYvVLa8zzA@mail.gmail.com>
Reply-To: linux-media@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 3 Feb 2012 17:28:59 +0000
Simon Jones <sijones2010@gmail.com> wrote:

> On 3 February 2012 17:12, Tony Houghton <h@realh.co.uk> wrote:
> > I've got a TBS 6920 PCI-E DVB-S2 card, which explicitly claims Linux
> > compatibility on the box. It works as a satellite receiver, but I get no
> > response from the remote control (trying to read /dev/input/event5). I
> > think this is its entry in /proc/bus/input/devices:
> 
> TBS have there own media tree for their cards, they do not submit the
> drivers upstream for inclusion in the kernel, if you go to the
> manufacturer site you'll get support from their forums. But it has
> been very well known they have issues with remote support.

Thanks. It seems that there was a bug in their driver which prevented
some keys from working, but AFIACT it's fixed now. The code is GPL so is
it just lack of interest/demand that's stopped it from going into the
main kernel?

I think I'll pass on having to maintain a 3rd party driver whenever the
Debian kernel upgrades. The remote is missing some quite important keys
like Play, so they seem to have only considered it for live viewing, not
for PVRs. I'll probably end up buying a separate USB remote or
continuing to use a portable keyboard.
