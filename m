Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:33273 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786Ab2HBPAu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Aug 2012 11:00:50 -0400
Received: by eeil10 with SMTP id l10so2418930eei.19
        for <linux-media@vger.kernel.org>; Thu, 02 Aug 2012 08:00:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <bdafbcab-4074-4557-b108-a76f00ab8b3e@email.android.com>
References: <50186040.1050908@lockie.ca>
	<c5ac2603-cc98-4688-b50c-b9166cada8f0@email.android.com>
	<5019EE10.1000207@lockie.ca>
	<bdafbcab-4074-4557-b108-a76f00ab8b3e@email.android.com>
Date: Thu, 2 Aug 2012 11:00:47 -0400
Message-ID: <CAGoCfiwN=h708e65DmZi7m6gcRMmcRbRZGJvpJ6ZzUk9Cm22dQ@mail.gmail.com>
Subject: Re: 3.5 kernel options for Hauppauge_WinTV-HVR-1250
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Andy Walls <awalls@md.metrocast.net>
Cc: James <bjlockie@lockie.ca>,
	linux-media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Aug 2, 2012 at 5:53 AM, Andy Walls <awalls@md.metrocast.net> wrote:
> You can 'grep MODULE_ drivers/media/video/cx23885/* drivers/media/video/cx25840/* ' and other relevant directories under drivers/media/{dvb, common} to find all the parameter options for all the drivers involved in making a HVR_1250 work.

Or just build with everything enabled until you know it is working,
and then optimize the list of modules later.

Also, the 1250 is broken for analog until very recently (patches went
upstream for 3.5/3.6 a few days ago).

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
