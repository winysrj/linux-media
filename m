Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:2444 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717AbaIMIhG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Sep 2014 04:37:06 -0400
Message-ID: <5414021A.3000401@xs4all.nl>
Date: Sat, 13 Sep 2014 10:36:42 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Shuah Khan <shuahkh@osg.samsung.com>,
	"Mauro Carvalho Chehab (m.chehab@samsung.com)" <m.chehab@samsung.com>
CC: linux-media@vger.kernel.org
Subject: Re: v4l2_fops - poll and open
References: <5413911F.8070302@osg.samsung.com>
In-Reply-To: <5413911F.8070302@osg.samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/13/2014 02:34 AM, Shuah Khan wrote:
> Mauro/Hans,
> 
> It turns out au0828 driver does init tuner from its
> v4l2_fops read and poll. If an analog app comes in
> and does a read or poll, digital could get disrupted.
> Do you recommend adding token access to these??

Yes. read() and poll() are effectively the same as STREAMON.

But rather than doing this for read, poll, streamon, streamoff
and when the filehandle is closed you should think of integrating
this in vb2 and do it in start_streaming and stop_streaming.
Those are really the only two streaming-related places where you
need to take and release the tuner token.

As I mentioned before, I think it is a good idea to convert
au0828 to vb2. Since vb2 makes resource management so much easier
than vb1 I think it will only help you.

Also, requiring vb2 support for tuner ownership to work correctly
is a good incentive to keep on converting drivers to vb2.

Regards,

	Hans

> 
> -- Shuah
> 

