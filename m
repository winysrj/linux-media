Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:42276 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752478AbcDVMFh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Apr 2016 08:05:37 -0400
Subject: Re: [PATCH v3 5/7] media: rcar-vin: add DV timings support
To: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
References: <1460650670-20849-1-git-send-email-ulrich.hecht+renesas@gmail.com>
 <1460650670-20849-6-git-send-email-ulrich.hecht+renesas@gmail.com>
 <5714B143.50902@xs4all.nl>
 <CAO3366wQ=CFx2XKNHBYCaN7TXs=unW77SucwMOVi7PCDPyZvkQ@mail.gmail.com>
Cc: hans.verkuil@cisco.com,
	=?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-renesas-soc@vger.kernel.org,
	Magnus Damm <magnus.damm@gmail.com>,
	Laurent <laurent.pinchart@ideasonboard.com>,
	ian.molton@codethink.co.uk, lars@metafoo.de,
	William Towle <william.towle@codethink.co.uk>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <571A138A.6050300@xs4all.nl>
Date: Fri, 22 Apr 2016 14:05:30 +0200
MIME-Version: 1.0
In-Reply-To: <CAO3366wQ=CFx2XKNHBYCaN7TXs=unW77SucwMOVi7PCDPyZvkQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/20/2016 06:24 PM, Ulrich Hecht wrote:
> On Mon, Apr 18, 2016 at 12:04 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> Hi Ulrich,
>>
>> This isn't right: this just overwrites the adv7180 input with an HDMI input.
>>
>> I assume the intention is to have support for both adv7180 and HDMI input and
>> to use VIDIOC_S_INPUT to select between the two.
> 
> I'm not quite sure what you mean.  The inputs are always hardwired to
> one specific decoder, no switching possible.

Never mind, I thought the composite and hdmi inputs where muxed to the same
rcar-vin instance, but each goes to the same instance.

I'll re-review the patch with that in mind.

Regards,

	Hans

