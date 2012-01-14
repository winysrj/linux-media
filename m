Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:59199 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755928Ab2ANRmb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Jan 2012 12:42:31 -0500
Received: by eekd4 with SMTP id d4so1424963eek.19
        for <linux-media@vger.kernel.org>; Sat, 14 Jan 2012 09:42:29 -0800 (PST)
Message-ID: <4F11BE7C.3060601@gmail.com>
Date: Sat, 14 Jan 2012 18:42:20 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH/RFC v2 3/4] gspca: sonixj: Add V4L2_CID_JPEG_COMPRESSION_QUALITY
 control support
References: <4EBECD11.8090709@gmail.com>	<1325873682-3754-4-git-send-email-snjw23@gmail.com> <20120114094720.781f89a5@tele>
In-Reply-To: <20120114094720.781f89a5@tele>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/14/2012 09:47 AM, Jean-Francois Moine wrote:
> On Fri,  6 Jan 2012 19:14:41 +0100
> Sylwester Nawrocki<snjw23@gmail.com>  wrote:
> 
>> The JPEG compression quality value can currently be read using the
>> VIDIOC_G_JPEGCOMP ioctl. As the quality field of struct v4l2_jpgecomp
>> is being deprecated, we add the V4L2_CID_JPEG_COMPRESSION_QUALITY
>> control, so after the deprecation period VIDIOC_G_JPEGCOMP ioctl
>> handler can be removed, leaving the control the only user interface
>> for retrieving the compression quality.
> 	[snip]
> 
> This patch works, but, to follow the general control mechanism in gspca,
> it should be better to remove the variable 'quality' of 'struct sd' and
> to replace all 'sd->quality' by 'sd->ctrls[QUALITY].val'.
> 
> Then, initialization
> 
> 	sd->quality = QUALITY_DEF;
> 
> in sd_config() is no more useful, and there is no need to have a
> getjpegqual() function, the control descriptor for QUALITY having just:
> 
> 	.set_control = setjpegqual

Thank you for reviewing the patches. I wasn't sure I fully understood
the locking, hence I left the 'quality' field in 'struct sd' not removed. 
I've modified both subdrivers according to your suggestions. I would have 
one question before I send the corrected patches though. Unlike zc3xx, 
the configured quality value in sonixj driver changes dynamically, i.e. 
it drifts away in few seconds from whatever value the user sets. This makes
me wonder if .set_control operation should be implemented for the QUALITY
control, and whether to leave V4L2_CTRL_FLAG_READ_ONLY control flag or not.

There seem to be not much value in setting such control for the user,
but maybe it's different for other devices covered by the sonixj driver.

--
Best regards,
Sylwester
