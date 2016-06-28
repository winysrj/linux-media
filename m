Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:56644 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752585AbcF1L60 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jun 2016 07:58:26 -0400
Subject: Re: [PATCH v2 1/2] solo6x10: Set FRAME_BUF_SIZE to 200KB
To: Andrey Utkin <andrey_utkin@fastmail.com>
References: <1462378881-16625-1-git-send-email-ismael@iodev.co.uk>
 <33cd3138-6adc-d9c4-a9b0-bfb5f0445088@xs4all.nl>
 <20160628114809.GF31802@acer>
Cc: Ismael Luceno <ismael@iodev.co.uk>, linux-media@vger.kernel.org,
	Andrey Utkin <andrey.utkin@corp.bluecherry.net>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <57726657.3040802@xs4all.nl>
Date: Tue, 28 Jun 2016 13:58:15 +0200
MIME-Version: 1.0
In-Reply-To: <20160628114809.GF31802@acer>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/28/16 13:48, Andrey Utkin wrote:
> On Mon, Jun 27, 2016 at 11:12:42AM +0200, Hans Verkuil wrote:
>> Andrey,
>>
>> Since you are the original author, can you give me your Signed-off-by line?
> 
> No, as increasing buffer size by few kilobytes doesn't change anything. I've
> increased it from 200 to 204, then found new occurances of the issue,
> then increased it again and again by few kilobytes. Then I got that this
> is not a (nice) solution, and have never came back to this. Maybe
> doubling current buffer size would make users forget about this, but I'm
> not sure maintainers would be glad with such patch.

I don't care. Right now it doesn't work. The cause is that the buffers are
too small to handle the worst-case situation. So if doubling the size makes
it work, then that's perfectly OK. Memory is cheap these days. If it will
fail, then that's much worse than consuming a few meg more.

Ideally you can calculate what the worst-case size is, but I expect that to
be quite difficult if not impossible.

Regards,

	Hans
