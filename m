Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f42.google.com ([209.85.216.42]:65186 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbaCFWa7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Mar 2014 17:30:59 -0500
Received: by mail-qa0-f42.google.com with SMTP id k15so3252563qaq.15
        for <linux-media@vger.kernel.org>; Thu, 06 Mar 2014 14:30:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5318ED33.4040009@pinguin74.gmx.com>
References: <5318ED33.4040009@pinguin74.gmx.com>
Date: Thu, 6 Mar 2014 23:30:58 +0100
Message-ID: <CA+O4pCJ4OPGEC3_RUoxjPfScgL9vEGPbUOCefjNgFOrRcYvgMw@mail.gmail.com>
Subject: Re: sound dropouts with DVB
From: Markus Rechberger <mrechberger@gmail.com>
To: pinguin74 <pinguin74@gmx.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Thu, Mar 6, 2014 at 10:48 PM, pinguin74 <pinguin74@gmx.com> wrote:
> Hello,
>
> I use a Sundtek DVB-C stick with openSUSE 13.1 Linux.
>
> Most of the time, TV is just fine. But sometimes the sound just drops
> out, the sound disappears totally for up to 20 or 30 seconds. Usually
> sound returns. When sound drops out, there is no error message.
>
> Generally sound is fine, I use pulseaudio with KDE. The sound drop out
> happens only when watching TV.
>
> Is this a know issue with DVB? What could be the reason for the
> dropouts? The DVB-C signal is strong, usually 100%.
>

If you use mplayer, mplayer will show you if there's some stream corruption.
Other than that it could only be a codec issue.

Markus
> Would be nice to get a hint.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
