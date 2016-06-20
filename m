Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:37677 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754556AbcFTPfC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2016 11:35:02 -0400
Subject: Re: [PATCH 1/6] v4l: Correct the ordering of LSBs of the 10-bit raw
 packed formats
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <1464353080-18300-1-git-send-email-sakari.ailus@linux.intel.com>
 <1464353080-18300-2-git-send-email-sakari.ailus@linux.intel.com>
 <576807DC.1060902@xs4all.nl>
From: Sakari Ailus <sakari.ailus@linux.intel.com>
Message-ID: <57680D08.9090304@linux.intel.com>
Date: Mon, 20 Jun 2016 18:34:32 +0300
MIME-Version: 1.0
In-Reply-To: <576807DC.1060902@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Hans Verkuil wrote:
> On 05/27/2016 02:44 PM, Sakari Ailus wrote:
>> The 10-bit packed raw bayer format documented that the data of the first
>> pixel of a four-pixel group was found in the first byte and the two
>> highest bits of the fifth byte. This was not entirely correct. The two
>> bits in the fifth byte are the two lowest bits. The second pixel occupies
>> the second byte and third and fourth least significant bits and so on.
> 
> This is used by the uvc driver. Has this been verified against a UVC webcam
> that supports this format? Laurent, do you have such a device?

I bet Laurent hasn't got one. Guennadi, could you comment on this?

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
