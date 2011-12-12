Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21225 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751131Ab1LLNmD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Dec 2011 08:42:03 -0500
Message-ID: <4EE604A8.8030507@redhat.com>
Date: Mon, 12 Dec 2011 11:42:00 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Manu Abraham <abraham.manu@gmail.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: v4 [PATCH 00/10] Query DVB frontend delivery capabilities
References: <CAHFNz9+J69YqY06QRSPV+1a0gT1QSmw7cqqnW5AEarF-V5xGCw@mail.gmail.com> <4EE359CF.7090707@redhat.com> <CAHFNz9JC=r_hzkU1HOGvVkqHS-YZ0b7hatowgSaxpS7g58OVdA@mail.gmail.com>
In-Reply-To: <CAHFNz9JC=r_hzkU1HOGvVkqHS-YZ0b7hatowgSaxpS7g58OVdA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12-12-2011 04:35, Manu Abraham wrote:
> On Sat, Dec 10, 2011 at 6:38 PM, Mauro Carvalho Chehab
> <mchehab@redhat.com>  wrote:
>> On 10-12-2011 02:41, Manu Abraham wrote:
>>>
>>> Hi,
>>>
>>>   As discussed prior, the following changes help to advertise a
>>>   frontend's delivery system capabilities.
>>>
>>>   Sending out the patches as they are being worked out.
>>>
>>>   The following patch series are applied against media_tree.git
>>>   after the following commit
>>>
>>>   commit e9eb0dadba932940f721f9d27544a7818b2fa1c5
>>>   Author: Hans Verkuil<hans.verkuil@cisco.com>
>>>   Date:   Tue Nov 8 11:02:34 2011 -0300
>>>
>>>      [media] V4L menu: add submenu for platform devices
>>
>>
>>
>> A separate issue: please, don't send patches like that as attachment. It
>> makes
>> hard for people review. Instead, you should use git send-email. There's even
>> an example there (at least on git version 1.7.8) showing how to set it for
>> Google:
>
>
> I don't have net access configured for the box where I do
> tests/on the testbox. The outgoing mail from my side is
> through the gmail web interface. If I don't attach the
> patches, gmail garbles those patches.

Not sure what you've meant by "net". Internet, or network, in general?

If you don't have an ethernet interface configured on your test box, you
can still put your git tree into a removable media (pen-driver or whatever)
and use it to transfer to your main machine, and then call git from it.

If you have Ethernet there, it is even simpler: from your main machine:

$ git pull remote:/patch/to/git my_branch

$ git send-email

Regards,
Mauro.
