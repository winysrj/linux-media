Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:2935 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966070AbaFTWH4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Jun 2014 18:07:56 -0400
Message-ID: <53A4B097.3050802@xs4all.nl>
Date: Sat, 21 Jun 2014 00:07:19 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Gregor Jasny <gjasny@googlemail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: Time for v4l-utils 1.2 release?
References: <53A49A11.2010502@googlemail.com>
In-Reply-To: <53A49A11.2010502@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/20/2014 10:31 PM, Gregor Jasny wrote:
> Hello,
> 
> It's been 11 months since the 1.0.0 release. What do you think about
> releasing HEAD? Do you have any pending commits?

I've got two patches from Laurent pending that ensure that the 'installed
kernel headers' are used. I plan on processing those on Monday. After that
I think it's OK to do a release.

Mauro, did you look at my email where I suggest to remove three apps from
contrib? If you agree with that, then I can do that Monday as well.

Regards,

	Hans

> Mauro, you tried to re-license the DVB library. What's the status there?
> 
> Thanks,
> Gregor
> 

