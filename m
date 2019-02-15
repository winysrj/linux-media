Return-Path: <SRS0=2oy6=QW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9648EC43381
	for <linux-media@archiver.kernel.org>; Fri, 15 Feb 2019 20:51:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5C149222D9
	for <linux-media@archiver.kernel.org>; Fri, 15 Feb 2019 20:51:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="FPzqSCU2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390697AbfBOUvR (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 15 Feb 2019 15:51:17 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:34866 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391777AbfBOUvP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Feb 2019 15:51:15 -0500
Received: from [192.168.1.72] (host86-165-126-182.range86-165.btcentralplus.com [86.165.126.182])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id B14BE2D6;
        Fri, 15 Feb 2019 21:51:11 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1550263872;
        bh=aLo61eL9mHzqL6GslNRmhb03jrz+Op+5V+WkaEf74TU=;
        h=Reply-To:Subject:To:References:Cc:From:Date:In-Reply-To:From;
        b=FPzqSCU20mrM44PBnwGu+hgYAAiw0L/LOnXgcr0owXYpXHvmu4Httq+ZazFAvvs5f
         9mMMttnUqT0WZ1xS8MUWR150YZBCTB+N9Ake3FgbkIsZEmhiFbq55xnpN87ZF6bYM9
         Jlv9LISmpkzzt0uRMfE0LsuUffQzBJMcu/Aaun2M=
Reply-To: kieran.bingham@ideasonboard.com
Subject: Re: [linux-uvc-devel] metadata device file
To:     =?UTF-8?Q?Moritz_D=c3=b6tterl?= <moritz.doetterl@pentlandfirth.com>,
        "linux-uvc-devel@lists.berlios.de" <linux-uvc-devel@lists.berlios.de>
