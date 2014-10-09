Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:36589 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbaJIRqK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Oct 2014 13:46:10 -0400
Received: by mail-wg0-f42.google.com with SMTP id z12so1931835wgg.25
        for <linux-media@vger.kernel.org>; Thu, 09 Oct 2014 10:46:08 -0700 (PDT)
Message-ID: <5436C9DF.8090001@googlemail.com>
Date: Thu, 09 Oct 2014 19:46:07 +0200
From: Gregor Jasny <gjasny@googlemail.com>
MIME-Version: 1.0
To: Jacek Anaszewski <j.anaszewski@samsung.com>,
	linux-media@vger.kernel.org
CC: kyungmin.park@samsung.com, s.nawrocki@samsung.com
Subject: Re: [PATCH/RFC 0/1] Libv4l: Add a plugin for the Exynos4 camera
References: <1412757980-23570-1-git-send-email-j.anaszewski@samsung.com>
In-Reply-To: <1412757980-23570-1-git-send-email-j.anaszewski@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 08/10/14 10:46, Jacek Anaszewski wrote:
> This patch adds a plugin for the Exynos4 camera. I wanted to split
> at least the parser part to the separate module but encountered
> some problems with autotools configuration and therefore I'd like
> to ask for an instruction on how to adjust the Makefile.am files
> to achieve this.

I was the one who authored the v4l-utils build system. It looks a little
bit messy because of all the supported configurations and toolchain
capabilities.

Feel free to ask if you have any questions.

Thanks,
Gregor
