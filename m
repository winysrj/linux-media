Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk1-f180.google.com ([209.85.222.180]:43059 "EHLO
        mail-qk1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725789AbeJJItk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 10 Oct 2018 04:49:40 -0400
Received: by mail-qk1-f180.google.com with SMTP id 12-v6so2219186qkj.10
        for <linux-media@vger.kernel.org>; Tue, 09 Oct 2018 18:29:55 -0700 (PDT)
Message-ID: <65498b0fd8467e4fbd4518c6fd21e30624f7ce51.camel@ndufresne.ca>
Subject: Re: [RFC] Informal meeting during ELCE to discuss userspace support
 for stateless codecs
From: Nicolas Dufresne <nicolas@ndufresne.ca>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Date: Tue, 09 Oct 2018 21:29:53 -0400
In-Reply-To: <b9b2f5ea-8593-d1bf-6d4f-c2efddaa7002@xs4all.nl>
References: <b9b2f5ea-8593-d1bf-6d4f-c2efddaa7002@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le lundi 08 octobre 2018 à 13:53 +0200, Hans Verkuil a écrit :
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

Both works for me.

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
> 
> Regards,
> 
> 	Hans