References: <d6a7d5e54acd4cb6b71eacf0724a92e4AM0PR10MB2788C3DEE0DF6144DAFA6FA1F0600@AM0PR10MB2788.EURPRD10.PROD.OUTLOOK.COM>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
From:   Kieran Bingham <kieran.bingham@ideasonboard.com>
Openpgp: preference=signencrypt
Autocrypt: addr=kieran.bingham@ideasonboard.com; keydata=
 mQINBFYE/WYBEACs1PwjMD9rgCu1hlIiUA1AXR4rv2v+BCLUq//vrX5S5bjzxKAryRf0uHat
 V/zwz6hiDrZuHUACDB7X8OaQcwhLaVlq6byfoBr25+hbZG7G3+5EUl9cQ7dQEdvNj6V6y/SC
 rRanWfelwQThCHckbobWiQJfK9n7rYNcPMq9B8e9F020LFH7Kj6YmO95ewJGgLm+idg1Kb3C
 potzWkXc1xmPzcQ1fvQMOfMwdS+4SNw4rY9f07Xb2K99rjMwZVDgESKIzhsDB5GY465sCsiQ
 cSAZRxqE49RTBq2+EQsbrQpIc8XiffAB8qexh5/QPzCmR4kJgCGeHIXBtgRj+nIkCJPZvZtf
 Kr2EAbc6tgg6DkAEHJb+1okosV09+0+TXywYvtEop/WUOWQ+zo+Y/OBd+8Ptgt1pDRyOBzL8
 RXa8ZqRf0Mwg75D+dKntZeJHzPRJyrlfQokngAAs4PaFt6UfS+ypMAF37T6CeDArQC41V3ko
 lPn1yMsVD0p+6i3DPvA/GPIksDC4owjnzVX9kM8Zc5Cx+XoAN0w5Eqo4t6qEVbuettxx55gq
 8K8FieAjgjMSxngo/HST8TpFeqI5nVeq0/lqtBRQKumuIqDg+Bkr4L1V/PSB6XgQcOdhtd36
 Oe9X9dXB8YSNt7VjOcO7BTmFn/Z8r92mSAfHXpb07YJWJosQOQARAQABtDBLaWVyYW4gQmlu
 Z2hhbSA8a2llcmFuLmJpbmdoYW1AaWRlYXNvbmJvYXJkLmNvbT6JAkAEEwEKACoCGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4ACGQEFAlnDk/gFCQeA/YsACgkQoR5GchCkYf3X5w/9EaZ7
 cnUcT6dxjxrcmmMnfFPoQA1iQXr/MXQJBjFWfxRUWYzjvUJb2D/FpA8FY7y+vksoJP7pWDL7
 QTbksdwzagUEk7CU45iLWL/CZ/knYhj1I/+5LSLFmvZ/5Gf5xn2ZCsmg7C0MdW/GbJ8IjWA8
 /LKJSEYH8tefoiG6+9xSNp1p0Gesu3vhje/GdGX4wDsfAxx1rIYDYVoX4bDM+uBUQh7sQox/
 R1bS0AaVJzPNcjeC14MS226mQRUaUPc9250aj44WmDfcg44/kMsoLFEmQo2II9aOlxUDJ+x1
 xohGbh9mgBoVawMO3RMBihcEjo/8ytW6v7xSF+xP4Oc+HOn7qebAkxhSWcRxQVaQYw3S9iZz
 2iA09AXAkbvPKuMSXi4uau5daXStfBnmOfalG0j+9Y6hOFjz5j0XzaoF6Pln0jisDtWltYhP
 X9LjFVhhLkTzPZB/xOeWGmsG4gv2V2ExbU3uAmb7t1VSD9+IO3Km4FtnYOKBWlxwEd8qOFpS
 jEqMXURKOiJvnw3OXe9MqG19XdeENA1KyhK5rqjpwdvPGfSn2V+SlsdJA0DFsobUScD9qXQw
 OvhapHe3XboK2+Rd7L+g/9Ud7ZKLQHAsMBXOVJbufA1AT+IaOt0ugMcFkAR5UbBg5+dZUYJj
 1QbPQcGmM3wfvuaWV5+SlJ+WeKIb8ta5Ag0EVgT9ZgEQAM4o5G/kmruIQJ3K9SYzmPishRHV
 DcUcvoakyXSX2mIoccmo9BHtD9MxIt+QmxOpYFNFM7YofX4lG0ld8H7FqoNVLd/+a0yru5Cx
 adeZBe3qr1eLns10Q90LuMo7/6zJhCW2w+HE7xgmCHejAwuNe3+7yt4QmwlSGUqdxl8cgtS1
 PlEK93xXDsgsJj/bw1EfSVdAUqhx8UQ3aVFxNug5OpoX9FdWJLKROUrfNeBE16RLrNrq2ROc
 iSFETpVjyC/oZtzRFnwD9Or7EFMi76/xrWzk+/b15RJ9WrpXGMrttHUUcYZEOoiC2lEXMSAF
 SSSj4vHbKDJ0vKQdEFtdgB1roqzxdIOg4rlHz5qwOTynueiBpaZI3PHDudZSMR5Fk6QjFooE
 XTw3sSl/km/lvUFiv9CYyHOLdygWohvDuMkV/Jpdkfq8XwFSjOle+vT/4VqERnYFDIGBxaRx
 koBLfNDiiuR3lD8tnJ4A1F88K6ojOUs+jndKsOaQpDZV6iNFv8IaNIklTPvPkZsmNDhJMRHH
 Iu60S7BpzNeQeT4yyY4dX9lC2JL/LOEpw8DGf5BNOP1KgjCvyp1/KcFxDAo89IeqljaRsCdP
 7WCIECWYem6pLwaw6IAL7oX+tEqIMPph/G/jwZcdS6Hkyt/esHPuHNwX4guqTbVEuRqbDzDI
 2DJO5FbxABEBAAGJAiUEGAEKAA8CGwwFAlnDlGsFCQeA/gIACgkQoR5GchCkYf1yYRAAq+Yo
 nbf9DGdK1kTAm2RTFg+w9oOp2Xjqfhds2PAhFFvrHQg1XfQR/UF/SjeUmaOmLSczM0s6XMeO
 VcE77UFtJ/+hLo4PRFKm5X1Pcar6g5m4xGqa+Xfzi9tRkwC29KMCoQOag1BhHChgqYaUH3yo
 UzaPwT/fY75iVI+yD0ih/e6j8qYvP8pvGwMQfrmN9YB0zB39YzCSdaUaNrWGD3iCBxg6lwSO
 LKeRhxxfiXCIYEf3vwOsP3YMx2JkD5doseXmWBGW1U0T/oJF+DVfKB6mv5UfsTzpVhJRgee7
 4jkjqFq4qsUGxcvF2xtRkfHFpZDbRgRlVmiWkqDkT4qMA+4q1y/dWwshSKi/uwVZNycuLsz+
 +OD8xPNCsMTqeUkAKfbD8xW4LCay3r/dD2ckoxRxtMD9eOAyu5wYzo/ydIPTh1QEj9SYyvp8
 O0g6CpxEwyHUQtF5oh15O018z3ZLztFJKR3RD42VKVsrnNDKnoY0f4U0z7eJv2NeF8xHMuiU
 RCIzqxX1GVYaNkKTnb/Qja8hnYnkUzY1Lc+OtwiGmXTwYsPZjjAaDX35J/RSKAoy5wGo/YFA
 JxB1gWThL4kOTbsqqXj9GLcyOImkW0lJGGR3o/fV91Zh63S5TKnf2YGGGzxki+ADdxVQAm+Q
 sbsRB8KNNvVXBOVNwko86rQqF9drZuw=
