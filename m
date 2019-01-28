Return-Path: <SRS0=ymVG=QE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB213C282C8
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 13:12:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AF0E220880
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 13:12:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726693AbfA1NMH (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 28 Jan 2019 08:12:07 -0500
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:41481 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726672AbfA1NMH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Jan 2019 08:12:07 -0500
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud9.xs4all.net with ESMTPA
        id o6hegsMrzRO5Zo6higK9LD; Mon, 28 Jan 2019 14:12:04 +0100
Subject: Re: devicetree: media: Documentation of Bt.656 Bus DT bindings
To:     Ken Sloat <ken.sloat@ohmlinxelectronics.com>
Cc:     linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, yong.deng@magewell.com,
        mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        maxime.ripard@bootlin.com, wens@csie.org,
        kieran.bingham@ideasonboard.com, laurent.pinchart@ideasonboard.com,
        jean-michel.hautbois@vodalys.com,
        Nate Drude <nate.drude@ohmlinxelectronics.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
References: <CAPo_4QDW0r22ZTqtS_NDFWB3NFLBx9YEGgWKb-P9A3t_TBAFMQ@mail.gmail.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <c4d68627-b26a-6402-daf4-5cd103ec9fd0@xs4all.nl>
Date:   Mon, 28 Jan 2019 14:11:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <CAPo_4QDW0r22ZTqtS_NDFWB3NFLBx9YEGgWKb-P9A3t_TBAFMQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfNqOlEe9iW/LBZ3As+QKI1eqmbAhYgnj7aQy9UJibCeZDomK4hs3lamUow/ou4C+LJp80z+2fYCBabQbVAUAv0BlV1zNDbVZPHP0a7EDfxT7H+oVu7zb
 JbPry7gs/NSrDgUBsk5oGKz+/nMYbsfeN1t0LiwAJMfENvQL8hZLgdFKymxEx6nsK5VBwKQLjH3WMGTE0cWCdGx4qu8SCxVilmklgem7SwyOd4Fo8B21ISfd
 ANDhcFov1gDvDaH+6l/Hvkw/MRDda7rziExEkU5oD3j+Zbncc2x1HK1LhWr5i6QNtrTDIQ4xGn2kSEJzGLVtX0PUQwJUGT3jR9qlxV8gVjyEcXyNsBRqeE87
 F50OIAax3dlKqmXlPyuPjwpUWUS5xjuUiWVyFNX7U7bPqhteLBZRRKEFSs+A8NNSgO/NO3q9UgY6LrbcaMpRRyN464w4hIdFE0lTgIJVbSCzjyRIUkAcXcej
 Z/IYy0pFUXcQQRi0APHBfjRet/JClO7zcJapxvzwsUctvKJxZiU91+1OGLGUISHkVM+25zvXtXxlbjjS3Rot1UcCvOud+CFTTPLVk+jAjCG/vGAIgps/p6vD
 MKS84UG1kdm8iGPsBv/HyjsyQ11bk+E4EtL7SP+MIqCaeGvYzD2NFQbk1a09dMijz5w7OslhcWTJ/54mLkv0oGPaf/7PsPxyz/PGDLcOH8B/0zYso6jeHmTt
 /jrryYuQLeFuHiozNq8yzRLBuUViCo4r
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

+Sakari

On 1/24/19 3:53 AM, Ken Sloat wrote:
> There are a number of v4l2 subdevices in the kernel that support a
> Bt.656 bus also known as "embedded sync." Previously in older versions
> of the kernel (and in the current 4.14 LTS kernel), the standard way
> to enable this in device tree on a parallel bus was to simply omit all
> hysync and vsync flags.
> 
> During some other kernel development I was doing, it was brought to my
> attention that there is now a standard defined binding in
> "video-interfaces.txt" called "bus-type" that should be used in order
> to enable Bt.656 mode. While omitting the flags still appears to work
> because of other assumptions made in v4l2-fwnode driver, this method
> is now outdated and improper.
> 
> However, I have noticed that several dt binding docs have not been
> updated to reflect this change and still reference the old method:
> 
> Documentation/devicetree/bindings/media/sun6i-csi.txt
> /* If hsync-active/vsync-active are missing,
>    embedded BT.656 sync is used */
> 
> Documentation/devicetree/bindings/media/i2c/tvp5150.txt
> "If none of hsync-active, vsync-active and field-even-active is specified,
> the endpoint is assumed to use embedded BT.656 synchronization."
> 
> Documentation/devicetree/bindings/media/i2c/adv7604.txt
> "If none of hsync-active, vsync-active and pclk-sample is specified the
>   endpoint will use embedded BT.656 synchronization."
> 
> and amazingly even
> Documentation/devicetree/bindings/media/video-interfaces.txt in one of
> the code snippets
> /* If hsync-active/vsync-active are missing,
>    embedded BT.656 sync is used */
> 
> In order to avoid future confusion in the matter and ensure that the
> proper bindings are used, I am proposing submitting patches to update
> these docs to at minimum remove these statements and maybe even adding
> additional comments specifying the optional property and value for
> Bt.656 where missing. I wanted to open a discussion here first before
> doing this though. Thoughts?
> 
> Thanks,
> Ken Sloat
> 

I certainly agree that this should be updated to make it all consistent.

Regards,

	Hans
