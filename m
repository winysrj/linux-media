Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:52141 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756840Ab2BYRT5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Feb 2012 12:19:57 -0500
Received: by bkcjm19 with SMTP id jm19so2747023bkc.19
        for <linux-media@vger.kernel.org>; Sat, 25 Feb 2012 09:19:56 -0800 (PST)
Message-ID: <4F49183A.6080105@googlemail.com>
Date: Sat, 25 Feb 2012 18:19:54 +0100
From: Gregor Jasny <gjasny@googlemail.com>
MIME-Version: 1.0
To: abel@uni-bielefeld.de
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH][libv4l] Bytes per Line
References: <4F3BD50A.3010608@uni-bielefeld.de> <4F3C31F9.8070000@googlemail.com> <4F42A22D.4010704@uni-bielefeld.de>
In-Reply-To: <4F42A22D.4010704@uni-bielefeld.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Robert,

On 2/20/12 8:42 PM, Robert Abel wrote:
> Anyway, the patch for bayer => rgb as well as bayer => yuv is attached.
> Basically, every time where width was assumed to be the offset to the
> neighboring pixel below, now step is used.

I reviewed your patch and it looks good to me. The only change I made
was renaming the step parameter into stride because this seems to be
more common. And forwarded the patch to Hans de Goede and asked for his Ack.

Could you please provide a Signed-off-by: line[1] for your patch?

Thanks,
Gregor

[1] http://gerrit.googlecode.com/svn/documentation/2.0/user-signedoffby.html

