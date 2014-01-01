Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f54.google.com ([74.125.82.54]:46501 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754736AbaAAWXA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Jan 2014 17:23:00 -0500
Received: by mail-wg0-f54.google.com with SMTP id n12so12182309wgh.9
        for <linux-media@vger.kernel.org>; Wed, 01 Jan 2014 14:22:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAGoCfiz1+7M4P7At7BrVZtVGM_4ntMZR6z4hTurhVzLNnG=Pcg@mail.gmail.com>
References: <CAJghqepkKXth6_jqj5jU-HghAHxBBkaphCpR5MqfuRGXHXA4Sg@mail.gmail.com>
	<CAJghqeopSEER-ExtW8LhXYkCNH99Mwj5W7JCZAEf65CTpBu94Q@mail.gmail.com>
	<CAJghqerGcLUZCAT9LGP+5LzFLVCmHS1JUqNDTP1_Mj7b24fKhQ@mail.gmail.com>
	<1388254550.2129.83.camel@palomino.walls.org>
	<CAJghqeptMtc2OTUuCY8MUY14kj-d6KPpUAUCxjw8Nod6TNOMaA@mail.gmail.com>
	<1388586278.1879.21.camel@palomino.walls.org>
	<CAJghqerAVmCd_xcW9x2y=gKd4uq9-3P0CTmW_UpAjA42WQNNTw@mail.gmail.com>
	<CAGoCfixgun79tR_Nr+Qp9NdPPwYaUaX_HwqXj85rnOEXbEEH0w@mail.gmail.com>
	<1388614684.2023.8.camel@palomino.walls.org>
	<CAGoCfiz1+7M4P7At7BrVZtVGM_4ntMZR6z4hTurhVzLNnG=Pcg@mail.gmail.com>
Date: Wed, 1 Jan 2014 17:22:59 -0500
Message-ID: <CAGoCfiwepBBtjD5R77f1M8aGpszVK6o-AjzLSy+VVxQsFN=opA@mail.gmail.com>
Subject: Re: Fwd: v4l2: The device does not support the streaming I/O method.
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Andy Walls <awalls@md.metrocast.net>
Cc: Andy <dssnosher@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jan 1, 2014 at 5:21 PM, Devin Heitmueller
<dheitmueller@kernellabs.com> wrote:
> On Wed, Jan 1, 2014 at 5:18 PM, Andy Walls <awalls@md.metrocast.net> wrote:
>> uncompressed video is available from /dev/video32 in an odd Conexant
>> macroblock format that is called 'HM12' under linux.

One more point worth making - I doubt ffmpeg supports HM12 natively.
You would either have to add the functionality to ffmpeg to do the
colorspace conversion, or you might be able to wrap ffmpeg around
libv4l2convert via LD_LIBRARY_PATH.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
