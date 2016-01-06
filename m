Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:37314 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753160AbcAFKqo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 6 Jan 2016 05:46:44 -0500
Subject: Re: [PATCH 07/10] [media] tvp5150: Add device tree binding document
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <1451910332-23385-1-git-send-email-javier@osg.samsung.com>
 <1451910332-23385-8-git-send-email-javier@osg.samsung.com>
 <2787681.imkQ5NT8Qm@avalon>
From: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Enrico Butera <ebutera@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Enric Balletbo i Serra <eballetbo@gmail.com>,
	Rob Herring <robh+dt@kernel.org>,
	Eduard Gavin <egavinc@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org
Message-ID: <568CF08B.6080107@osg.samsung.com>
Date: Wed, 6 Jan 2016 07:46:35 -0300
MIME-Version: 1.0
In-Reply-To: <2787681.imkQ5NT8Qm@avalon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Laurent,

On 01/06/2016 07:39 AM, Laurent Pinchart wrote:
> Hi Javier,
> 
> Thank you for the patch.
>

Thanks a lot for your feedback.

[snip]

>> +
>> +Optional Properties:
>> +- powerdown-gpios: phandle for the GPIO connected to the PDN pin, if any.
> 
> The signal is called PDN in the datasheet, so it might make sense to call this 
> pdn-gpios. I have no strong opinion on this, I'll let you decide what you 
> think is best.
>

Yes, I wondered if the convention was to use a descriptive name or the one
used in the datasheet but Documentation/devicetree/bindings/gpio/gpio.txt
says nothing about it.

I'll change it to pdn-gpios since it could be easier to match with the doc.

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
