Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f180.google.com ([209.85.216.180]:37829 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951AbaCFXgE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Mar 2014 18:36:04 -0500
Received: by mail-qc0-f180.google.com with SMTP id x3so3839357qcv.25
        for <linux-media@vger.kernel.org>; Thu, 06 Mar 2014 15:36:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <53190270.80407@pinguin74.gmx.com>
References: <5318ED33.4040009@pinguin74.gmx.com>
	<CA+O4pCJ4OPGEC3_RUoxjPfScgL9vEGPbUOCefjNgFOrRcYvgMw@mail.gmail.com>
	<53190270.80407@pinguin74.gmx.com>
Date: Fri, 7 Mar 2014 00:36:02 +0100
Message-ID: <CA+O4pC+R8ZXZ_wYfa2y82TPwCD4q_fUh96pgbYu2VUhVyGPGvQ@mail.gmail.com>
Subject: Re: sound dropouts with DVB
From: Markus Rechberger <mrechberger@gmail.com>
To: pinguin74 <pinguin74@gmx.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 7, 2014 at 12:19 AM, pinguin74 <pinguin74@gmx.com> wrote:
>>> Most of the time, TV is just fine. But sometimes the sound just drops
>>> out, the sound disappears totally for up to 20 or 30 seconds. Usually
>>> sound returns. When sound drops out, there is no error message.
>>>
>> If you use mplayer, mplayer will show you if there's some stream corruption.
>> Other than that it could only be a codec issue.
>
> I will try with mplayer later. What does codec issue mean? I think the
> audio stream in DVB-C is a digital stream that does not need to be
> changed or encoded in any way? I thought DVB playback simply is a kind
> of pass thru the digital streamt to the media player....
>
>

The mediaplayer is using a codec for decoding/unpacking the compressed
digital stream.

Markus


> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
