Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f43.google.com ([209.85.214.43]:45639 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753207Ab3GGVuf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Jul 2013 17:50:35 -0400
Received: by mail-bk0-f43.google.com with SMTP id jm2so1580229bkc.2
        for <linux-media@vger.kernel.org>; Sun, 07 Jul 2013 14:50:34 -0700 (PDT)
Message-ID: <51D9E2A6.2070002@gmail.com>
Date: Sun, 07 Jul 2013 23:50:30 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org,
	Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Pete Eberlein <pete@sensoray.com>
Subject: Re: [RFC PATCH 0/5] Matrix and Motion Detection support
References: <1372422454-13752-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1372422454-13752-1-git-send-email-hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On 06/28/2013 02:27 PM, Hans Verkuil wrote:
> This patch series adds support for matrices and motion detection and
> converts the solo6x10 driver to use these new APIs.
>
> See the RFCv2 for details on the motion detection API:
>
> http://www.mail-archive.com/linux-media@vger.kernel.org/msg62085.html
>
> And this RFC for details on the matrix API (which superseeds the v4l2_md_blocks
> in the RFC above):
>
> http://permalink.gmane.org/gmane.linux.drivers.video-input-infrastructure/65195
>
> I have tested this with the solo card, both global motion detection and
> regional motion detection, and it works well.
>
> There is no documentation for the new APIs yet (other than the RFCs). I would
> like to know what others think of this proposal before I start work on the
> DocBook documentation.

These 3 ioctls look pretty generic and will likely allow us to handle wide
range of functionalities, similarly to what the controls framework does 
today.

What I don't like in the current trend of the V4L2 API development 
though is
that we have seemingly separate APIs for configuring integers, rectangles,
matrices, etc. And interactions between those APIs sometimes happen to be
not well defined.

I'm not opposed to having this matrix API, but I would _much_ more like to
see it as a starting point of a more powerful API, that would allow to 
model
dependencies between parameters being configured and the objects more
explicitly and freely (e.g. case of the per buffer controls), that would
allow to pass a list of commands to the hardware for atomic 
re-configurations,
that would allow to create hardware configuration contexts, etc., etc.

But it's all song of future, requires lots of effort, founding and takes
engineers with significant experience.

As it likely won't happen soon I guess we can proceed with the matrix API
for now.

> My tentative goal is to get this in for 3.12. Once this is in place the solo
> and go7007 drivers can be moved out of staging into the mainline since this is
> the only thing holding them back.

--
Regards,
Sylwester
