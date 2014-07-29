Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:50177 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261AbaG2RUi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Jul 2014 13:20:38 -0400
Received: by mail-wg0-f51.google.com with SMTP id b13so9313282wgh.34
        for <linux-media@vger.kernel.org>; Tue, 29 Jul 2014 10:20:34 -0700 (PDT)
Message-ID: <53D7D826.2020703@googlemail.com>
Date: Tue, 29 Jul 2014 19:21:42 +0200
From: =?ISO-8859-15?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: em28xx vb2 warnings
References: <53D283B9.9080204@googlemail.com> <53D66BFD.6020809@xs4all.nl>
In-Reply-To: <53D66BFD.6020809@xs4all.nl>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am 28.07.2014 um 17:27 schrieb Hans Verkuil:
...
> OK, I looked at it: the problem is in get_next_buf() and finish_field_prepare_next().
> In get_next_buf() the driver gets a buffer from the active list and deletes it from
> that list. In finish_field_prepare_next() that buffer is given back to vb2 via
> finish_buffer().
>
> But if you stop streaming and em28xx_stop_streaming() is called, then that buffer that
> is being processed isn't part of the active list anymore and so it is never given back.
>
> em28xx_stop_streaming() should give that buffer back as well, and that will keep
> everything in balance. The easiest solution seems to be to move the list_del() call
> from get_next_buf() to finish_buffer(). It seemed to work in a quick test, but I
> haven't looked at vbi support or corner cases. I leave that to you :-)

Ok, thank you so far Hans !
I will see what I can do.

Regards,
Frank


