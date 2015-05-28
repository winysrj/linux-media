Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.melag.de ([217.6.74.107]:37457 "EHLO mail.melag.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753637AbbE1LFB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 May 2015 07:05:01 -0400
Message-ID: <5566F652.9040208@melag.de>
Date: Thu, 28 May 2015 13:04:50 +0200
From: "Enrico Weigelt, metux IT consult" <weigelt@melag.de>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
CC: <linux-media@vger.kernel.org>, <hverkuil@xs4all.nl>,
	<laurent.pinchart@ideasonboard.com>
Subject: Re: [RFC] Media controller entity information property API
References: <20150527133933.GB25595@valkosipuli.retiisi.org.uk>	<20150527121513.18dca204@recife.lan> <20150528062701.1e4f5917@recife.lan>
In-Reply-To: <20150528062701.1e4f5917@recife.lan>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 28.05.2015 um 11:27 schrieb Mauro Carvalho Chehab:

Hi folks,

just subscribed to the list, so I might have missed something ....

<snip>

>>> Constructing unique names that are human readable, stable, unique and fit to
>>> 31 characters reserved for the purpose is not thought to be possible: device
>>> bus string that would be in some cases enough to uniquely identify a device
>>> any be longer than that. On hot-pluggable busses e.g. a serial number is
>>> needed.

Dont we have any chance of lifting that restriction ?
 From a userland PoV, I'd really like to see them via path names
(and actually access them directly via their own files)

>>> The structure of the properties tree can be non-trivial. This RFC defines a
>>> text representation format of the tree to facilitate discussing and
>>> documenting the tree structure separately from its binary representation
>>> used in IOCTL calls. The terms are used elsewhere in the document.

Does it have to be an IOTCTL ?

IOCTL have the unpleasant side effect, that they're hard to transport
via network filesystems (in the end, would need special protocol
extensions for each single one - assuming we can *safely* detect,
which IOCTL really was called)

Instead I'd prefer some pure filesystem-based approach - like @Plan9 or
sysfs.


cu
--
Enrico Weigelt, metux IT consult
+49-151-27565287
MELAG Medizintechnik oHG Sitz Berlin Registergericht AG Charlottenburg HRA 21333 B

Wichtiger Hinweis: Diese Nachricht kann vertrauliche oder nur für einen begrenzten Personenkreis bestimmte Informationen enthalten. Sie ist ausschließlich für denjenigen bestimmt, an den sie gerichtet worden ist. Wenn Sie nicht der Adressat dieser E-Mail sind, dürfen Sie diese nicht kopieren, weiterleiten, weitergeben oder sie ganz oder teilweise in irgendeiner Weise nutzen. Sollten Sie diese E-Mail irrtümlich erhalten haben, so benachrichtigen Sie bitte den Absender, indem Sie auf diese Nachricht antworten. Bitte löschen Sie in diesem Fall diese Nachricht und alle Anhänge, ohne eine Kopie zu behalten.
Important Notice: This message may contain confidential or privileged information. It is intended only for the person it was addressed to. If you are not the intended recipient of this email you may not copy, forward, disclose or otherwise use it or any part of it in any form whatsoever. If you received this email in error please notify the sender by replying and delete this message and any attachments without retaining a copy.
