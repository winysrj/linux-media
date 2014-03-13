Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:47109 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752682AbaCMV4g (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Mar 2014 17:56:36 -0400
Message-ID: <5322298F.8050404@iki.fi>
Date: Thu, 13 Mar 2014 23:56:31 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH] e4000/rtl2832u_sdr: use V4L2 subdev to pass V4L2 control
 handler
References: <1394743454-18124-1-git-send-email-crope@iki.fi> <1394743454-18124-2-git-send-email-crope@iki.fi> <20140313182451.4aa2f7a4@samsung.com>
In-Reply-To: <20140313182451.4aa2f7a4@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 13.03.2014 23:24, Mauro Carvalho Chehab wrote:
> Em Thu, 13 Mar 2014 22:44:14 +0200
> Antti Palosaari <crope@iki.fi> escreveu:
>
>> Exporting resources using EXPORT_SYMBOL from plain I2C driver is bad
>> idea. Use V4L2 subdev instead. Functionality is now quite likely as
>> is done in V4L2 API.
>
> Much better!


OK, rebasing tree...

Antti


-- 
http://palosaari.fi/
