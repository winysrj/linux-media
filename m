Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:34113 "EHLO
        mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756091AbdABREf (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 2 Jan 2017 12:04:35 -0500
Received: by mail-oi0-f49.google.com with SMTP id 3so302891462oih.1
        for <linux-media@vger.kernel.org>; Mon, 02 Jan 2017 09:04:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <3b8ed13c-a23e-dc2b-0e31-1288ea3f562a@xs4all.nl>
References: <1476466481-24030-1-git-send-email-p.zabel@pengutronix.de>
 <20161019213026.GU9460@valkosipuli.retiisi.org.uk> <CAH-u=807nRYzza0kTfOMv1AiWazk6FGJyz6W5_bYw7v9nOrccA@mail.gmail.com>
 <20161229205113.j6wn7kmhkfrtuayu@pengutronix.de> <7350daac-14ee-74cc-4b01-470a375613a3@denx.de>
 <c38d80aa-5464-1e9d-e11a-f54716fdb565@mentor.com> <CAH-u=83LDyfcErrxaDNN2+w7ZK56v9cJkvBL864ofxiBWrmBSg@mail.gmail.com>
 <3b8ed13c-a23e-dc2b-0e31-1288ea3f562a@xs4all.nl>
From: Fabio Estevam <festevam@gmail.com>
Date: Mon, 2 Jan 2017 15:04:34 -0200
Message-ID: <CAOMZO5DU+0Grvnd-yOsLrf=4mOw6hgsN27jwPmU6GuFkcjtckw@mail.gmail.com>
Subject: Re: [PATCH v2 00/21] Basic i.MX IPUv3 capture support
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Jean-Michel Hautbois <jean-michel.hautbois@veo-labs.com>,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        Marek Vasut <marex@denx.de>,
        Robert Schwebel <r.schwebel@pengutronix.de>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Gary Bisson <gary.bisson@boundarydevices.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jan 2, 2017 at 12:45 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:

> Steve's series is definitely preferred from my point of view. The feature
> set is clearly superior to Philipp's driver.
>
> I plan on reviewing Steve's series soonish but a quick scan didn't see
> anything
> suspicious. The code looks clean, and I am leaning towards getting this in
> sooner
> rather than later, so if you have the time to work on this, then go for it!

This is good news!

I had a chance to test Steve's series on a mx6qsabresd and it worked fine.

Thanks
