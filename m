Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.melag.de ([217.6.74.107]:40494 "EHLO mail.melag.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752234AbbE1Q3B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 May 2015 12:29:01 -0400
Message-ID: <55674242.5040102@melag.de>
Date: Thu, 28 May 2015 18:28:50 +0200
From: "Enrico Weigelt, metux IT consult" <weigelt@melag.de>
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: imx53 IPU support on 4.0.4
References: <555C86A5.2030007@melag.de> <20150520205554.GY2067@n2100.arm.linux.org.uk>
In-Reply-To: <20150520205554.GY2067@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 20.05.2015 um 22:55 schrieb Russell King - ARM Linux:

Hi,

 > The way kernel development works is that patches are sent to mailing
> lists for review.  Kernel developers review the patches and provide
> comments back.  The comments are discussed and actioned, and a new
> set of patches posted for further review.  This cycle repeats.

Okay. I just wanted to prevent too much traffic.
But I'll use git-send-email, if you prefer.

> When everyone is happy, the patches can be applied, or pulled from
> a non-github git tree.  (Kernel people generally don't like github.)

Why so ?

> This is so that upstream kernel developers don't get too overloaded
> with work that really should be done by downstream folk (imagine if
> they had to rewrite every patch that came their way...)

Of course. I wasn't aware of the separate linux-media maillist at that
time.

By the way: I've now moved to Phillip's recent ipuv3 patches, but still
have lots of others (about 30) for my tqma53-based board, which might
be generic enough for going into mainline someday (many of them by
ptx folks).

Should I post them to lkml or somewhere else ?


cu
--
Enrico Weigelt, metux IT consult
+49-151-27565287
MELAG Medizintechnik oHG Sitz Berlin Registergericht AG Charlottenburg HRA 21333 B

Wichtiger Hinweis: Diese Nachricht kann vertrauliche oder nur für einen begrenzten Personenkreis bestimmte Informationen enthalten. Sie ist ausschließlich für denjenigen bestimmt, an den sie gerichtet worden ist. Wenn Sie nicht der Adressat dieser E-Mail sind, dürfen Sie diese nicht kopieren, weiterleiten, weitergeben oder sie ganz oder teilweise in irgendeiner Weise nutzen. Sollten Sie diese E-Mail irrtümlich erhalten haben, so benachrichtigen Sie bitte den Absender, indem Sie auf diese Nachricht antworten. Bitte löschen Sie in diesem Fall diese Nachricht und alle Anhänge, ohne eine Kopie zu behalten.
Important Notice: This message may contain confidential or privileged information. It is intended only for the person it was addressed to. If you are not the intended recipient of this email you may not copy, forward, disclose or otherwise use it or any part of it in any form whatsoever. If you received this email in error please notify the sender by replying and delete this message and any attachments without retaining a copy.
