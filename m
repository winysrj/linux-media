Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-3.cisco.com ([144.254.224.146]:65315 "EHLO
	ams-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999Ab2IEI2d (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Sep 2012 04:28:33 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Jun Nie <niej0001@gmail.com>
Subject: Re: [Workshop-2011] Media summit/KS-2012 proposals
Date: Wed, 5 Sep 2012 10:28:30 +0200
Cc: workshop-2011@linuxtv.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <20120713173708.GB17109@thunk.org> <201208061535.59616.hverkuil@xs4all.nl> <CAGA24MKVVfT7BDGus+spj9CZWctS1YLdvOM5eWOGBdgeGqmnHw@mail.gmail.com>
In-Reply-To: <CAGA24MKVVfT7BDGus+spj9CZWctS1YLdvOM5eWOGBdgeGqmnHw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209051028.30258.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed 5 September 2012 10:04:41 Jun Nie wrote:
> Is there any summary for this summit or presentation material? I am
> looking forward for some idea on CEC. It is really complex in
> functionality.
> Maybe other guys is expecting simiar fruite from summit too.

Yes, there will be a summit report. It's not quite finished yet, I think.

With respect to CEC we had some useful discussions. It will have to be a
new class of device (/dev/cecX), so the userspace API will be separate from
drm or v4l.

And the kernel will have to take care of the core CEC protocol w.r.t. control
and discovery due to the HDMI 1.4a requirements.

I plan on starting work on this within 1-2 weeks.

My CEC presentation can be found here:

http://hverkuil.home.xs4all.nl/presentations/v4l2-workshop-cec.odp

Regards,

	Hans
