Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f180.google.com ([209.85.215.180]:61747 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256AbaAHUyo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Jan 2014 15:54:44 -0500
Message-ID: <52CDBB0F.8010505@gmail.com>
Date: Wed, 08 Jan 2014 21:54:39 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: m silverstri <michael.j.silverstri@gmail.com>
CC: linux-samsung-soc@vger.kernel.org,
	LMML <linux-media@vger.kernel.org>
Subject: Re: Looking for example to use samsung jpeg v4l2 mem2mem driver
References: <CABMudhTUQ1mBLTHnm50dWrZaOhRciTc8J_jET1xLho8pm8iC7Q@mail.gmail.com>
In-Reply-To: <CABMudhTUQ1mBLTHnm50dWrZaOhRciTc8J_jET1xLho8pm8iC7Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 01/01/2014 12:39 AM, m silverstri wrote:
> Hi,
>
> I am looking for an example which uses samsung jpeg v4l2 mem2mem driver.
> For example the 'Exynos4 JPEG codec v4l2 driver' described here
> http://lwn.net/Articles/468547
>
>
> I am new to linux v4l2 driver. I am looking for example to pass an
> input image to hardware accelerated encoder/decoder.

I have pushed some test application to a git repository at [1]. It can be
used for JPEG files encoding/decoding with the mainline s5p-jpeg driver.
A v4l2-jpeg-codec-test directory should appear there within few hours.

[1] http://git.infradead.org/users/kmpark/public-apps/tree/refs/heads/master

Regards,
Sylwester
