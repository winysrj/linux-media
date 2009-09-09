Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:27058 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617AbZIITJu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Sep 2009 15:09:50 -0400
Received: by fg-out-1718.google.com with SMTP id 22so1399888fge.1
        for <linux-media@vger.kernel.org>; Wed, 09 Sep 2009 12:09:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <d9def9db0909091202x64b54600s4c499f0f4042a8e6@mail.gmail.com>
References: <200909091814.10092.animatrix30@gmail.com>
	 <829197380909090919o613827d0ye00cbfe3bde888ed@mail.gmail.com>
	 <d9def9db0909091202x64b54600s4c499f0f4042a8e6@mail.gmail.com>
Date: Wed, 9 Sep 2009 15:09:52 -0400
Message-ID: <829197380909091209x382089beqe805bf2b0895a67f@mail.gmail.com>
Subject: Re: Invalid module format
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Markus Rechberger <mrechberger@gmail.com>
Cc: Edouard Marquez <animatrix30@gmail.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Sep 9, 2009 at 3:02 PM, Markus Rechberger<mrechberger@gmail.com> wrote:
> this is not true my old driver which is not available anymore did not
> ship any other modules aside the em28xx driver itself.
> This is a video4linux issue and has nothing to do with it.
>
> Best Regards,
> Markus
>

Hello Marks,

While it is true that your driver did not include anything other than
em28xx, I assume it is compiled against a certain set of v4l2 headers,
and if those headers change (such as changes to data structures), then
the em28xx modules you distributed would not work with that version of
the v4l2 modules.

If he wants to use your driver, I would assume he would need to
reinstall the stock kernel (overwriting whatever locally built version
of v4l-dvb he previously installed).

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
