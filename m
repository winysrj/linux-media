Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:56362 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576Ab2EUPUL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 May 2012 11:20:11 -0400
Received: by vbbff1 with SMTP id ff1so3553560vbb.19
        for <linux-media@vger.kernel.org>; Mon, 21 May 2012 08:20:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120521135801.GA21460@elgon.mountain>
References: <20120521135801.GA21460@elgon.mountain>
Date: Mon, 21 May 2012 11:20:10 -0400
Message-ID: <CAOcJUbx6mxeL1y_tEwefnyo4FG-SfbJ3Csw4Uxba9anS6bHehg@mail.gmail.com>
Subject: Re: [media] DVB: add support for the LG2160 ATSC-MH demodulator
From: Michael Krufky <mkrufky@linuxtv.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, May 21, 2012 at 9:58 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> Hi Michael,
>
> I have a question about e26f2ae4527b: "[media] DVB: add support for the
> LG2160 ATSC-MH demodulator" from Jan 29, 2012.
>
>   122  static int lg216x_write_regs(struct lg216x_state *state,
>   123                               struct lg216x_reg *regs, int len)
>   124  {
>   125          int i, ret;
>   126
>   127          lg_reg("writing %d registers...\n", len);
>   128
>   129          for (i = 0; i < len - 1; i++) {
>                            ^^^^^^^^^^^
> Shouldn't this just be i < len?  Why do we skip the last element in the
> array?
>
>   130                  ret = lg216x_write_reg(state, regs[i].reg, regs[i].val);
>   131                  if (lg_fail(ret))
>   132                          return ret;
>   133          }
>   134          return 0;
>   135  }
>
> This function is called like:
>        ret = lg216x_write_regs(state, lg2160_init, ARRAY_SIZE(lg2160_init));
>
> The last element of the lg2160_init[] array looks useful.

You're right, Dan - that's a bug -- thanks!

I'll queue up a fix for this.

Best Regards,

Mike Krufky
