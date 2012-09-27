Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.mlbassoc.com ([65.100.170.105]:57741 "EHLO
	mail.chez-thomas.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755874Ab2I0WB3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Sep 2012 18:01:29 -0400
Message-ID: <5064CAF2.2040703@mlbassoc.com>
Date: Thu, 27 Sep 2012 15:53:54 -0600
From: Gary Thomas <gary@mlbassoc.com>
MIME-Version: 1.0
To: John Tobias <john.tobias.ph@gmail.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Subject: Re: ISPsupport
References: <CACUGKYPyquYDjHS0k1cuxWjyTX5+oypbe=Gm=nOz0-2jRYfbzg@mail.gmail.com> <33718976.0Yia9PWmdN@avalon> <CACUGKYPT48UY9Ri5XNDa4Qtd1JeqEjoJFmSX9NVJUtesSwRUgA@mail.gmail.com>
In-Reply-To: <CACUGKYPT48UY9Ri5XNDa4Qtd1JeqEjoJFmSX9NVJUtesSwRUgA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2012-09-27 15:32, John Tobias wrote:
> Hi Laurent,
>
> I am using Pandaboard ES. I got it working now, although I am still
> trying to figure out how to use the pipe, resizer, uyvy output instead
> of SGRBG10.
> Do you have some example for creating a pipe/link in media-ctl from
> SGRBG10 to UYVY?.

You can try this, but I wasn't able to make it work & TI haven't been
any help figuring out why (the media-control based pipelines are not
officially supported by TI)

   media-ctl -r
   media-ctl -l '"OMAP4 ISS CSI2a":1 -> "OMAP4 ISS ISP IPIPEIF":0 [1]'
   media-ctl -l '"OMAP4 ISS ISP IPIPEIF":2 -> "OMAP4 ISS ISP IPIPE":0 [1]'
   media-ctl -l '"OMAP4 ISS ISP IPIPE":1 -> "OMAP4 ISS ISP resizer":0 [1]'
   media-ctl -l '"OMAP4 ISS ISP resizer":1 -> "OMAP4 ISS ISP resizer a output":0 [1]'

   media-ctl -V '"ov5650 3-0036":0 [SGRBG10 2592x1944]'
   media-ctl -V '"OMAP4 ISS CSI2a":0 [SGRBG10 2592x1944]'
   media-ctl -V '"OMAP4 ISS ISP IPIPEIF":0 [SGRBG10 2592x1944]'
   media-ctl -V '"OMAP4 ISS ISP IPIPE":0 [SGRBG10 2592x1944]'
   media-ctl -f '"OMAP4 ISS ISP resizer":0 [UYVY 2592x1944]'

If you can make it go, please let me/us know how!

> On Wed, Sep 26, 2012 at 4:33 AM, Laurent Pinchart
> <laurent.pinchart@ideasonboard.com> wrote:
>> Hi John,
>>
>> On Monday 10 September 2012 20:00:54 John Tobias wrote:
>>> Hi all,
>>>
>>> I tried devel-ISPSUPPORT-IPIPE and devel-ISPSUPPORT,
>>
>> It would help you you told use what hardware you're running on, what kernel
>> version you're using, and what devel-ISPSUPPORT-IPIPE and devel-ISPSUPPORT
>> are.
>>
>>> the kernel
>>> detected my image sensor (ov5650). But, when I execute the "yavta
>>> /dev/video0 -c4 -n1 -s2592x1944 -fSGRBG10 -Fov5650-2592x1944-#.bin" I
>>> was getting "Unable to start streaming: Invalid argument (22).".
>>>
>>> I would like to know if anyone here can guide me a bit in order to
>>> have a working environment?.
>>
>> --
>> Regards,
>>
>> Laurent Pinchart
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

-- 
------------------------------------------------------------
Gary Thomas                 |  Consulting for the
MLB Associates              |    Embedded world
------------------------------------------------------------
