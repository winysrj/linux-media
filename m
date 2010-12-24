Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:54122 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752564Ab0LXONd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Dec 2010 09:13:33 -0500
Message-ID: <4D14ABEE.40206@redhat.com>
Date: Fri, 24 Dec 2010 15:19:26 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: nasty bug at qv4l2
References: <4D11E170.6050500@redhat.com>
In-Reply-To: <4D11E170.6050500@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi,

On 12/22/2010 12:30 PM, Mauro Carvalho Chehab wrote:
> Hans V/Hans G,
>
> There's a nasty bug at qv4l2 or at libv4l: it is not properly updating
> all info, if you change the video device. On my tests with uvcvideo (video0)
> and a gspca camera (pac7302, video1), it was showing the supported formats
> for the uvcvideo camera when I changed from video0 to video1.
>
> The net result is that the image were handled with the wrong decoder
> (instead of using fourcc V4L2_PIX_FMT_PJPG, it were using BGR3), producing
> a wrong decoding.
>
> Could you please take a look on it?

I'm pretty sure this is not a libv4l issue (other apps which allows witching
the source work fine), but rather a qv4l2 problem, esp. as it uses libv4lconvert
directly rather then going through libv4l (iirc).

Hans V, can you take a look at this?

Regards,

Hans
