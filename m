Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:54086 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754189AbeDXJ5x (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Apr 2018 05:57:53 -0400
Subject: Re: [PATCH v3 0/7] TDA998x CEC support
To: Russell King - ARM Linux <linux@armlinux.org.uk>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-media@vger.kernel.org
References: <20180409121529.GA31403@n2100.armlinux.org.uk>
 <a3c8c61a-83fa-5363-0065-fe22c6bf77fe@xs4all.nl>
 <20180424094244.GK16141@n2100.armlinux.org.uk>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <c663c629-3be3-cad8-ab44-b761fbb7b10a@xs4all.nl>
Date: Tue, 24 Apr 2018 11:57:48 +0200
MIME-Version: 1.0
In-Reply-To: <20180424094244.GK16141@n2100.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/24/18 11:42, Russell King - ARM Linux wrote:
> On Tue, Apr 24, 2018 at 11:29:42AM +0200, Hans Verkuil wrote:
>> On 04/09/18 14:15, Russell King - ARM Linux wrote:
>>> Hi,
>>>
>>> This patch series adds CEC support to the DRM TDA998x driver.  The
>>> TDA998x family of devices integrate a TDA9950 CEC at a separate I2C
>>> address from the HDMI encoder.
>>>
>>> Implementation of the CEC part is separate to allow independent CEC
>>> implementations, or independent HDMI implementations (since the
>>> TDA9950 may be a separate device.)
>>
>> Reviewed, looks good.
> 
> Thanks!  If we need to rework the calibration GPIO stuff for BB, we can
> do that in a later patch.
> 

Yes, I'll see if I can spend a bit of time on that next week.

Regards,

	Hans
