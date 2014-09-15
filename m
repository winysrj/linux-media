Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:36195 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751847AbaIOOP1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Sep 2014 10:15:27 -0400
Message-ID: <5416F475.7090001@osg.samsung.com>
Date: Mon, 15 Sep 2014 08:15:17 -0600
From: Shuah Khan <shuahkh@osg.samsung.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>,
	"Mauro Carvalho Chehab (m.chehab@samsung.com)" <m.chehab@samsung.com>
CC: linux-media@vger.kernel.org, Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: v4l2_fops - poll and open
References: <5413911F.8070302@osg.samsung.com> <5414021A.3000401@xs4all.nl>
In-Reply-To: <5414021A.3000401@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/13/2014 02:36 AM, Hans Verkuil wrote:
> On 09/13/2014 02:34 AM, Shuah Khan wrote:
>> Mauro/Hans,
>>
>> It turns out au0828 driver does init tuner from its
>> v4l2_fops read and poll. If an analog app comes in
>> and does a read or poll, digital could get disrupted.
>> Do you recommend adding token access to these??
> 
> Yes. read() and poll() are effectively the same as STREAMON.
> 
> But rather than doing this for read, poll, streamon, streamoff
> and when the filehandle is closed you should think of integrating
> this in vb2 and do it in start_streaming and stop_streaming.
> Those are really the only two streaming-related places where you
> need to take and release the tuner token.
> 
> As I mentioned before, I think it is a good idea to convert
> au0828 to vb2. Since vb2 makes resource management so much easier
> than vb1 I think it will only help you.
> 
> Also, requiring vb2 support for tuner ownership to work correctly
> is a good incentive to keep on converting drivers to vb2.
> 

Right we discussed it a few weeks at LinuxCon.  My thinking is
getting the tuner ownership work done is higher priority as it benefits
several drivers. Even if au0828 gets converted to vb2, the tuner
work still have to deal with other drivers that aren't converted to
vb2. i.e I might still end up adding acquiring tuner at open, poll
etc.

Mauro! What are your thoughts on this idea?? I would like to get
the media sharing work done since it will benefit PM scenarios.

-- Shuah


-- 
Shuah Khan
Sr. Linux Kernel Developer
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
