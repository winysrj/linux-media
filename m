Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:37749 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753596Ab2BCR3A (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Feb 2012 12:29:00 -0500
Received: by qcqw6 with SMTP id w6so2221443qcq.19
        for <linux-media@vger.kernel.org>; Fri, 03 Feb 2012 09:28:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20120203171250.52278c25@junior>
References: <20120203171250.52278c25@junior>
Date: Fri, 3 Feb 2012 17:28:59 +0000
Message-ID: <CAH4Ag-BZ+Csasy=yk5sNt7_Q5maFuxga2PqeXtJrRYvVLa8zzA@mail.gmail.com>
Subject: Re: TBS 6920 remote
From: Simon Jones <sijones2010@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 3 February 2012 17:12, Tony Houghton <h@realh.co.uk> wrote:
> I've got a TBS 6920 PCI-E DVB-S2 card, which explicitly claims Linux
> compatibility on the box. It works as a satellite receiver, but I get no
> response from the remote control (trying to read /dev/input/event5). I
> think this is its entry in /proc/bus/input/devices:

TBS have there own media tree for their cards, they do not submit the
drivers upstream for inclusion in the kernel, if you go to the
manufacturer site you'll get support from their forums. But it has
been very well known they have issues with remote support.

I don't develop for linux media system, am just letting you know for
information.
