Return-path: <mchehab@pedra>
Received: from ffm.saftware.de ([83.141.3.46]:38581 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757307Ab1FIMvt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Jun 2011 08:51:49 -0400
Message-ID: <4DF0C1E2.5090202@linuxtv.org>
Date: Thu, 09 Jun 2011 14:51:46 +0200
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 00/13] Reduce the gap between DVBv5 API and the specs
References: <20110608172311.0d350ab7@pedra> <201106082259.33770.hverkuil@xs4all.nl> <4DEFEBCA.1030909@redhat.com>
In-Reply-To: <4DEFEBCA.1030909@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 06/08/2011 11:38 PM, Mauro Carvalho Chehab wrote:
> - all AUDIO*, OSD* and VIDEO* are used only by av7110 and ivtv.
> 
> - The CA* ioctls are used by core (although several are only implemented
>   inside a few drivers);

All (or most) of these ioctls (except OSD, which AFAIR has been
deprecated since v3) are used by out-of-tree drivers. av7110 and ivtv
just happen to be the only in-tree drivers supporting audio and video
decoders.

Regards,
Andreas
