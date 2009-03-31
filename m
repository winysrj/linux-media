Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f118.google.com ([209.85.221.118]:41885 "EHLO
	mail-qy0-f118.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753572AbZCaC5k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Mar 2009 22:57:40 -0400
Received: by qyk16 with SMTP id 16so4196416qyk.33
        for <linux-media@vger.kernel.org>; Mon, 30 Mar 2009 19:57:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <15ed362e0903301947rf0de73eo8edbd8cbcd5b5abd@mail.gmail.com>
References: <15ed362e0903301947rf0de73eo8edbd8cbcd5b5abd@mail.gmail.com>
Date: Mon, 30 Mar 2009 22:57:38 -0400
Message-ID: <412bdbff0903301957i77c36f10hcb9e9cb919124057@mail.gmail.com>
Subject: Re: XC5000 DVB-T/DMB-TH support
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: David Wong <davidtlwong@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Mar 30, 2009 at 10:47 PM, David Wong <davidtlwong@gmail.com> wrote:
> Does anyone know how to get XC5000 working for DVB-T, especially 8MHz bandwidth?
> Current driver only supports ATSC with 6MHz bandwidth only.
> It seems there is a trick at setting compensated RF frequency.
>
> DVB-T 8MHz support would probably works for DMB-TH, but DMB-TH
> settings is very welcome.
>
> Regards,
> David
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

All of my xc5000 work has been with ATSC/QAM, so I can't say
authoritatively what is required to make it work.

Well, at a minimum you will have to modify xc5000_set_params to
support setting priv->video_standard to DTV8.  Beyond that, I don't
think you need to do anything specific for DVB-T.

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller
