Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:55525 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932681AbcGEGrE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 5 Jul 2016 02:47:04 -0400
Subject: Re: [GIT PULL FOR v4.8] Various fixes/improvements
To: Florian Echtler <floe@butterbrot.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <319a2666-50e5-29ff-b5bf-b47d26723d7a@xs4all.nl>
 <577B45B4.2050705@butterbrot.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <7c4f3903-dd92-c027-dbc2-1a4b42a3b641@xs4all.nl>
Date: Tue, 5 Jul 2016 08:46:51 +0200
MIME-Version: 1.0
In-Reply-To: <577B45B4.2050705@butterbrot.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/05/2016 07:29 AM, Florian Echtler wrote:
> Hello Hans,
> 
> On 01.07.2016 16:45, Hans Verkuil wrote:
>> Florian Echtler (3):
>>       sur40: properly report a single frame rate of 60 FPS
>>       sur40: lower poll interval to fix occasional FPS drops to ~56 FPS
>>       sur40: fix occasional oopses on device close
> 
> Thanks for merging this, AFAICS these fixes will now be part of 4.8. We
> were hoping they might also be picked for the 4.4 LTS kernel, will this
> be decided by Greg KH or will it happen automatically?

I've added a Cc to the stable list for patches 2 and 3: those patches will
go to kernels 4.2 and up. Please mention such things next time.

I took another look at patch 1 and found that I had a question about it.
Patch 1 is also not something for older kernels since it isn't a bug fix.

Regards,

	Hans
