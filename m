Return-path: <linux-media-owner@vger.kernel.org>
Received: from 10.mo4.mail-out.ovh.net ([188.165.33.109]:51455 "EHLO
	10.mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754537AbcDDJhW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Apr 2016 05:37:22 -0400
Received: from mail699.ha.ovh.net (b6.ovh.net [213.186.33.56])
	by mo4.mail-out.ovh.net (Postfix) with SMTP id B23541140180
	for <linux-media@vger.kernel.org>; Mon,  4 Apr 2016 11:01:16 +0200 (CEST)
Subject: Re: [PATCH] Add GS1662 driver (a SPI video serializer)
To: Jean-Michel Hautbois <jean-michel.hautbois@veo-labs.com>
References: <56FE9B7F.7060206@nexvision.fr> <56FEA192.9020303@nexvision.fr>
 <CAH-u=83J0kJzaV5Mqz7Zt76JgfVz6M_v_nhzPEeqwcRCRKm8VQ@mail.gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Charles-Antoine Couret <charles-antoine.couret@nexvision.fr>
Message-ID: <57022D5A.5080704@nexvision.fr>
Date: Mon, 4 Apr 2016 11:01:14 +0200
MIME-Version: 1.0
In-Reply-To: <CAH-u=83J0kJzaV5Mqz7Zt76JgfVz6M_v_nhzPEeqwcRCRKm8VQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le 01/04/2016 21:11, Jean-Michel Hautbois a écrit :
> Hi Charles-Antoine,
Hi,

> FIrst of all, we, on the ML, do prefer reading patches as sent by git
> send-email tool.

Ok, I will configure that.

> Next, you should add a complete description to your commit. Just
> having an object and a signed-off-by line is not enough.
Oh, I'm sorry, I don't have any idea to explicit more details. I will
find something for that.

> You also have to use the scripts/checkpatch.pl script to verify that
> everything is ok with it.
I have executed this script before to send it. And it noticed nothing about that.

> Last thing, I can't see anything related to V4L2 in your patch. It is
> just used to initialize the chip and the spi bus, that's all.
> Adding a subdev is a start, and some operations if it can do something
> else than just serializing.

Maybe I'm in the wrong list for that in fact. I didn't know this list was about V4L2 and related topics.
This driver is only to configure the component to manage the video stream in electronic card, it is not to capture video stream via V4L.

I should improve my driver to be configurable by userspace. But maybe I should submit my future patch in another ML. 

Thanks for all.
Regards,
Charles-Antoine
