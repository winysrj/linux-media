Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:41535 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753240Ab0JRH4A (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Oct 2010 03:56:00 -0400
Message-ID: <4CBBFE4D.7000604@redhat.com>
Date: Mon, 18 Oct 2010 09:59:09 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Gary Thomas <gary@mlbassoc.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: libv4l conversion problem
References: <4CB6E671.2060706@mlbassoc.com>
In-Reply-To: <4CB6E671.2060706@mlbassoc.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

On 10/14/2010 01:16 PM, Gary Thomas wrote:
> Hans,
>
> Please forgive the direct email; try as I might, I could not
> find any other vehicle to discuss this (feel free to steer me
> to the proper place).
>

There indeed is a lack of a mailinglist or forum for
v4l-utils. This has been discussed before and it was decided
that given the low amount of discussion around v4l-utils we will
just use the linux-media mailing list for this (added to the CC).

> I'm working with the latest code (0.8.1) on an embedded ARM
> system which has a camera that can only deliver UYVY422 data.

Ok, so when you say UYVY422, I assume that this is packed data,
right, so not some planar format, right? libv4l supports
converting UYVY422 packed data to:
RGB24
BGR24
YUV420 (planar)
YVU420 (planar)

> The problem I have is that most everything else, e.g. I'm trying
> to run cheese, wants YUYV422.

cheese specifically should be happy with almost any YUV or RGB
format as it uses gstreamer. I know for a fact that it works
happily with libv4l's YUV420 (planar) output.

> Should the library be able to handle this case (device only
> does UYUV and application wants YUYV)?

It does not support converting to packed yuv formats, but it does
support conversion to planar yuv formats. At least for cheese
this should work fine.

> Any suggestions how I move forward?

Make sure that your gstreamer is compiled with libv4l support.

Regards,

Hans
