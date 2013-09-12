Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:37828 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406Ab3ILXfk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Sep 2013 19:35:40 -0400
Received: by mail-ee0-f46.google.com with SMTP id c13so220719eek.19
        for <linux-media@vger.kernel.org>; Thu, 12 Sep 2013 16:35:38 -0700 (PDT)
Date: Fri, 13 Sep 2013 01:35:35 +0200
From: =?UTF-8?B?QW5kcsOp?= Roth <neolynx@gmail.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 0/3] Some improvements/fixes for Siano driver
Message-ID: <20130913013535.023fd215@neutrino.exnihilo>
In-Reply-To: <1379016000-19577-1-git-send-email-m.chehab@samsung.com>
References: <1379016000-19577-1-git-send-email-m.chehab@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 12 Sep 2013 16:59:57 -0300
Mauro Carvalho Chehab <m.chehab@samsung.com> wrote:

Tested-by: André Roth <neolynx@gmail.com>


> I got a few reports those days about Siano regressions/issues.
> 
> The first one was reported at:
>        https://bugzilla.kernel.org/show_bug.cgi?id=60645
> 
> While its fix was already upstream, the "error" messages there doesn't
> help, as it induced people to believe that it was a firmware related
> error.
> 
> The second one was reported via IRC, and it is related to the first
> generation of Siano devices (sms1000).
> 
> It was a regression caused on kernel 3.9, that made those devices to
> fail.
> 
> It turns that, on those devices, the driver should first initialize
> one USB ID and load a firmware. After firmware load, the device got
> replaced by another USB ID, and the device initialization can be
> done, on a diferent USB Interface.
> 
> This series fixes the second issue and improves the debug message,
> in order to make easier to identify what's going wrong at the
> init process.
> 
> Mauro Carvalho Chehab (3):
>   [media] siano: Don't show debug messages as errors
>   [media] siano: Improve debug/info messages
>   [media] siano: Fix initialization for Stellar models
> 
>  drivers/media/common/siano/smscoreapi.c |  4 ++--
>  drivers/media/usb/siano/smsusb.c        | 40 +++++++++++++++++++++++----------
>  2 files changed, 30 insertions(+), 14 deletions(-)
> 
