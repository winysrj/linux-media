Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38356 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754915AbbDXISj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Apr 2015 04:18:39 -0400
Message-ID: <1429863515.3174.14.camel@pengutronix.de>
Subject: Re: [PATCH] [media] vivid: add 1080p capture at 2 fps and 5 fps to
 webcam emulation
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Date: Fri, 24 Apr 2015 10:18:35 +0200
In-Reply-To: <5539E615.4090902@xs4all.nl>
References: <1429797174-32474-1-git-send-email-p.zabel@pengutronix.de>
	 <5539E615.4090902@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Am Freitag, den 24.04.2015, 08:43 +0200 schrieb Hans Verkuil:
> Hi Philipp,
> 
> Thank you for the patch, but I have one question:
> 
> On 04/23/2015 03:52 PM, Philipp Zabel wrote:
> > Use the VIVID_WEBCAM_SIZES constant where appropriate and add a 1920x1080 pixel
> > frame size setting with frame rates of 2 fps and 5 fps.
> 
> Why add both 2 and 5 fps? Is there a reason why you want both of those fps values?
> 
> Just wondering.

I just wanted to quickly test 1080p at 5 fps, so I didn't change that
afterwards for the patch. 5 fps also seems like the next logical step.
webcam_intervals needs to be twice the size of webcam_sizes, the comment
above webcam_intervals told me to add two intervals for every new
element in webcam_sizes. For the second interval, I didn't think much
about the actual value. Choosing 2 fps next was probably influenced by
our monetary system.
To keep data rates similar to 720p at 10 fps and 15 fps, 1080p at 4 fps
and 6 fps, respectively, would be the better choice.

regards
Philipp

