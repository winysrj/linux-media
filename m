Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f171.google.com ([209.85.214.171]:45334 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840AbaAJSII (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jan 2014 13:08:08 -0500
MIME-Version: 1.0
In-Reply-To: <52CDBB0F.8010505@gmail.com>
References: <CABMudhTUQ1mBLTHnm50dWrZaOhRciTc8J_jET1xLho8pm8iC7Q@mail.gmail.com>
	<52CDBB0F.8010505@gmail.com>
Date: Fri, 10 Jan 2014 10:08:07 -0800
Message-ID: <CABMudhQ5TNn8BAxiNUTts7TsL8m_Y7EOV6Gw4z_a2BoOJ+UHdw@mail.gmail.com>
Subject: Re: Looking for example to use samsung jpeg v4l2 mem2mem driver
From: m silverstri <michael.j.silverstri@gmail.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: linux-samsung-soc@vger.kernel.org,
	LMML <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks for the test application.

But I don' see the test directory in the repository mention here:
http://git.infradead.org/users/kmpark/public-apps/tree/refs/heads/master

Thank you again.

On Wed, Jan 8, 2014 at 12:54 PM, Sylwester Nawrocki
<sylvester.nawrocki@gmail.com> wrote:
> Hi,
>
>
> On 01/01/2014 12:39 AM, m silverstri wrote:
>>
>> Hi,
>>
>> I am looking for an example which uses samsung jpeg v4l2 mem2mem driver.
>> For example the 'Exynos4 JPEG codec v4l2 driver' described here
>> http://lwn.net/Articles/468547
>>
>>
>> I am new to linux v4l2 driver. I am looking for example to pass an
>> input image to hardware accelerated encoder/decoder.
>
>
> I have pushed some test application to a git repository at [1]. It can be
> used for JPEG files encoding/decoding with the mainline s5p-jpeg driver.
> A v4l2-jpeg-codec-test directory should appear there within few hours.
>
> [1] http://git.infradead.org/users/kmpark/public-apps/tree/refs/heads/master
>
> Regards,
> Sylwester
