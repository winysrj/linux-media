Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:42942 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751159AbaDJSTf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Apr 2014 14:19:35 -0400
Message-ID: <5346E0B5.6050404@iki.fi>
Date: Thu, 10 Apr 2014 21:19:33 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org
Subject: Re: [yavta PATCH 3/9] Allow supporting mem2mem devices by adding
 forced OUTPUT device type
References: <1393690690-5004-1-git-send-email-sakari.ailus@iki.fi> <1393690690-5004-4-git-send-email-sakari.ailus@iki.fi> <1418044.66HOjVbqSU@avalon>
In-Reply-To: <1418044.66HOjVbqSU@avalon>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent Pinchart wrote:
> On Saturday 01 March 2014 18:18:04 Sakari Ailus wrote:
>> The option is --output, or -o.
>
> Wouldn't it make sense to have an option to force the device type to a user-
> specified value instead of just an option for the output type ? "-o" is also
> usually used to select an output file, I'd like to keep it for that.

Sounds good. I'll use "Q" for the queue type.

-- 
Sakari Ailus
sakari.ailus@iki.fi
