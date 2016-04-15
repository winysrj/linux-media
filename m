Return-path: <linux-media-owner@vger.kernel.org>
Received: from mo1.mail-out.ovh.net ([178.32.228.1]:55034 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbcDOMSU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Apr 2016 08:18:20 -0400
Received: from mail175.ha.ovh.net (b9.ovh.net [213.186.33.59])
	by mo1.mail-out.ovh.net (Postfix) with SMTP id D5582104427E
	for <linux-media@vger.kernel.org>; Fri, 15 Apr 2016 10:42:40 +0200 (CEST)
Subject: Re: [PATCH] Add GS1662 driver (a SPI video serializer)
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Jean-Michel Hautbois <jean-michel.hautbois@veo-labs.com>
References: <56FE9B7F.7060206@nexvision.fr> <56FEA192.9020303@nexvision.fr>
 <CAH-u=83J0kJzaV5Mqz7Zt76JgfVz6M_v_nhzPEeqwcRCRKm8VQ@mail.gmail.com>
 <57022D5A.5080704@nexvision.fr>
 <CAH-u=82LeD9TWrHpntjOmV9g-6rBLuboGy6RUsasSWBBtpyQJw@mail.gmail.com>
 <5710A872.6050509@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Charles-Antoine Couret <charles-antoine.couret@nexvision.fr>
Message-ID: <5710A97E.9030104@nexvision.fr>
Date: Fri, 15 Apr 2016 10:42:38 +0200
MIME-Version: 1.0
In-Reply-To: <5710A872.6050509@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le 15/04/2016 10:38, Hans Verkuil a écrit :
> I think the media subsystem is definitely the right place for this.
> 
> I would use the cs3308.c driver as a starting point. This is also a minimal driver
> (and you can remove the code under CONFIG_VIDEO_ADV_DEBUG for your driver), but it
> uses v4l2_subdev and that makes it ready to be extended in the future, which you
> will likely need to do eventually.

Yes, I agree with that now. :)
I'm writing a new version of patch to integrate it into media subdev. It's "ready" but I need some tests to validate all behaviours.

Thanks.
Charles-Antoine Couret
