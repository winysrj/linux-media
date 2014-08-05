Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yh0-f53.google.com ([209.85.213.53]:61498 "EHLO
	mail-yh0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133AbaHEOuL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Aug 2014 10:50:11 -0400
Received: by mail-yh0-f53.google.com with SMTP id c41so695417yho.26
        for <linux-media@vger.kernel.org>; Tue, 05 Aug 2014 07:50:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <53E0E7C4.8080205@xs4all.nl>
References: <53E080F6.30301@xs4all.nl>
	<CAKocOONtJJmnAELZzVG_4KdgrXrMrwXVGW=quh=vDqa+pm1tbQ@mail.gmail.com>
	<53E0E7C4.8080205@xs4all.nl>
Date: Tue, 5 Aug 2014 08:50:10 -0600
Message-ID: <CAKocOOMqM-Fu+3gFm65cY74VdegjZYFnb_A2ezOhh0U+Etb=FA@mail.gmail.com>
Subject: Re: [PATCH] em28xx: fix compiler warnings
From: Shuah Khan <shuahkhan@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	=?UTF-8?Q?Frank_Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Aug 5, 2014 at 8:18 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On 08/05/2014 03:57 PM, Shuah Khan wrote:
> I'm not sure what you mean. It *was* a local variable, that was the problem.
> There are two option: one is to add it to the main struct, then other is to
> allocate and free it inside the function. In general I dislike that since it
> adds aan extra check (did we really get the memory?) and you have to make sure
> you will free the memory. And that's besides the overhead of having to allocate
> memory. Originally I named tmp_i2c_client 'probe_i2c_client', but then I saw
> that the ir code needs it as well. If the ir code is fixed so it has its own
> i2c client, then the name can revert to probe_i2c_client.
>

Right. Adding it to the main structure is better than alloc and free the memory.
Would i2c_client_buf or i2c_client_data sound better than tmp_i2c_client?

-- Shuah
