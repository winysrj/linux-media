Return-path: <linux-media-owner@vger.kernel.org>
Received: from znsun1.ifh.de ([141.34.1.16]:45997 "EHLO znsun1.ifh.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751883Ab0ADRl1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Jan 2010 12:41:27 -0500
Date: Mon, 4 Jan 2010 18:41:22 +0100 (CET)
From: Patrick Boettcher <pboettcher@kernellabs.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Call for Testers - dib0700 IR improvements
In-Reply-To: <829197381001040936w3bc9b4e0w22eecded4687d9d3@mail.gmail.com>
Message-ID: <alpine.LRH.2.00.1001041840210.23467@pub3.ifh.de>
References: <829197381001040936w3bc9b4e0w22eecded4687d9d3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 4 Jan 2010, Devin Heitmueller wrote:

> Hello all,
>
> I have done some refactoring of the dib0700 IR code for firmware 1.20,
> which should address concerns about the high load average when devices
> are connected.  It might also address people's reports of mt2060
> errors on the Nova-T 500 after several hours of operation (which would
> occur unless they used the disable_ir_polling modprobe option).
>
> I am looking for feedback from users who have dib0700 based devices
> and have reported problems with IR support in the past.  The tree can
> be found here:
>
> http://www.kernellabs.com/hg/~dheitmueller/dib0700_ir

Very good job.

Reviewed-by: Patrick Boettcher <pboettcher@kernellabs.com>

also

Acked-by: Patrick Boettcher <pboettcher@kernellabs.com>

Pick one.


Thanks,

--

Patrick Boettcher - Kernel Labs
http://www.kernellabs.com/
