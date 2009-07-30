Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:40612 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859AbZG3Ma5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jul 2009 08:30:57 -0400
Received: from epmmp1 (mailout1.samsung.com [203.254.224.24])
 by mailout1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0KNL00BYOHFKTZ@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 30 Jul 2009 21:30:56 +0900 (KST)
Received: from TNRNDGASPAPP1.tn.corp.samsungelectronics.net ([165.213.149.150])
 by mmp1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0KNL008S7HFK6B@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 30 Jul 2009 21:30:56 +0900 (KST)
Date: Thu, 30 Jul 2009 21:30:56 +0900
From: Joonyoung Shim <jy0922.shim@samsung.com>
Subject: Re: [PATCH v2 0/4] radio-si470x: separate usb and i2c interface
In-reply-to: <200907301226.10965.tobias.lorenz@gmx.net>
To: Tobias Lorenz <tobias.lorenz@gmx.net>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	kyungmin.park@samsung.com, klimov.linux@gmail.com
Message-id: <4A719280.3030306@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7BIT
References: <4A5C137A.2010104@samsung.com>
 <200907301226.10965.tobias.lorenz@gmx.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 7/30/2009 7:26 PM, Tobias Lorenz wrote:
> Hi,
> 
>> I send the radio-si470x patches worked on http://linuxtv.org/hg/v4l-dvb.
>> The patches is updated to version 2.
> 
> The patchset looks good. I'll give my feedback in the following mails.
> 
>> Tobias informed me the base code for seperating at 
>> http://linuxtv.org/hg/~tlorenz/v4l-dvb of Tobias repository in above
>> mail, i based on it, but it cannot find now at Tobias repository.
> 
> Before sending a pull request, I usually clean up the archive from any other patches.
> But nevertheless, you and me still have the I2C patches. They now reached a quality to finally bring them in the kernel.
> Good work.
> 

Thanks.

I am concerned about one thing. I cannot test the si470x usb radio 
driver because i don't have the si470x usb radio device, so i believe
you would have probably tested it.

>> The patch 1/4 is for separating common and usb code.
>> The patch 2/4 is about using dev_* macro instead of printk.
>> The patch 3/4 is about adding disconnect check function for i2c interface.
>> The patch 4/4 is for supporting si470x i2c interface.
> 
> Bye,
> Toby
> 

