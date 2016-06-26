Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:49959 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752086AbcFZPHg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Jun 2016 11:07:36 -0400
Subject: Re: media_build & cx23885
To: Torbjorn Jansson <torbjorn.jansson@mbox200.swipnet.se>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <bb9fb742-7975-5c9a-1abc-bfd1a456d462@mbox200.swipnet.se>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <1c7bbf34-eb2a-5f26-5058-d5c6585f698b@xs4all.nl>
Date: Sun, 26 Jun 2016 17:07:30 +0200
MIME-Version: 1.0
In-Reply-To: <bb9fb742-7975-5c9a-1abc-bfd1a456d462@mbox200.swipnet.se>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/26/2016 04:29 PM, Torbjorn Jansson wrote:
> Hello
> 
> if i use media_build and modprobe cx23885 i get:
> # modprobe cx23885
> modprobe: ERROR: could not insert 'cx23885': Exec format error
> 
> and on dmesg i get:
> frame_vector: exports duplicate symbol frame_vector_create (owned by kernel)

The frame_vector.ko module was incorrectly installed in /lib/modules/`uname -r`
(probably in the kernel/mm directory). Your kernel already has that module
compiled in, so that's the reason for the duplicate symbol.

Remove that module and run 'depmod -a' and it should work again.

I've seen this before, but I don't know why media_build compiles and installs it
for a kernel that doesn't need it.

Regards,

	Hans

> 
> any idea whats causing this?
> this prevents one of my cards from working with media_build
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
