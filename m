Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:50289 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755710AbZKZQBL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Nov 2009 11:01:11 -0500
Received: by ewy19 with SMTP id 19so577381ewy.21
        for <linux-media@vger.kernel.org>; Thu, 26 Nov 2009 08:01:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <200911251721.26506.laurent.pinchart@ideasonboard.com>
References: <200911181354.06529.laurent.pinchart@ideasonboard.com>
	 <200911251721.26506.laurent.pinchart@ideasonboard.com>
Date: Thu, 26 Nov 2009 11:01:16 -0500
Message-ID: <83bcf6340911260801l551afdd1i70f3254424cc782e@mail.gmail.com>
Subject: Re: [PATCH/RFC v2] V4L core cleanups HG tree
From: Steven Toth <stoth@kernellabs.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, stoth@linuxtv.org, hverkuil@xs4all.nl,
	mchehab@infradead.org, srinivasa.deevi@conexant.com,
	dean@sensoray.com, palash.bandyopadhyay@conexant.com,
	awalls@radix.net, dheitmueller@kernellabs.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Nov 25, 2009 at 11:21 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hopefully CC'ing the au0828, cx231xx, cx23885, s2255 and cx25821 maintainers.
>
> Could you please ack patch http://linuxtv.org/hg/~pinchartl/v4l-dvb-
> cleanup/rev/7a762df57149 ? The patch should be committed to v4l-dvb in time
> for 2.6.33.
>
> On Wednesday 18 November 2009 13:54:06 Laurent Pinchart wrote:
>> Hi everybody,
>>
>> the V4L cleanup patches are now available from
>>
>> http://linuxtv.org/hg/~pinchartl/v4l-dvb-cleanup
>>
>> The tree will be rebased if needed (or rather dropped and recreated as hg
>> doesn't provide a rebase operation), so please don't pull from it yet if
>>  you don't want to have to throw the patches away manually later.
>>
>> I've incorporated the comments received so far and went through all the
>> patches to spot bugs that could have sneaked in.
>>
>> Please test the code against the driver(s) you maintain. The changes are
>> small, *should* not create any issue, but the usual bug can still sneak in.
>>
>> I can't wait for an explicit ack from all maintainers (mostly because I
>>  don't know you all), so I'll send a pull request in a week if there's no
>>  blocking issue. I'd like this to get in 2.6.33 if possible.

I have a pile of testing in the next few days. In light of Devin's
OOPS I'll test the cx88 and cx23885 changes and report back by sunday.

Thanks for the cleanups Laurent.

Regards,

- Steve

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
