Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:1965 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711AbaCTIHz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Mar 2014 04:07:55 -0400
Message-ID: <532AA1CA.6080308@xs4all.nl>
Date: Thu, 20 Mar 2014 09:07:38 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	LMML <linux-media@vger.kernel.org>, media-workshop@linuxtv.org
Subject: Re: [ANNOUNCE] media mini-summit on May, 2 in San Jose
References: <20140319160227.27a37e90@samsung.com>
In-Reply-To: <20140319160227.27a37e90@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 03/19/2014 08:02 PM, Mauro Carvalho Chehab wrote:
> As discussed on our IRC #v4l channels, most of the core developers will be
> in San Jose - CA - USA for the Embedded Linux Conference.
> 
> There are several subjects that we've been discussing those days that
> require a face to face meeting.
> 
> So, We'll be doing a media mini-summit on May, 2 (Friday) at Marriott San
> Jose. Eventually, we may also schedule some BoFs during the week, if needed.
> 
> In order to properly organize the event, I need the name of the
> developers interested on joining us, plus the themes proposed for
> discussions.

I'm in.

Topics:

- V4L2 API ambiguities, based on the recent work I've been doing with vivi and
  v4l2-compliance. This will include any ambiguities relating to cropping,
  composing and scaling.

- I might have to discuss topics relating to the addition of compound types to
  the control framework.

- Per-frame settings aka configuration stores. This feature is necessary for
  Android's libcamera 3.

- Optional: a short demo of the various test drivers and test tools I'm
  developing.

Regards,

	Hans

> As usual, we'll be using the media-workshop@linuxtv.org ML for specific
> discussions about that, so the ones interested on participate are
> requested to subscribe it.
> 
> Thanks!
> Mauro
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
