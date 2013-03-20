Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-3.cisco.com ([144.254.224.146]:64214 "EHLO
	ams-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418Ab3CTJFE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Mar 2013 05:05:04 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Eduardo Valentin <edubezval@gmail.com>
Subject: Re: [PATCH 0/4] media: si4713: minor updates
Date: Wed, 20 Mar 2013 10:04:05 +0100
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
References: <1363707694-27224-1-git-send-email-edubezval@gmail.com>
In-Reply-To: <1363707694-27224-1-git-send-email-edubezval@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201303201004.05563.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Eduardo!

On Tue 19 March 2013 16:41:30 Eduardo Valentin wrote:
> Hello Mauro and Hans,
> 
> Here are a couple of minor changes for si4713 FM transmitter driver.

Thanks!

Patches 2-4 are fine, but I don't really see the point of the first patch
(except for the last chunk which is a real improvement).

The Codingstyle doesn't require such alignment, and in fact it says:

"Descendants are always substantially shorter than the parent and
are placed substantially to the right. The same applies to function headers
with a long argument list."

Unless Mauro thinks otherwise, I would leave all the alignment stuff alone
and just post a version with the last chunk.

For patches 2-4:

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Are you still able to test the si4713 driver? Because I have patches
outstanding that I would love for someone to test for me:

http://git.linuxtv.org/hverkuil/media_tree.git/shortlog/refs/heads/si4713

In particular, run the latest v4l2-compliance test over it.

Regards,

	Hans

> 
> These changes are also available here:
> https://git.gitorious.org/si4713/si4713.git
> 
> All best,
> 
> Eduardo Valentin (4):
>   media: radio: CodingStyle changes on si4713
>   media: radio: correct module license (==> GPL v2)
>   media: radio: add driver owner entry for radio-si4713
>   media: radio: add module alias entry for radio-si4713
> 
>  drivers/media/radio/radio-si4713.c |   57 ++++++++++++++++++-----------------
>  1 files changed, 29 insertions(+), 28 deletions(-)
> 
> 
