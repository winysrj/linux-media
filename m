Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:54104 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754750AbaAAW3k (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 1 Jan 2014 17:29:40 -0500
Message-ID: <1388615498.2023.12.camel@palomino.walls.org>
Subject: Re: Fwd: v4l2: The device does not support the streaming I/O method.
From: Andy Walls <awalls@md.metrocast.net>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Andy <dssnosher@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Date: Wed, 01 Jan 2014 17:31:38 -0500
In-Reply-To: <CAGoCfiwepBBtjD5R77f1M8aGpszVK6o-AjzLSy+VVxQsFN=opA@mail.gmail.com>
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
	 <CAGoCfiwepBBtjD5R77f1M8aGpszVK6o-AjzLSy+VVxQsFN=opA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2014-01-01 at 17:22 -0500, Devin Heitmueller wrote:
> On Wed, Jan 1, 2014 at 5:21 PM, Devin Heitmueller
> <dheitmueller@kernellabs.com> wrote:
> > On Wed, Jan 1, 2014 at 5:18 PM, Andy Walls <awalls@md.metrocast.net> wrote:
> >> uncompressed video is available from /dev/video32 in an odd Conexant
> >> macroblock format that is called 'HM12' under linux.
> 
> One more point worth making - I doubt ffmpeg supports HM12 natively.

mplayer/mencoder knows how to handle HM12.

But yeah it's and odd format.  It is an intermediate by-product of the
CX23416's MPEG-2 encoding process.  It's kind of a debugging/bonus that
the chip provides the stream. 

> You would either have to add the functionality to ffmpeg to do the
> colorspace conversion, or you might be able to wrap ffmpeg around
> libv4l2convert via LD_LIBRARY_PATH.

Yeah.

> Devin

Regards,
Andy

