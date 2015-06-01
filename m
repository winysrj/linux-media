Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:33430 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006AbbFAVLk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Jun 2015 17:11:40 -0400
Received: by lbcue7 with SMTP id ue7so92461479lbc.0
        for <linux-media@vger.kernel.org>; Mon, 01 Jun 2015 14:11:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <556C0455.30101@xs4all.nl>
References: <556C0455.30101@xs4all.nl>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Mon, 1 Jun 2015 23:11:18 +0200
Message-ID: <CAPybu_362aenDssE3RHDQy=ZDQ352Hm7UaCoFybOae88R=RF-g@mail.gmail.com>
Subject: Re: [PATCH] Improve Y16 color setup
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hans


On Mon, Jun 1, 2015 at 9:05 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Currently the colors for the Y16 and Y16_BE pixelformats are in the range
> 0x0000-0xff00. So pure white (0xffff) is never created.
>
> Improve this by using the same byte for both LSB and MSB so the full range
> is achieved.


If someone uses vivid as reference (I sometimes do), this could lead
to incorrect implementations. If the user don't implement the
endianess right he will never notice. I have carried out an endianness
bug for some months, until gstreamer was showing "funny" ;) images.

If the problem is that you want to reach saturation, I would rather
setting the lsb to 0xff all the time. (i.e. going from 0x00ff to
0xffff).

If we want saturation and zero, we could set the lsb to val?0xff:0;



Regards!
