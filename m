Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:46103 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751092AbcAYPEc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jan 2016 10:04:32 -0500
Subject: Re: [PATCH v2 00/10] [media] tvp5150: add MC and DT support
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-kernel@vger.kernel.org
References: <1452170810-32346-1-git-send-email-javier@osg.samsung.com>
 <56A63849.8040004@xs4all.nl>
Cc: devicetree@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Enrico Butera <ebutera@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Enric Balletbo i Serra <eballetbo@gmail.com>,
	Rob Herring <robh+dt@kernel.org>,
	Eduard Gavin <egavinc@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org
From: Javier Martinez Canillas <javier@osg.samsung.com>
Message-ID: <56A63978.5080204@osg.samsung.com>
Date: Mon, 25 Jan 2016 12:04:24 -0300
MIME-Version: 1.0
In-Reply-To: <56A63849.8040004@xs4all.nl>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hans,

On 01/25/2016 11:59 AM, Hans Verkuil wrote:
> On 01/07/2016 01:46 PM, Javier Martinez Canillas wrote:
>
> FYI: this patch series no longer applies after the merge of 4.5-rc1.
>

That's actually not true :)

I based this series on top of Mauro's latest MC next gen work since I
knew that it was quite unlikely that this set would be applied before
those changes. Sorry for missing mentioning that in the cover letter.
  
> So besides fixing Mauro's comment for 3/10 you need to respin this series
> anyway.
>

In fact, these patches besides 3/10 are already applied in media/master.

> Regards,
>
> 	Hans
>
  
Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
