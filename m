Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:58705 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726035AbeJKPxX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 11 Oct 2018 11:53:23 -0400
Message-ID: <1539246426.3467.1.camel@pengutronix.de>
Subject: Re: [RFC] Informal meeting during ELCE to discuss userspace support
 for stateless codecs
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Nicolas Dufresne <nicolas@ndufresne.ca>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Date: Thu, 11 Oct 2018 10:27:06 +0200
In-Reply-To: <b9b2f5ea-8593-d1bf-6d4f-c2efddaa7002@xs4all.nl>
References: <b9b2f5ea-8593-d1bf-6d4f-c2efddaa7002@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2018-10-08 at 13:53 +0200, Hans Verkuil wrote:
> Hi all,
> 
> I would like to meet up somewhere during the ELCE to discuss userspace support
> for stateless (and perhaps stateful as well?) codecs.
> 
> It is also planned as a topic during the summit, but I would prefer to prepare
> for that in advance, esp. since I myself do not have any experience writing
> userspace SW for such devices.
> 
> Nicolas, it would be really great if you can participate in this meeting
> since you probably have the most experience with this by far.
> 
> Looking through the ELCE program I found two timeslots that are likely to work
> for most of us (because the topics in the program appear to be boring for us
> media types!):
> 
> Tuesday from 10:50-15:50
> 
> or:
> 
> Monday from 15:45 onward
> 
> My guess is that we need 2-3 hours or so. Hard to predict.
> 
> The basic question that I would like to have answered is what the userspace
> component should look like? libv4l-like plugin or a library that userspace can
> link with? Do we want more general support for stateful codecs as well that deals
> with resolution changes and the more complex parts of the codec API?
> 
> I've mailed this directly to those that I expect are most interested in this,
> but if someone want to join in let me know.
> 
> I want to keep the group small though, so you need to bring relevant experience
> to the table.

I'd like to join in as well. CODA960 on i.MX6 has a stateless JPEG codec
that I'd like to support using the stateless codec API.

regards
Philipp
