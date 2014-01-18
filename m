Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:35175 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436AbaARWeW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Jan 2014 17:34:22 -0500
Received: by mail-wg0-f46.google.com with SMTP id x12so5655218wgg.13
        for <linux-media@vger.kernel.org>; Sat, 18 Jan 2014 14:34:21 -0800 (PST)
Message-ID: <52DB016B.5040108@googlemail.com>
Date: Sat, 18 Jan 2014 23:34:19 +0100
From: Gregor Jasny <gjasny@googlemail.com>
MIME-Version: 1.0
To: Andreas Weber <andy.weber.aw@gmail.com>,
	linux-media@vger.kernel.org
Subject: Re: How to tell libv4l2 which src_fmt should be prefered?
References: <52DA5ABA.7070003@gmail.com>
In-Reply-To: <52DA5ABA.7070003@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 18/01/14 11:43, Andreas Weber wrote:
> Is there a way to tell libv4l2 which native source format it should
> prefer to convert from? For example my uvcvideo webcam supports natively
> YUYV and MJPG (see output below)
> ...
>
> So it picks up YUYV as source format. I had a look at
> v4lconvert_try_format but can see no way how to do this.

If I understand the source correctly the table at [1] is the brain of 
the conversion. MJPEG has a rank of 7, YUYV has a rank of 5. So YUYV is 
chosen. The function that picks the conversion path is at [2].

Currently there is no way to influence the decision. Why do you want to 
do this?

Thanks,
Gregor

[1] 
http://git.linuxtv.org/v4l-utils.git/blob/HEAD:/lib/libv4lconvert/libv4lconvert.c#l75
[2] 
http://git.linuxtv.org/v4l-utils.git/blob/HEAD:/lib/libv4lconvert/libv4lconvert.c#l379

