Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:52354 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755433AbZDMKmM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Apr 2009 06:42:12 -0400
Received: from epmmp1 (mailout3.samsung.com [203.254.224.33])
 by mailout3.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0KI1004XXCEAMC@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Mon, 13 Apr 2009 19:42:10 +0900 (KST)
Received: from TNRNDGASPAPP1.tn.corp.samsungelectronics.net ([165.213.149.150])
 by mmp1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0KI100DEMCEAT7@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 13 Apr 2009 19:42:10 +0900 (KST)
Date: Mon, 13 Apr 2009 19:42:10 +0900
From: Joonyoung Shim <jy0922.shim@samsung.com>
Subject: Re: About the radio-si470x driver for I2C interface
In-reply-to: <49E31480.7050100@samsung.com>
To: Tobias Lorenz <tobias.lorenz@gmx.net>
Cc: klimov.linux@gmail.com, linux-media@vger.kernel.org,
	kyungmin.park@samsung.com
Message-id: <49E31702.8020507@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7BIT
References: <4e1455be0903051913x37562436y85eef9cba8b10ab0@mail.gmail.com>
 <49E29962.5010209@samsung.com> <49E2CDEA.4080409@samsung.com>
 <200904131215.05703.tobias.lorenz@gmx.net> <49E31480.7050100@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 4/13/2009 7:31 PM, Joonyoung Shim wrote:
>> I'm not sure about the consequences in case of renaming the radio-si470x
>> module. But it would be consequent to add the appendix -usb and -i2c to
>> the current name.
>>
>> I applied the patch as follows:
> 
> Okay, your patch is better.
> Thanks.
> 
> I will post the i2c part soon after testing.

I have some problem. There is codes for usb in radio-si470x-common.c file.
Hrm, if it cannot be removed, maybe it seems to seperate using ifdef.
What do you think about this?

> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

