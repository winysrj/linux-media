Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1379 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750884Ab1KDJjx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Nov 2011 05:39:53 -0400
Message-ID: <4EB3B2E3.2020808@redhat.com>
Date: Fri, 04 Nov 2011 07:39:47 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Marek Szyprowski <m.szyprowski@samsung.com>
CC: linux-media@vger.kernel.org,
	"'Kamil Debski'" <k.debski@samsung.com>,
	"'Kyungmin Park'" <kyungmin.park@samsung.com>
Subject: Re: [GIT PULL] More Samsung patches for v3.2
References: <1317913025-11534-1-git-send-email-m.szyprowski@samsung.com> <4EB2DCAC.2060106@redhat.com> <005101cc9ac0$a4ed1160$eec73420$%szyprowski@samsung.com>
In-Reply-To: <005101cc9ac0$a4ed1160$eec73420$%szyprowski@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 04-11-2011 05:09, Marek Szyprowski escreveu:
> Hello Mauro,
> 
> On Thursday, November 03, 2011 7:26 PM Mauro Carvalho Chehab wrote:
> 
>> Em 06-10-2011 11:57, Marek Szyprowski escreveu:
>>> Hello Mauro,
>>>
>>> The following changes since commit 2f4cf2c3a971c4d5154def8ef9ce4811d702852d:
>>>
>>>   [media] dib9000: release a lock on error (2011-09-30 13:32:56 -0300)
>>>
>>> are available in the git repository at:
>>>   git://git.infradead.org/users/kmpark/linux-2.6-samsung for_mauro
>>>
>>> Kamil Debski (2):
>>>       v4l: add G2D driver for s5p device family
>>>       v4l: s5p-mfc: fix reported capabilities
>>
>> Not sure what happened, but the patches that came from the above are these, instead:
>>
>> 0001-media-vb2-add-a-check-for-uninitialized-buffer.patch
>> 0002-media-vb2-set-buffer-length-correctly-for-all-buffer.patch
>> 0003-media-vb2-reset-queued-list-on-REQBUFS-0-call.patch
>> 0004-vb2-add-vb2_get_unmapped_area-in-vb2-core.patch
>> 0005-v4l-add-G2D-driver-for-s5p-device-family.patch
>> 0006-v4l-s5p-mfc-fix-reported-capabilities.patch
>> 0007-MFC-Change-MFC-firmware-binary-name.patch
>> 0008-v4l-Add-AUTO-option-for-the-V4L2_CID_POWER_LINE_FREQ.patch
>> 0009-v4l-Add-v4l2-subdev-driver-for-S5K6AAFX-sensor.patch
> 
> Right. I thought that my initial pull request have been lost so I've collected all
> the patches that had not been merged yet and I was about to send the pull request
> again yesterday. Too bad that I had to get out from the office early...
> 
> Now I see that some of these patches have been merged, so I will rebase the branch
> and send pull request again.
> 
> Almost all of them are quite important fixes to various videobuf2 corner cases, so I
> hope they will find their way into v3.2.

Please split them into fixes and non-fixes. It is probably to late for sending the
non-fixes for 3.2. I'll be sending later what's merged on today's linux-next upstream.
The remaining ones will likely be sending only after -rc1.

Regards,
Mauro

> 
> Best regards

