Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yh0-f51.google.com ([209.85.213.51]:53252 "EHLO
	mail-yh0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408AbaDGHrH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Apr 2014 03:47:07 -0400
Received: by mail-yh0-f51.google.com with SMTP id f10so5474778yha.10
        for <linux-media@vger.kernel.org>; Mon, 07 Apr 2014 00:47:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <53425646.3000003@xs4all.nl>
References: <1394486458-9836-1-git-send-email-hverkuil@xs4all.nl>
 <1394486458-9836-4-git-send-email-hverkuil@xs4all.nl> <CAMm-=zCtWq=4_g9aweU6Hc=_ONscHLMegytFWXMjoC7edi1O2g@mail.gmail.com>
 <53425646.3000003@xs4all.nl>
From: Pawel Osciak <pawel@osciak.com>
Date: Mon, 7 Apr 2014 16:46:26 +0900
Message-ID: <CAMm-=zDOWmWp==-pdRSUSx+U7AA-NES3ZJXtA-gN+MrSyQw7Og@mail.gmail.com>
Subject: Re: [REVIEW PATCH 03/11] vb2: if bytesused is 0, then fill with
 output buffer length
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: LMML <linux-media@vger.kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Apr 7, 2014 at 4:39 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On 04/07/2014 09:20 AM, Pawel Osciak wrote:
>> I'm thinking, that if we are doing this, perhaps we should just update
>> the API to allow this case, i.e. say that if the bytesused is not set
>
> With 'not set' you mean 'is 0', right?

Yes, correct.

>
>> for any planes, length will be used by default?
>> This would be backwards-compatible.
>
> I agree with that. I'll update the doc.
>
> Regards,
>
>         Hans
>
