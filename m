Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:52715 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751468AbcFRQ43 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Jun 2016 12:56:29 -0400
Subject: Re: [PATCH 0/2] input: add support for HDMI CEC
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
References: <1466261428-12616-1-git-send-email-hverkuil@xs4all.nl>
 <20160618162655.GC12210@dtor-ws>
Cc: linux-media@vger.kernel.org, linux-input@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <57657D38.9080007@xs4all.nl>
Date: Sat, 18 Jun 2016 18:56:24 +0200
MIME-Version: 1.0
In-Reply-To: <20160618162655.GC12210@dtor-ws>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/18/2016 06:26 PM, Dmitry Torokhov wrote:
> Hi Hans,
> 
> On Sat, Jun 18, 2016 at 04:50:26PM +0200, Hans Verkuil wrote:
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> Hi Dmitry,
>>
>> This patch series adds input support for the HDMI CEC bus through which
>> remote control keys can be passed from one HDMI device to another.
>>
>> This has been posted before as part of the HDMI CEC patch series. We are
>> going to merge that in linux-media for 4.8, but these two patches have to
>> go through linux-input.
>>
>> Only the rc-cec keymap file depends on this, and we will take care of that
>> dependency (we'll postpone merging that until both these input patches and
>> our own CEC patches have been merged in mainline).
> 
> If it would be easier for you I am perfectly fine with these patches
> going through media tree; you have my acks on them.

You're not expecting any changes to these headers for 4.8 that might
cause merge conflicts? That was Mauro's concern.

If not, then I would prefer it to go through the media tree to simplify
the dependencies, but it's up to Mauro.

Regards,

	Hans
