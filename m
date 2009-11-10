Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:3033 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755859AbZKJSjl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Nov 2009 13:39:41 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: santiago.nunez@ridgerun.com
Subject: Re: [PATCH 3/4 v6] TVP7002 driver for DM365
Date: Tue, 10 Nov 2009 19:39:38 +0100
Cc: davinci-linux-open-source@linux.davincidsp.com,
	linux-media@vger.kernel.org, nsnehaprabha@ti.com,
	m-karicheri2@ti.com, diego.dompe@ridgerun.com,
	todd.fischer@ridgerun.com, mgrosen@ti.com
References: <1257522176-25893-1-git-send-email-santiago.nunez@ridgerun.com> <200911091646.54410.hverkuil@xs4all.nl> <4AF9ACFD.3050302@ridgerun.com>
In-Reply-To: <4AF9ACFD.3050302@ridgerun.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911101939.38729.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 10 November 2009 19:12:13 Santiago Nunez-Corrales wrote:
> Hans,
> 
> 
> Thanks for all your patient and detailed reviews. I've addressed most of 
> the comments. There is one thing though that seems odd but is there due 
> to a good reason. The devices requires to be turned off and on again 
> during the s_stream function, in which it 'forgets' its previous state 
> and therefore register values have to be kept in memory and set back for 
> initialization purposes.

Hmm. It's still pretty ugly. Wouldn't it be more elegant to record this state
at a higher level? E.g. instead of restoring gain registers you would store
the current gain value in the state struct and just set the gain again. Ditto
for things like the output standard, etc.

Another question is: why does it need to be reset? That's rather peculiar.
Are there powersaving considerations? Is this normal behavior for this device?

I can't imagine that this is how the tvp7002 designers expected it to be used,
so I get the feeling that what you are doing is more a kludge to hammer the
driver into the v4l2_subdev API.

Can you look at this some more? I have downloaded the tvp7002 datasheet, so
you can also point me to the relevant sections/register descriptions of the
datasheet.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
