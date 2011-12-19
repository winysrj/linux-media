Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:59785 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140Ab1LSLBf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Dec 2011 06:01:35 -0500
Received: by wibhm6 with SMTP id hm6so890024wib.19
        for <linux-media@vger.kernel.org>; Mon, 19 Dec 2011 03:01:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201112190119.08008.laurent.pinchart@ideasonboard.com>
References: <CACKLOr1qSpJXjyptUF3OEWR2b7XNoRdMjiVWzZ9gtuanfgJZDQ@mail.gmail.com>
	<201112190119.08008.laurent.pinchart@ideasonboard.com>
Date: Mon, 19 Dec 2011 12:01:34 +0100
Message-ID: <CACKLOr2zx_xcHS0059N0mAaZb2kiCj+xfyE1D5iDsZkNyvTwcw@mail.gmail.com>
Subject: Re: Trying to figure out reasons for lost pictures in UVC driver.
From: javier Martin <javier.martin@vista-silicon.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 19 December 2011 01:19, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Javier,
>
> On Thursday 15 December 2011 17:02:47 javier Martin wrote:
>> Hi,
>> we are testing a logitech Webcam M/N: V-U0012 in the UVC tree (commit
>> ef7728797039bb6a20f22cc2d96ef72d9338cba0).
>> It is configured at 25fps, VGA.
>>
>> We've observed that the following debugging message appears sometimes
>> "Frame complete (FID bit toggled).". Whenever this happens a v4l2
>> frame is lost (i.e. one sequence number has been skipped).
>>
>> Is this behavior expected? What could we do to avoid frame loss?
>
> Could you check the frame intervals to see if a frame is really lost, or if
> the driver erroneously reports frame loss ?

Hi Laurent,
sequence number in the v4l2 buffer returned is one step bigger than
expected, however the timestamp difference with the previous buffer is
40ms which is what it is expected at 25fps.
So, sequence number indicates a buffer has been lost but timestamp does not.

-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
