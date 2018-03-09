Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:50912 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750939AbeCIL5w (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Mar 2018 06:57:52 -0500
Subject: Re: [PATCH v2 1/3] staging: xm2mvscale: Driver support for Xilinx M2M
 Video Scaler
To: Greg KH <gregkh@linuxfoundation.org>,
        Rohit Athavale <rohit.athavale@xilinx.com>
Cc: devel@driverdev.osuosl.org, linux-media@vger.kernel.org
References: <1519252996-787-1-git-send-email-rohit.athavale@xilinx.com>
 <1519252996-787-2-git-send-email-rohit.athavale@xilinx.com>
 <20180222134658.GB19182@kroah.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <1315ef81-15f1-5bc9-eff9-aaa12e70738a@xs4all.nl>
Date: Fri, 9 Mar 2018 12:57:49 +0100
MIME-Version: 1.0
In-Reply-To: <20180222134658.GB19182@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 22/02/18 14:46, Greg KH wrote:
> On Wed, Feb 21, 2018 at 02:43:14PM -0800, Rohit Athavale wrote:
>> This commit adds driver support for the pre-release Xilinx M2M Video
>> Scaler IP. There are three parts to this driver :
>>
>>  - The Hardware/IP layer that reads and writes register of the IP
>>    contained in the scaler_hw_xm2m.c
>>  - The set of ioctls that applications would need to know contained
>>    in ioctl_xm2mvsc.h
>>  - The char driver that consumes the IP layer in xm2m_vscale.c
>>
>> Signed-off-by: Rohit Athavale <rohit.athavale@xilinx.com>
>> ---
> 
> I need an ack from the linux-media maintainers before I can consider
> this for staging, as this really looks like an "odd" video driver...

This should definitely use the V4L2 API. I guess it could be added
to staging/media with a big fat TODO that this should be converted to
the V4L2 mem2mem framework.

But it makes no sense to re-invent the V4L2 streaming API :-)

drivers/media/platform/mx2_emmaprp.c does something similar to this.
It's a little bit outdated (not using the latest m2m helper functions)
but it is a good starting point.

So for this series:

Nacked-by: Hans Verkuil <hans.verkuil@cisco.com>

If this was added to drivers/staging/media instead and with an updated
TODO, then we can accept it, but we need to see some real effort afterwards
to switch this to the right API. Otherwise it will be removed again
after a few kernel cycles.

Regards,

	Hans
