Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:33053 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753841AbdJaR2B (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Oct 2017 13:28:01 -0400
Date: Tue, 31 Oct 2017 17:27:58 +0000
From: Sean Young <sean@mess.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Kees Cook <keescook@chromium.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: av7110: switch to useing timer_setup()
Message-ID: <20171031172758.ugfo6br344iso4ni@gofer.mess.org>
References: <20171025004005.hyb43h3yvovp4is2@dtor-ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171025004005.hyb43h3yvovp4is2@dtor-ws>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Oct 24, 2017 at 05:40:05PM -0700, Dmitry Torokhov wrote:
> In preparation for unconditionally passing the struct timer_list pointer to
> all timer callbacks, switch to using the new timer_setup() and from_timer()
> to pass the timer pointer explicitly.
> 
> Also stop poking into input core internals and override its autorepeat
> timer function. I am not sure why we have such convoluted autorepeat
> handling in this driver instead of letting input core handle autorepeat,
> but this preserves current behavior of allowing controlling autorepeat
> delay and forcing autorepeat period to be whatever the hardware has.

I think a better solution is to remove the autorepeat handling completely,
and leave it up to the input layer. This simplies the driver greatly and
I don't see how this makes sense for an IR driver. The IR protocols
specify the IR should repeat the message at set intervals whilst a 
button is pressed; this has no relation to autorepeat.

Ideally this driver would be converted to rc-core, but without access to
the hardware I'm not sure that is a great idea. The keymap handling is
very convolated so I have no idea what the scancodes for the remote(s) are,
for example. Any suggestions for what hardware to get off ebay for this?

New patch will be reply this.

Thanks,

Sean
