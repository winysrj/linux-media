Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:53770 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751819AbbJLK02 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Oct 2015 06:26:28 -0400
Message-ID: <561B8A61.1010406@xs4all.nl>
Date: Mon, 12 Oct 2015 12:24:33 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>,
	"Matwey V. Kornilov" <matwey.kornilov@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: v4l2 api: supported resolution negotiation
References: <muqr5s$f1j$2@ger.gmane.org> <20151004184923.GH26916@valkosipuli.retiisi.org.uk>
In-Reply-To: <20151004184923.GH26916@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/04/2015 08:49 PM, Sakari Ailus wrote:
> On Sun, Oct 04, 2015 at 12:23:08PM +0300, Matwey V. Kornilov wrote:
>> Hello,
>>
>> I learned from V2L2 API how to detect all supported formats using
>> VIDIOC_ENUM_FMT.
>> When I perform VIDIOC_S_FMT I don't know how to fill fmt.pix.width and
>> fmt.pix.height, since I know only format.
>> How should I negotiate device resolution? Could you point me?
> 
> VIDIOC_ENUM_FRAMESIZES may give you hints, but it's optional. You can use
> values you prefer to try if drivers support them; I think the GStreamer
> v4lsrc tries very small and very large values. The driver will clamp them to
> a supported values which are passed to the application from the IOCTL.
> 
> <URL:http://hverkuil.home.xs4all.nl/spec/media.html#vidioc-enum-framesizes>
> 

You can also call G_FMT first, then change the pixelformat and call S_FMT.
This will only change the pixelformat and leave the resolution the same (unless
the driver has some restrictions for the new pixelformat, but that's unlikely).

Regards,

	Hans
