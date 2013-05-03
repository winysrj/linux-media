Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([94.23.35.102]:38069 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984Ab3ECCAc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 May 2013 22:00:32 -0400
Date: Thu, 2 May 2013 23:00:41 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Jon Arne =?utf-8?Q?J=C3=B8rgensen?= <jonarne@jonarne.no>
Cc: mchehab@redhat.com, linux-media@vger.kernel.org,
	jonjon.arnearne@gmail.com
Subject: Re: [PATCH 0/3] saa7115: add detection code for gm7113c
Message-ID: <20130503020039.GA5722@localhost>
References: <1367268069-11429-1-git-send-email-jonarne@jonarne.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1367268069-11429-1-git-send-email-jonarne@jonarne.no>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jon,

On Mon, Apr 29, 2013 at 10:41:06PM +0200, Jon Arne Jørgensen wrote:
> This is the second version of a patch-set previously posted by Mauro,
> the first verseon was posted on 26 April, and can be found here:
> http://www.spinics.net/lists/linux-media/msg63079.html
> 
> The purpose of this patch is to add support for the gm7113c chip in the saa7115 driver.
> The gm7113c chip is a chinese clone of the Philips/NXP saa7113 chip.
> The chip is found in several cheap usb video capture devices.
> 
>  drivers/media/i2c/saa7115.c     | 207 +++++++++++++++++++++++++++++-----------
>  include/media/v4l2-chip-ident.h |   2 +
>  2 files changed, 155 insertions(+), 54 deletions(-)
> 

Good work! Just some minor comments about the way the patchset
has been submitted.

First of all, this is a very ackward cover letter patch (cover letter is
the zero-index patch). I think you will find easier to use
git-format-patch command like this (just an example):
  
# Create a three-patch patchset:
$ git format-patch -3 --cover-letter --subject "PATCH v2" -o my-v2-patchset

-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
