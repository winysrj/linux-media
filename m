Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:50623 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752583AbZKRWYe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Nov 2009 17:24:34 -0500
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"hverkuil@xs4all.nl" <hverkuil@xs4all.nl>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>
Date: Wed, 18 Nov 2009 16:24:36 -0600
Subject: RE: [PATCH v3] V4L - Adding Digital Video Timings APIs
Message-ID: <A69FA2915331DC488A831521EAE36FE40155A511F8@dlee06.ent.ti.com>
References: <1258576711-7809-1-git-send-email-m-karicheri2@ti.com>
 <20091118124841.44d86b50.randy.dunlap@oracle.com>
In-Reply-To: <20091118124841.44d86b50.randy.dunlap@oracle.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Randy,

Thanks for your comments...


>
>Make sure that these ioctls (range) are added to/included in
>Documentation/ioctl/ioctl-number.txt .
>
There is separate document for v4l2 APIs. These ioctls are 
added to that (See my patch with similar title)

>Hm, are those supposed to be small 'v' instead of large 'V'?

It is large 'V' not 'v'. Please check videodev2.h for other ioctls.
I will take care of other comments that you have made.

Murali
>
>
>---
>~Randy

