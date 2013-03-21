Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f178.google.com ([209.85.216.178]:58148 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755268Ab3CUN2r (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Mar 2013 09:28:47 -0400
Received: by mail-qc0-f178.google.com with SMTP id d10so724617qca.9
        for <linux-media@vger.kernel.org>; Thu, 21 Mar 2013 06:28:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <151543510.hNXiaIfEAr@avalon>
References: <201303031137.44917@leon.remlab.net>
	<CAGoCfixOsn4eTp7NYmJSK-LJTqF677LXf8fgTzrz4KFgPN7znw@mail.gmail.com>
	<151543510.hNXiaIfEAr@avalon>
Date: Thu, 21 Mar 2013 09:28:46 -0400
Message-ID: <CAGoCfixEqNn0pfN9t7oVOinFj3FVtH--P7c_o0xzuBHkS2+UsA@mail.gmail.com>
Subject: Re: uvcvideo USERPTR mode busted?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: =?ISO-8859-1?Q?R=E9mi_Denis=2DCourmont?= <remi@remlab.net>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Mar 21, 2013 at 8:41 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Please submit it at some point :-)
>
> Is it a uvcvideo issue or a videobuf2 issue ?

Yeah, it's definitely on my list.  Basically if you hand
videobuf2-vmalloc a piece of memory that is not page aligned, it gets
treated as if paged aligned, which causes the first N bytes of every
video frame to be garbage and the video is shifted right by N bytes.
I saw the issue with both uvcvideo as well as em28xx.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
