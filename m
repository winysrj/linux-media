Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:38435 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256AbbKBU7F (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Nov 2015 15:59:05 -0500
Received: by wicll6 with SMTP id ll6so57996596wic.1
        for <linux-media@vger.kernel.org>; Mon, 02 Nov 2015 12:59:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAK_-F2+UfGOKSNYffVdRau96TF_ZdrpM1aD8=e73PQvfOY5TbA@mail.gmail.com>
References: <CAK_-F2+UfGOKSNYffVdRau96TF_ZdrpM1aD8=e73PQvfOY5TbA@mail.gmail.com>
Date: Mon, 2 Nov 2015 13:59:02 -0700
Message-ID: <CAEEHgGXEcqEmvZN6D4Ua7AOG9zsA2+G1MHJyfq6L23wJsghcmQ@mail.gmail.com>
Subject: Re: au0828: start_urb_transfer: failed big buffer allocation, err = -12
From: Tim Mester <tmester@ieee.org>
To: Ken Harris <kjh@hokulea.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ken,

  You could set the module parameter preallocate_big_buffers=1 when
you insmod the au8028 kernel module.  When this parameter is set, the
driver will allocate the big buffers once when the module is loaded
instead of every time the device is opened for streaming.

  Thanks,

  Tim

On Fri, Oct 30, 2015 at 12:07 PM, Ken Harris <kjh@hokulea.org> wrote:
> Greetings
>
> Dunno if this is the right place to post this.  Let me know if there
> is a better place.
>
> I'm recording with a "DViCO FusionHDTV USB" gadget.
>
> It records for an hour or so just fine, but when it starts up the
> second time, it doesn't work and I get a lot of kernel messages that
> seem to trace back to :
>
> au0828: start_urb_transfer: failed big buffer allocation, err = -12
>
> This is a Fedora 22 system ( Linux 4.2.3-200.fc22.i686+PAE )
>
> Attached is dmesg output.
>
> Any tips are appreciated.
>
> Thanks,
> Ken
