Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61730 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756142Ab0FCPOY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Jun 2010 11:14:24 -0400
Message-ID: <4C07C711.5040900@redhat.com>
Date: Thu, 03 Jun 2010 17:15:29 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Bill Davidsen <davidsen@tmr.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
	linux-usb@vger.kernel.org, linux-media@vger.kernel.org,
	bugzilla-daemon@bugzilla.kernel.org,
	bugme-daemon@bugzilla.kernel.org
Subject: Re: [Bugme-new] [Bug 16050] New: The ibmcam driver is not working
References: <bug-16050-10286@https.bugzilla.kernel.org/> <20100528154635.129b621b.akpm@linux-foundation.org> <4C04C942.6000900@redhat.com> <4C054105.6020806@tmr.com> <4C07B3BC.3050209@redhat.com> <4C07C316.2090903@tmr.com>
In-Reply-To: <4C07C316.2090903@tmr.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 06/03/2010 04:58 PM, Bill Davidsen wrote:
> Hans de Goede wrote:
>> Hi,
>>
>> On 06/01/2010 07:19 PM, Bill Davidsen wrote:
>>> Hans de Goede wrote:
>> >
>>> In case you don't have this information, here is a line from lsusb:
>>> Bus 003 Device 002: ID 0545:8080 Xirlink, Inc. IBM C-It Webcam
>>>
>>> Hopefully the items you have ordered are the same model.
>>>
>>
>> I have the same usb-id, but I'm working on the driver now and it
>> seems XirLink distinguishes between different models by bcdversion,
>> instead of using different usb ids for each product.
>>
>> Can you send me a mail with the output of "lsusb -v", then I can
>> see if you have the same version as I have for testing.
>>
>
> Sure, attached.
>

Thx,

Your device has a revision of 3.0a (the firmware programmers did not
seem to fully grasp the concept of the d in bcd (it stands for decimal),
which is different from mine which is revision 3.01 . Your version is
referred to as a model2 by the old driver, where as mine is a model3.

This is both bad and good news, the bad news is I cannot give you an
already tested driver to fix your issues. The good news is, that this
means that, assuming that you are willing to help out with testing, we
can now also verify that model 2 cams will work with the new driver.

So would you be willing to test the new driver (when it is finished) ?

Regards,

Hans
