Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f175.google.com ([209.85.192.175]:35959 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757898AbbEaGp7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 31 May 2015 02:45:59 -0400
MIME-Version: 1.0
Date: Sat, 30 May 2015 23:45:59 -0700
Message-ID: <CAB__kkkyqDYjKvMqege4_uPo8JuaCTTwHwp3HYyn8yf8TjFzoA@mail.gmail.com>
Subject: Re: [PATCH v2] [media] dvb-frontend: Replace timeval with ktime_t
From: Tina Ruchandani <ruchandani.tina@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: y2038@lists.linaro.org, linux-media@vger.kernel.org,
	Linux Kernel List <linux-kernel@vger.kernel.org>,
	Shuah Khan <shuah.kh@samsung.com>,
	Akihiro Tsukada <tskd08@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> --
> Changes in v2:
> - Use the more concise ktime_us_delta

Oops, please ignore this patch and please consider the v3 sent out
immediately after instead.

Tina
