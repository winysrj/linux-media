Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f213.google.com ([209.85.218.213]:46813 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753992AbZFUH2K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Jun 2009 03:28:10 -0400
Received: by bwz9 with SMTP id 9so2504087bwz.37
        for <linux-media@vger.kernel.org>; Sun, 21 Jun 2009 00:28:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200906202331.54058.tobias.lorenz@gmx.net>
References: <268161120906160611q32ac27a8r1574d4a9ffa63829@mail.gmail.com>
	 <208cbae30906161448q16a7e00bx31e6d3b3c35111e5@mail.gmail.com>
	 <268161120906171022j14645f78yf5e075679c30b57c@mail.gmail.com>
	 <200906202331.54058.tobias.lorenz@gmx.net>
Date: Sun, 21 Jun 2009 09:28:11 +0200
Message-ID: <268161120906210028t5351524ew703c6fc3a7bb2b8d@mail.gmail.com>
Subject: Re: [PATCH / resubmit] USB interrupt support for radio-si470x FM
	radio driver
From: Edouard Lafargue <edouard@lafargue.name>
To: Tobias Lorenz <tobias.lorenz@gmx.net>
Cc: Alexey Klimov <klimov.linux@gmail.com>,
	linux-media@vger.kernel.org,
	Douglas Schilling Landgraf <dougsland@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Jun 20, 2009 at 11:31 PM, Tobias Lorenz<tobias.lorenz@gmx.net> wrote:
>>    Thanks for all your help, now on to Tobias, I guess!
>
> perfect patch. Thank you Ed. I never figured out how to use interrupt URBs. This really seams to fix the click problem on unbuffered audio forwarding.

Thanks!

> The suggestion/question I have is if we want to keep the "users now" log messages in fops_open and fops_release.
> After all the testing today this fills up my logs...

Indeed, these messages are probably a bit too low-level, no problem to
remove them...

Regards,

Ed
