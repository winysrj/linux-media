Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay.synopsys.com ([198.182.47.9]:44458 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932335AbcJQL5I (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Oct 2016 07:57:08 -0400
Subject: Re: [ANN] Report of the V4L2 Request API brainstorm meeting
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
References: <5518f06f-046f-98e8-05f3-5e9063df15e8@xs4all.nl>
CC: <keith@kodi.tv>
From: Jose Abreu <Jose.Abreu@synopsys.com>
Message-ID: <5804BC8D.5070709@synopsys.com>
Date: Mon, 17 Oct 2016 12:57:01 +0100
MIME-Version: 1.0
In-Reply-To: <5518f06f-046f-98e8-05f3-5e9063df15e8@xs4all.nl>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,


On 17-10-2016 12:37, Hans Verkuil wrote:
> Report of the V4L2 brainstorm meeting October 10-11 2016, Berlin

[snip]

> 4.4 Streamon and streamoff
>
> - How to handle STREAMON/OFF?
> 	- Pipelines without video nodes?
> 	- Buffer size may change. Need to reallocate buffers, which is currently done
> 	  through streamoff, reqbufs and streamon.
> - We probably want a STREAM_CANCEL which would dequeue pending buffers (requests)
>   without stopping streaming.
>
>

I am facing this scenario in my HDMI decoder driver. I have an
input stream which may change the resolution while streaming, so
I need to do off/reconfigure/on and request new buffer with the
new image size, and I also have to mark the previous buffers as
invalid. The automatic dequeue of pending buffers would help a
lot but still, at least in my case, I have to reconfigure the
controller and pipeline to propagate the new format.

Off topic: I am using the notify functions to inform user space
of a format change but it is not working at all with vlc or
mplayer :(. Does anyone know of any application which can handle
this format change correctly?

Best regards,
Jose Miguel Abreu
