Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:47304 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752767Ab0CVNCp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Mar 2010 09:02:45 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
Received: from eu_spt1 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0KZO00FL9PKI4660@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 22 Mar 2010 13:02:42 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0KZO001C6PKIY9@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 22 Mar 2010 13:02:42 +0000 (GMT)
Date: Mon, 22 Mar 2010 14:00:51 +0100
From: Pawel Osciak <p.osciak@samsung.com>
Subject: RE: [REPORT] Brainstorm meeting on V4L2 memory handling
In-reply-to: <19F8576C6E063C45BE387C64729E7394044DE0E50D@dbde02.ent.ti.com>
To: "'Hiremath, Vaibhav'" <hvaibhav@ti.com>,
	linux-media@vger.kernel.org
Message-id: <004801cac9bf$b2e32e90$18a98bb0$%osciak@samsung.com>
Content-language: pl
References: <201003131456.21510.hverkuil@xs4all.nl>
 <19F8576C6E063C45BE387C64729E7394044DE0E50D@dbde02.ent.ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello!

>Hiremath, Vaibhav wrote:
>> 1) Memory-to-memory devices
>>
>> Original thread with the proposal from Samsung:
>>
>> http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg00391.html
>>
>[Hiremath, Vaibhav] Pawel,
>
>I wanted to start prototyping Resizer and Previewer driver to this framework,
> before starting just wanted to make sure that I start with latest and
> greatest. Is V2 post still holds latest? Did you do any changes after that?
>

Only some minor tweaks for v3, which is currently underway. This is the expected
changelog for it:

- streamon/off will have to be called on both queues instead of just either one
- automatic rescheduling for instances if they have more buffers waiting
- addressing comments from Andy Walls

All in all, I do not expect any other API changes and only minor tweaks under
the hood. It should be ready this week.


>Also, have you validated this with actual hardware module? If not then I think
>I can now start on this and add resizer driver to it.

Yes, we have actually been using v2 for several real devices, one of which was
the previously posted S3C rotator driver:
http://www.mail-archive.com/linux-media@vger.kernel.org/msg13606.html

And there is always the test device, which was posted along with v2.

If you come across any problems or have more questions, I would be happy to help.

Best regards
--
Pawel Osciak
Linux Platform Group
Samsung Poland R&D Center


