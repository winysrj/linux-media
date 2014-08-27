Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:44729 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754152AbaH0HNZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Aug 2014 03:13:25 -0400
Received: by mail-oi0-f49.google.com with SMTP id u20so11289020oif.8
        for <linux-media@vger.kernel.org>; Wed, 27 Aug 2014 00:13:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1407153257.3979.30.camel@paszta.hi.pengutronix.de>
References: <CAL8zT=jms4ZAvFE3UJ2=+sLXWDsgz528XUEdXBD9HtvOu=56-A@mail.gmail.com>
 <20140728185949.GS13730@pengutronix.de> <53D6BD8E.7000903@gmail.com>
 <CAJ+vNU2EiTcXM-CWTLiC=4c9j-ovGFooz3Mr82Yq_6xX1u2gbA@mail.gmail.com> <1407153257.3979.30.camel@paszta.hi.pengutronix.de>
From: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
Date: Wed, 27 Aug 2014 09:13:10 +0200
Message-ID: <CAL8zT=iFatVPc1X-ngQPeY=DtH0GWH76UScVVRrHdk9L27xw5Q@mail.gmail.com>
Subject: Re: i.MX6 status for IPU/VPU/GPU
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Tim Harvey <tharvey@gateworks.com>,
	Robert Schwebel <r.schwebel@pengutronix.de>,
	linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	Steve Longerbeam <slongerbeam@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Phillip,

2014-08-04 13:54 GMT+02:00 Philipp Zabel <p.zabel@pengutronix.de>:
> We should take this step by step. First I'd like to get Steve's ipu-v3
> series in, those don't have any major issues and are a prerequisite for
> the media patches anyway.
>
> The capture patches had a few more issues than just missing media device
> support. But this is indeed the biggest one, especially where it
> involves a userspace interface that we don't want to have to support in
> the future.
> My RFC series wasn't without problems either. I'll work on the IPU this
> week and then post another RFC.

Any news about this ? I saw your patchset from june 12th.
What is the current status of this RFC and is there a way to help
integrating/testing it ? Do you have a public git repository I can
fetch and merge in order to test ?


Thanks,
JM
