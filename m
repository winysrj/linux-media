Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.melag.de ([217.6.74.107]:41045 "EHLO mail.melag.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755435AbbE2JCk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 May 2015 05:02:40 -0400
Message-ID: <55682B2C.4030502@melag.de>
Date: Fri, 29 May 2015 11:02:36 +0200
From: "Enrico Weigelt, metux IT consult" <weigelt@melag.de>
MIME-Version: 1.0
To: Robert Schwebel <r.schwebel@pengutronix.de>
CC: Philipp Zabel <p.zabel@pengutronix.de>,
	ML dri-devel <dri-devel@lists.freedesktop.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH v2 2/5] gpu: ipu-v3: Add mem2mem image conversion support
 to IC
References: <1426674173-17088-1-git-send-email-p.zabel@pengutronix.de> <1426674173-17088-3-git-send-email-p.zabel@pengutronix.de> <CAH-u=82OC=r+kgyHpvQFLMwrBiuaV_V3Q7W5FKV3eK4o_n0-HA@mail.gmail.com> <5566D92F.8090802@melag.de> <1432809845.3228.25.camel@pengutronix.de> <5566FC95.3020000@melag.de> <1432814386.3228.51.camel@pengutronix.de> <5567528C.7010903@melag.de> <20150528175448.GO32610@pengutronix.de>
In-Reply-To: <20150528175448.GO32610@pengutronix.de>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 28.05.2015 um 19:54 schrieb Robert Schwebel:

>> By the way: i still have some your older patches (2012) in my tree,
>> eg. some mediabus, camara, display timing stuff, etc ... not sure
>> whether I really need them for my device.
>>
>> Should I post them to linux-media list for review?
>
> No. That's all old stuff and has developed quite a lot since then. We'll
> post new series here on the lists when they are ready for mainline.

Great :)

Do you have them on some public repo, so I can give 'em a try ?


--mtx

--
Enrico Weigelt, metux IT consult
+49-151-27565287
MELAG Medizintechnik oHG Sitz Berlin Registergericht AG Charlottenburg HRA 21333 B

Wichtiger Hinweis: Diese Nachricht kann vertrauliche oder nur für einen begrenzten Personenkreis bestimmte Informationen enthalten. Sie ist ausschließlich für denjenigen bestimmt, an den sie gerichtet worden ist. Wenn Sie nicht der Adressat dieser E-Mail sind, dürfen Sie diese nicht kopieren, weiterleiten, weitergeben oder sie ganz oder teilweise in irgendeiner Weise nutzen. Sollten Sie diese E-Mail irrtümlich erhalten haben, so benachrichtigen Sie bitte den Absender, indem Sie auf diese Nachricht antworten. Bitte löschen Sie in diesem Fall diese Nachricht und alle Anhänge, ohne eine Kopie zu behalten.
Important Notice: This message may contain confidential or privileged information. It is intended only for the person it was addressed to. If you are not the intended recipient of this email you may not copy, forward, disclose or otherwise use it or any part of it in any form whatsoever. If you received this email in error please notify the sender by replying and delete this message and any attachments without retaining a copy.
