Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:41072 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753810AbaAATqi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Jan 2014 14:46:38 -0500
Received: by mail-wg0-f41.google.com with SMTP id y10so15675781wgg.0
        for <linux-media@vger.kernel.org>; Wed, 01 Jan 2014 11:46:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJghqerAVmCd_xcW9x2y=gKd4uq9-3P0CTmW_UpAjA42WQNNTw@mail.gmail.com>
References: <CAJghqepkKXth6_jqj5jU-HghAHxBBkaphCpR5MqfuRGXHXA4Sg@mail.gmail.com>
	<CAJghqeopSEER-ExtW8LhXYkCNH99Mwj5W7JCZAEf65CTpBu94Q@mail.gmail.com>
	<CAJghqerGcLUZCAT9LGP+5LzFLVCmHS1JUqNDTP1_Mj7b24fKhQ@mail.gmail.com>
	<1388254550.2129.83.camel@palomino.walls.org>
	<CAJghqeptMtc2OTUuCY8MUY14kj-d6KPpUAUCxjw8Nod6TNOMaA@mail.gmail.com>
	<1388586278.1879.21.camel@palomino.walls.org>
	<CAJghqerAVmCd_xcW9x2y=gKd4uq9-3P0CTmW_UpAjA42WQNNTw@mail.gmail.com>
Date: Wed, 1 Jan 2014 14:46:36 -0500
Message-ID: <CAGoCfixgun79tR_Nr+Qp9NdPPwYaUaX_HwqXj85rnOEXbEEH0w@mail.gmail.com>
Subject: Re: Fwd: v4l2: The device does not support the streaming I/O method.
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Andy <dssnosher@gmail.com>
Cc: Andy Walls <awalls@md.metrocast.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jan 1, 2014 at 2:41 PM, Andy <dssnosher@gmail.com> wrote:
> I am trying to stream /dev/video0 to http and encode it in h.264.

Last I checked, the ffmpeg v4l2 input interface is just for raw video.
 What you probably want to do is just use v4l2-ctl to setup the tuner
appropriately, and then pass in /dev/video0 as a standard filehandle
to ffmpeg (i.e. "-i /dev/video0").

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
