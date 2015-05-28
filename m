Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.melag.de ([217.6.74.107]:29280 "EHLO mail.melag.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751588AbbE1Mfk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 May 2015 08:35:40 -0400
Message-ID: <55670B99.30103@melag.de>
Date: Thu, 28 May 2015 14:35:37 +0200
From: "Enrico Weigelt, metux IT consult" <weigelt@melag.de>
MIME-Version: 1.0
To: Fabio Estevam <festevam@gmail.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: Re: imx53 IPU support on 4.0.4
References: <555C86A5.2030007@melag.de> <CAOMZO5CTz4DOdB6xvrw1=i4DRsukQjtzyDMJn50znXd6uXMBUA@mail.gmail.com>
In-Reply-To: <CAOMZO5CTz4DOdB6xvrw1=i4DRsukQjtzyDMJn50znXd6uXMBUA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 20.05.2015 um 15:21 schrieb Fabio Estevam:

Hi,

>> (Haven't 4.1rc* yet, as it broke some other things for me.)
>
> What are the regressions you see?

Trouble w/ emmc/sd suddenly being ro.
Guess, something in with the corresponding APIs changed and I
didn't rebase correctly.

It's now several weeks ago (IIRC, on rc1) - I'm currently rebasing
everything again to the recent master.


cu
--
Enrico Weigelt, metux IT consult
+49-151-27565287
MELAG Medizintechnik oHG Sitz Berlin Registergericht AG Charlottenburg HRA 21333 B

Wichtiger Hinweis: Diese Nachricht kann vertrauliche oder nur für einen begrenzten Personenkreis bestimmte Informationen enthalten. Sie ist ausschließlich für denjenigen bestimmt, an den sie gerichtet worden ist. Wenn Sie nicht der Adressat dieser E-Mail sind, dürfen Sie diese nicht kopieren, weiterleiten, weitergeben oder sie ganz oder teilweise in irgendeiner Weise nutzen. Sollten Sie diese E-Mail irrtümlich erhalten haben, so benachrichtigen Sie bitte den Absender, indem Sie auf diese Nachricht antworten. Bitte löschen Sie in diesem Fall diese Nachricht und alle Anhänge, ohne eine Kopie zu behalten.
Important Notice: This message may contain confidential or privileged information. It is intended only for the person it was addressed to. If you are not the intended recipient of this email you may not copy, forward, disclose or otherwise use it or any part of it in any form whatsoever. If you received this email in error please notify the sender by replying and delete this message and any attachments without retaining a copy.
