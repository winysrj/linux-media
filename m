Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:26163 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984AbZJaQXX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Oct 2009 12:23:23 -0400
Received: by fg-out-1718.google.com with SMTP id d23so276915fga.1
        for <linux-media@vger.kernel.org>; Sat, 31 Oct 2009 09:23:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4AEC2F03.6050205@gmail.com>
References: <4AEC2F03.6050205@gmail.com>
Date: Sat, 31 Oct 2009 12:23:27 -0400
Message-ID: <829197380910310923nf45eba5o29083127328c5d47@mail.gmail.com>
Subject: Re: [linux-dvb] somebody messed something on xc2028 code?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: linux-media@vger.kernel.org
Cc: linux-dvb@linuxtv.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Oct 31, 2009 at 8:35 AM, Albert Comerma
<albert.comerma@gmail.com> wrote:
> Hi all, I just updated my ubuntu to karmic and found with surprise that with
> 2.6.31 kernel my device does not work... It seems to be related to the
> xc2028 code part since the kernel explosion happens when you try to tune the
> device, here it's my dmesg, any idea?
>
> Albert

Oh, you're using the stock 2.6.31 which didn't get my fix yet.  Please
try the latest v4l-dvb tree and see if it still happens.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
