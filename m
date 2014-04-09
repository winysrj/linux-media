Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:44294 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460AbaDIH4n (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Apr 2014 03:56:43 -0400
Received: by mail-ob0-f172.google.com with SMTP id wm4so2298445obc.31
        for <linux-media@vger.kernel.org>; Wed, 09 Apr 2014 00:56:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5344F747.6080103@samsung.com>
References: <1396876573-15811-1-git-send-email-j.anaszewski@samsung.com>
	<1396876573-15811-7-git-send-email-j.anaszewski@samsung.com>
	<CAK9yfHxXRXagZVAZhGjqH+qVGTAdP-=PnFw4O7HEU09UNB5Tsg@mail.gmail.com>
	<5344F747.6080103@samsung.com>
Date: Wed, 9 Apr 2014 13:26:43 +0530
Message-ID: <CAK9yfHz+F=pfNN7nQn-HE5L=uux+cVhBRoHa4wMjRT1VZTRTyw@mail.gmail.com>
Subject: Re: [PATCH 7/8] [media] s5p_jpeg: Prevent JPEG 4:2:0 > YUV 4:2:0 decompression
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacek,

On 9 April 2014 13:01, Jacek Anaszewski <j.anaszewski@samsung.com> wrote:
> On 04/08/2014 09:49 AM, Sachin Kamat wrote:
>>

> Hello Sachin,
>
> Thanks for the review. I put it into info message because this is
> rather hard for the user to figure out why the adjustment occurred,
> bearing in mind that JPEG with the same subsampling and even width
> is decompressed properly. This is not a common adjustment like
> alignment, and thus in my opinion it requires displaying the
> information. Are there some rules that say what cases are relevant
> for using the v4l2_info macro?

Not really, but generally info messages are concise and detailed explanations
provided as part of comments.

-- 
With warm regards,
Sachin
