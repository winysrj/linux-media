Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:37728 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752341AbbGFSGv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Jul 2015 14:06:51 -0400
Received: by wiclp1 with SMTP id lp1so28838302wic.0
        for <linux-media@vger.kernel.org>; Mon, 06 Jul 2015 11:06:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <559A915B.20305@vanguardiasur.com.ar>
References: <m3bnftphea.fsf@t19.piap.pl>
	<m37fqhpe35.fsf@t19.piap.pl>
	<559A915B.20305@vanguardiasur.com.ar>
Date: Mon, 6 Jul 2015 15:06:50 -0300
Message-ID: <CAAEAJfA7hPzZ3vHUUMhHvosoGzPWq1HCcKURHMp=w+B7siex5w@mail.gmail.com>
Subject: Re: [PATCH] [MEDIA] Add support for TW686[4589]-based frame grabbers.
From: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
To: =?UTF-8?Q?Krzysztof_Ha=C5=82asa?= <khalasa@piap.pl>,
	linux-media <linux-media@vger.kernel.org>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 6 July 2015 at 11:31, Ezequiel Garcia <ezequiel@vanguardiasur.com.ar> wrote:
> Hi Krzysztof,
>
> First of all: thanks a lot for the good work!
> The driver looks very clean and promising.
>
> I've been playing with it a lot and have quite a bit
> of feedback.
>
> First of all, I've noticed you only supported TOP, BOTTOM
> and SEQUENTIAL fields. Is there no way to get an interlaced
> frame out of the driver?
>

Answering my own question, Krzysztof already replied about
this on another thread:

http://www.spinics.net/lists/linux-media/msg91470.html

Quoting him:

""
These (tw686x) chips aren't ideal - but they work.
For example, in DMA SG mode, they can't produce a single continuous
interlaced frame in memory - they can only make two separate fields.
A limitation of their DMA engine, since in non-SG mode they can make
(pseudo)-progressive frames.
""

-- 
Ezequiel García, VanguardiaSur
www.vanguardiasur.com.ar
