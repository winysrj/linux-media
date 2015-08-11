Return-path: <linux-media-owner@vger.kernel.org>
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:55197 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964954AbbHKOuI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Aug 2015 10:50:08 -0400
Date: Tue, 11 Aug 2015 15:50:03 +0100 (BST)
From: William Towle <william.towle@codethink.co.uk>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	William Towle <william.towle@codethink.co.uk>
Subject: Re: [GIT PULL FOR v4.3] Various fixes
In-Reply-To: <55C9F611.3000902@xs4all.nl>
Message-ID: <alpine.DEB.2.02.1508111526170.4890@xk120.dyn.ducie.codethink.co.uk>
References: <55B749C7.4070005@xs4all.nl> <20150811100804.4cbb0ab7@recife.lan> <55C9F611.3000902@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Tue, 11 Aug 2015, Hans Verkuil wrote:
>> 0015-v4l-subdev-Add-pad-config-allocator-and-init.patch
>> 0016-media-soc_camera-rcar_vin-Add-BT.709-24-bit-RGB888-i.patch
>> 0017-media-soc_camera-pad-aware-driver-initialisation.patch
>> 0018-media-rcar_vin-Use-correct-pad-number-in-try_fmt.patch
>> 0019-media-soc_camera-soc_scale_crop-Use-correct-pad-numb.patch
>> 0020-media-rcar_vin-fill-in-bus_info-field.patch
>> 0021-media-rcar_vin-Reject-videobufs-that-are-too-small-f.patch
>
> William, can you take a look at this? Just let me know which patches
> are independent to patch 0015.

   Of those, the patches that *do* call the allocator function directly
or are otherwise co-dependent are numbers 17-19 inclusive.


   The independent patches in that list are therefore:

[prerequisite work by Laurent Pinchart (1x)...]
 	0016-media-soc_camera-rcar_vin-Add-BT.709-24-bit-RGB888-i.patch
[general rcar_vin enhancements by Rob Taylor (2x)...]
 	0020-media-rcar_vin-fill-in-bus_info-field.patch
 	0021-media-rcar_vin-Reject-videobufs-that-are-too-small-f.patch

Cheers,
   Wills.
