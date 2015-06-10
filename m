Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:33939 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681AbbFJWQ3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Jun 2015 18:16:29 -0400
Received: by wibut5 with SMTP id ut5so60400110wib.1
        for <linux-media@vger.kernel.org>; Wed, 10 Jun 2015 15:16:28 -0700 (PDT)
Message-ID: <5578B73C.2070608@gmail.com>
Date: Wed, 10 Jun 2015 23:16:28 +0100
From: Andy Furniss <adf.lists@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: linux-media@vger.kernel.org
Subject: Re: dvbv5-tzap with pctv 290e/292e needs EAGAIN for pat/pmt
 to work when recording.
References: <556E2D5B.5080201@gmail.com>	<20150610095215.79e5e77e@recife.lan>	<55787382.5010607@gmail.com>	<20150610155047.25b92662@recife.lan> <20150610171732.49e60671@recife.lan>
In-Reply-To: <20150610171732.49e60671@recife.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab wrote:

> Actually, there was an error on that patch. I did some tests here
> with a PCTV 292e. While I was not able to reproduce the issue you're
> reporting, I forced some errors. The patch should be working. The
> only question is if 1 second is enough or not.
>
> So, please test.
>
> PS.: the patch was already merged upstream.

OK testing clean updated tree - it still instantly bails.

I am a bit confused how these patches would help - I am getting the
EAGAIN on the data read in dvb_get_pmt_pid not the ioctl.

Maybe this read should be delayed until lock is stable like the actual
recording seems to be?

