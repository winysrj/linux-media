Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58894 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342AbbCZRJH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Mar 2015 13:09:07 -0400
Message-ID: <1427389745.3599.23.camel@pengutronix.de>
Subject: Re: [RFC] v4l2-ctl: don't exit on VIDIOC_QUERYCAP error for
 subdevices
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Date: Thu, 26 Mar 2015 18:09:05 +0100
In-Reply-To: <5514386C.2020305@xs4all.nl>
References: <1427361704-32456-1-git-send-email-p.zabel@pengutronix.de>
	 <5514386C.2020305@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Donnerstag, den 26.03.2015, 09:48 -0700 schrieb Hans Verkuil:
> On 03/26/2015 02:21 AM, Philipp Zabel wrote:
> > Subdevice nodes don't implement VIDIOC_QUERYCAP. This check doesn't
> > allow any operations on v42-subdev nodes, such as setting EDID.
> 
> Nack because I'm going to create a proper VIDIOC_SUBDEV_QUERYCAP for
> subdevs. I'm planning to work on this next week.

Oh great, thanks for the heads-up.

regards
Philipp

