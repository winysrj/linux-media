Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:47006 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726646AbeJIDcI (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 8 Oct 2018 23:32:08 -0400
Subject: Re: [RFC] Informal meeting during ELCE to discuss userspace support
 for stateless codecs
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Nicolas Dufresne <nicolas@ndufresne.ca>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <b9b2f5ea-8593-d1bf-6d4f-c2efddaa7002@xs4all.nl>
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <fb778f04-a16b-8f1e-e2d6-c94870e00998@ideasonboard.com>
Date: Mon, 8 Oct 2018 21:18:34 +0100
MIME-Version: 1.0
In-Reply-To: <b9b2f5ea-8593-d1bf-6d4f-c2efddaa7002@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans

On 08/10/18 12:53, Hans Verkuil wrote:
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

Depending on time and availability I might like to join in on this.
Consider me non-essential however and if I'm not around don't wait for me.

I have a desire to work on the codecs for Renesas (although it seems
unlikely to be possible due to licensing issues)


> I want to keep the group small though, so you need to bring relevant experience
> to the table.

I can offer outdated experience managing the codec firmwares, and
decode/encode stacks for the ST SDK2 player implementation.

However that was 4 or 5 years ago - so I now deny all knowledge of
knowing anything from back then :-)

--
Regards

Kieran