Organization: Ideas on Board
Message-ID: <d7b02766-b920-8cf7-9db8-275dfc22851c@ideasonboard.com>
Date:   Fri, 15 Feb 2019 20:51:08 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <d6a7d5e54acd4cb6b71eacf0724a92e4AM0PR10MB2788C3DEE0DF6144DAFA6FA1F0600@AM0PR10MB2788.EURPRD10.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Moritz,

On 15/02/2019 08:45, Moritz Dötterl wrote:
> Hello
> 
> Recently we updated the Kernel on our Ubuntu machines from 4.15 to 4.18
> because the OS was randomly freezing. However with the new Kernel we ran
> into a problem regarding our two webcams. We had two /dev/video device
> files per camera of which only one seemed to work.

Yes, a new device node has been added to represent the meta-data from
the device.

You should be able to enumerate the devices, and you should
verify/validate the capabilities of the device after you open it.

A UVC capture device will expose the V4L2_CAP_VIDEO_OUTPUT capability flag.

> The problem was that
> our application would just randomly open one of those two device files

Is this an application you have control over the source code for?
or some external application?

> and then crashed if it opened the wrong one. After some search i figured
> out that the second device file is for meta data (which might not be
> provided by our camera i guess...). However i also found the line in the
> uvc_driver.c which generates the device file
> (https://elixir.bootlin.com/linux/v4.18/source/drivers/media/usb/uvc/uvc_driver.c#L2005)
> that line including the whole uvc_metadata.c was added when comparing
> 4.15 and 4.18 Kernel. I took that line out, recompiled the Kernel and
> ended up with having only one /dev/video device file per camera. I also
> found it is using the exact same function to register the device node
> that the uvc_driver.c is using and also using the same vfl_devnode_type
>  (VFL_TYPE_GRABBER) and therefore ending up as a /dev/video device. Was
> that move on purpose?

Yes, this addition was on purpose. It was added by the following patch:

https://www.spinics.net/lists/linux-media/msg125681.html

I've added the linux-media mailing list on Cc where you will be able to
find better support if this topic causes further problems.


> Why was it split up in two device files, or is
> that just added functionality?

I believe it is just added functionality - not split.

> I would rather like this device file to
> have a different name because in this setup it is not easily decidable

Perhaps some different naming might have continued to hide this issue
for you but it would only have hidden a potential bug.

Even with a different name, you can not expect that all /dev/video*
nodes are capture devices. They can be output devices or M2M devices for
example. Your application should always check the device capabilities
using the V4L2 API's as applicable.


> if a /dev/video device is the "real" webcam or just the meta data... So
> i would prefer that to end up as something like /dev/metavideo or so (
> or maybe easier: change the type to VFL_TYPE_SUBDEV so it will end up as
> a v4l-subdev device, that sounds more suitable for me...)

I think in this instance it has to be a full video node and not a subdev
so that data can be captured from the device node.


> What are the plans for this in future kernel versions? Should it stay
> like it is now or are there plans to change/evolve the meta data
> handling again?

This is in mainline now - so I would expect it to continue to be supported.

> 
> 
> Thanks very much.
> 
> 
> Best regards / Mit freundlichen Grüßen
> *Moritz Dötterl*
> 
> Pentland Firth Software GmbH
> 
> Hofmannstr. 61
> 81379 München, Germany
> 
> Mobile: +49 17655389056
> 
> moritz.doetterl@pentlandfirth.com <mailto:aron.borbath@pentlandfirth.com>
> 
> ----------------------------------------------------------------------------------------------------------------------------------
> Pentland Firth is *Microsoft Gold Partner*
> 
> Brands we own:  www.whiz-cart.com <http://www.whiz-cart.com/>
> ----------------------------------------------------------------------------------------------------------------------------------
> Sitz der Gesellschaft: München, Handelsregister München, HRB 155 786,
> Geschäftsführer: Frank Heinrich
> 
> 
> 
> 
> _______________________________________________
> Linux-uvc-devel mailing list
> Linux-uvc-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-uvc-devel
> 

-- 
Regards
--
Kieran
