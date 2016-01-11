Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:54070 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758960AbcAKLdg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jan 2016 06:33:36 -0500
Subject: Re: vivid - add support for YUV420
To: Ran Shalit <ranshalit@gmail.com>, linux-media@vger.kernel.org
References: <CAJ2oMhJVjKrfXEKx6xnGQkEpcSWBywabrDwy9biJkhjmnZ7Kbg@mail.gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <5693930C.9050001@xs4all.nl>
Date: Mon, 11 Jan 2016 12:33:32 +0100
MIME-Version: 1.0
In-Reply-To: <CAJ2oMhJVjKrfXEKx6xnGQkEpcSWBywabrDwy9biJkhjmnZ7Kbg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/09/2016 10:58 AM, Ran Shalit wrote:
> Hello,
> 
> I've been doing some tests with capturing video from virtual driver (vivid).
> I've tried to force it to YUV420, but it ignores that, becuase it does
> not support this format.

Yes, it does. What kernel are you using? Something old? Support for 4:2:0 was
added to vivid in March 2015.

> I would please like to ask if there is some way I can output YUV420
> format with vivi.

Upgrade your kernel :-)

BTW, please don't use vivi to refer to the vivid driver. There used to be an
older vivi driver that was replaced by vivid, so calling the vivid driver 'vivi'
is very confusing to me :-)

Regards,

	Hans

> 
> Best Regards,
> Ran
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

