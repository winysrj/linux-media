Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56246 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753924AbbGJLme (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jul 2015 07:42:34 -0400
Message-ID: <1436528552.3850.44.camel@pengutronix.de>
Subject: Re: [RFC v04] Driver for Toshiba TC358743
From: Philipp Zabel <p.zabel@pengutronix.de>
To: matrandg@cisco.com
Cc: linux-media@vger.kernel.org, hansverk@cisco.com,
	kernel@pengutronix.de
Date: Fri, 10 Jul 2015 13:42:32 +0200
In-Reply-To: <1436431547-27319-1-git-send-email-matrandg@cisco.com>
References: <1436431547-27319-1-git-send-email-matrandg@cisco.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mats,

thanks for the update! With a few changes on top
Tested-by: Philipp Zabel <p.zabel@pengutronix.de>

Am Donnerstag, den 09.07.2015, 10:45 +0200 schrieb matrandg@cisco.com:
> From: Mats Randgaard <matrandg@cisco.com>
> 
> Improvements based on feedback from Hans Verkuil:
> - Use functions in linux/hdmi.h to print AVI info frames
> - Replace private format change event with V4L2_EVENT_SOURCE_CHANGE
> - Rewrite set_fmt/get_fmt
> - Remove V4L2_SUBDEV_FL_HAS_DEVNODE

I had to add that back again together with initializing the media entity
to make it configurable with media-ctl --set-dv.

regards
Philipp

