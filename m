Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:42106
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751408AbdAYPbR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Jan 2017 10:31:17 -0500
Date: Wed, 25 Jan 2017 13:31:10 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Helen Koike <helen.koike@collabora.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        laurent.pinchart@ideasonboard.com, jgebben@codeaurora.org,
        Helen Fornazier <helen.fornazier@gmail.com>
Subject: Re: [PATCH v6] [media] vimc: Virtual Media Controller core, capture
 and sensor
Message-ID: <20170125133110.5b8ea573@vento.lan>
In-Reply-To: <20170125130345.GD7139@valkosipuli.retiisi.org.uk>
References: <ee909db9-eb2b-d81a-347a-fe12112aa1cf@xs4all.nl>
        <37dc3fa2c020c30f8ced9749f81394d585a37ec1.1473018878.git.helen.koike@collabora.com>
        <20170125130345.GD7139@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I won't be doing a review on it yet... I'll try to do it on the next
version. Just a quick notice:

Em Wed, 25 Jan 2017 15:03:46 +0200
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

> > + * Copyright (C) 2016 Helen Koike F. <helen.fornazier@gmail.com>  
> 
> 2017 might be used now.

Please keep 2016 as the year you did the initial development. It
makes sense to change it to:
	2016-2017

In order to reflect that you're also doing some work on it this year,
but preserving the initial date is important, IMHO.

-- 
Thanks,
Mauro
