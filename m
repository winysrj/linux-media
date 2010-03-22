Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7264 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754245Ab0CVJ2F (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Mar 2010 05:28:05 -0400
Message-ID: <4BA73865.3070107@redhat.com>
Date: Mon, 22 Mar 2010 10:29:09 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	David Ellingsworth <david@identd.dyndns.org>
Subject: Re: RFC: Phase 1: Proposal to convert V4L1 drivers
References: <201003200958.49649.hverkuil@xs4all.nl> <201003212345.04736.hverkuil@xs4all.nl> <201003220117.34790.hverkuil@xs4all.nl>
In-Reply-To: <201003220117.34790.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 03/22/2010 01:17 AM, Hans Verkuil wrote:
> On Sunday 21 March 2010 23:45:04 Hans Verkuil wrote:
>> On Saturday 20 March 2010 09:58:49 Hans Verkuil wrote:
>>> These drivers have no hardware to test with: bw-qcam, c-qcam, arv, w9966.
>>> However, all four should be easy to convert to v4l2, even without hardware.
>>> Volunteers?
>>
>> I've converted these four drivers to V4L2.
>
> I've also removed the V4L1 support from cpia2 and pwc and removed some last
> V4L1 code remnants from meye and zoran. It's all in the same tree.
>
> Hans, could you test the pwc driver for me?
>

Done,

And the news is not good I'm afraid, it does not work. I've one interesting
observation though. It does work if I first run it once with the "old"
version of the driver and then load your version (also replacing videodev.ko,
etc with the ones from your tree). But if I plug it in with your driver in
place it does not stream (nothing interesting in dmesg). So it seems like
an initialization problem.

As said the pwc driver needs some love in general, I've seen the same problem
(not streaming) with the "old" version when used with machines with UHCI usb
controllers (rather then OHCI), such as atom based laptops.

So maybe this is some timing issues, and your changes have speed up some path?

Note that I've 3 identical pwc cams, I would be more then happy to give you
one, let me know how to best get it to you.

Regards,

Hans
