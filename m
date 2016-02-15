Return-path: <linux-media-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:54543 "EHLO ni.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751471AbcBOOZs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Feb 2016 09:25:48 -0500
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>,
	Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Subject: Re: [PATCH 0/12] TW686x driver
References: <m337tif6om.fsf@t19.piap.pl> <56B872C0.1050200@xs4all.nl>
Date: Mon, 15 Feb 2016 15:25:45 +0100
In-Reply-To: <56B872C0.1050200@xs4all.nl> (Hans Verkuil's message of "Mon, 8
	Feb 2016 11:49:36 +0100")
Message-ID: <m3twlaqcd2.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil <hverkuil@xs4all.nl> writes:

> Please repost as a single patch. Also make sure it is based on the latest
> media_tree master branch.
>
> Your current patch series breaks bisectability (basically, after patch 1 it
> won't compile since it's not using vb2_v4l2_buffer yet).
>
> Also, for new drivers we generally don't care about the history, we prefer a
> single patch. That makes it easier to review as well.

No problem. I posted incremental patches to help with (incremental)
review.
-- 
Krzysztof Halasa

Industrial Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
