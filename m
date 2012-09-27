Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:34181 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755230Ab2I0VcJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Sep 2012 17:32:09 -0400
Received: by ieak13 with SMTP id k13so5735595iea.19
        for <linux-media@vger.kernel.org>; Thu, 27 Sep 2012 14:32:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <33718976.0Yia9PWmdN@avalon>
References: <CACUGKYPyquYDjHS0k1cuxWjyTX5+oypbe=Gm=nOz0-2jRYfbzg@mail.gmail.com>
	<33718976.0Yia9PWmdN@avalon>
Date: Thu, 27 Sep 2012 14:32:08 -0700
Message-ID: <CACUGKYPT48UY9Ri5XNDa4Qtd1JeqEjoJFmSX9NVJUtesSwRUgA@mail.gmail.com>
Subject: Re: ISPsupport
From: John Tobias <john.tobias.ph@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

I am using Pandaboard ES. I got it working now, although I am still
trying to figure out how to use the pipe, resizer, uyvy output instead
of SGRBG10.
Do you have some example for creating a pipe/link in media-ctl from
SGRBG10 to UYVY?.

Regards,

John



On Wed, Sep 26, 2012 at 4:33 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi John,
>
> On Monday 10 September 2012 20:00:54 John Tobias wrote:
>> Hi all,
>>
>> I tried devel-ISPSUPPORT-IPIPE and devel-ISPSUPPORT,
>
> It would help you you told use what hardware you're running on, what kernel
> version you're using, and what devel-ISPSUPPORT-IPIPE and devel-ISPSUPPORT
> are.
>
>> the kernel
>> detected my image sensor (ov5650). But, when I execute the "yavta
>> /dev/video0 -c4 -n1 -s2592x1944 -fSGRBG10 -Fov5650-2592x1944-#.bin" I
>> was getting "Unable to start streaming: Invalid argument (22).".
>>
>> I would like to know if anyone here can guide me a bit in order to
>> have a working environment?.
>
> --
> Regards,
>
> Laurent Pinchart
>
