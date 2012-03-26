Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:49203 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932652Ab2CZOt2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Mar 2012 10:49:28 -0400
Received: by vcqp1 with SMTP id p1so4395387vcq.19
        for <linux-media@vger.kernel.org>; Mon, 26 Mar 2012 07:49:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGoCfix+iDFg86nYKqQOn1=DKHWp8Fj+iFdKZgcQjxKKf4uyow@mail.gmail.com>
References: <assp.243108522f.1332706154.31585.245.camel@paddy.ipb-sub.ipb-halle.de>
	<CAGoCfix+iDFg86nYKqQOn1=DKHWp8Fj+iFdKZgcQjxKKf4uyow@mail.gmail.com>
Date: Mon, 26 Mar 2012 10:49:27 -0400
Message-ID: <CAGoCfiza2FcrFETEeP_PdZvzdW0YuiKm4AP=wMTG465f9zBA9w@mail.gmail.com>
Subject: Re: Hauppauge WinTV HVR 930C-HD - new USB ID 2040:b130 ?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Steffen Neumann <sneumann@ipb-halle.de>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Mar 26, 2012 at 10:46 AM, Devin Heitmueller
<dheitmueller@kernellabs.com> wrote:
> 2040:b130 isn't an em28xx based device.  It uses cx231xx.  That said,
> it's not supported under Linux not because of the cx231xx driver but
> because there is no driver for the demodulator (si2163).

Correction:  it's an si2165 (not 2163).

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
