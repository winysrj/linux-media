Return-Path: <SRS0=8CHB=RF=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 630CEC43381
	for <linux-media@archiver.kernel.org>; Sat,  2 Mar 2019 22:29:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3636420836
	for <linux-media@archiver.kernel.org>; Sat,  2 Mar 2019 22:29:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726827AbfCBW32 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 2 Mar 2019 17:29:28 -0500
Received: from rio.cs.utah.edu ([155.98.64.241]:45923 "EHLO
        mail-svr1.cs.utah.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726577AbfCBW32 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 2 Mar 2019 17:29:28 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail-svr1.cs.utah.edu (Postfix) with ESMTP id 07CE36500B9;
        Sat,  2 Mar 2019 15:29:27 -0700 (MST)
Received: from mail-svr1.cs.utah.edu ([127.0.0.1])
        by localhost (mail-svr1.cs.utah.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id lVp4Ozt-uIYa; Sat,  2 Mar 2019 15:29:26 -0700 (MST)
Received: from [192.168.3.5] (dhcp-155-97-238-209.usahousing.utah.edu [155.97.238.209])
        by smtps.cs.utah.edu (Postfix) with ESMTPSA id 83BE56500B5;
        Sat,  2 Mar 2019 15:29:26 -0700 (MST)
Subject: Re: Question about drivers/media/usb/uvc/uvc_v4l2.c
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     linux-media@vger.kernel.org
References: <8479deae-dedb-b7d2-58b7-8ff91f265eab@cs.utah.edu>
 <20190302214308.GI4682@pendragon.ideasonboard.com>
From:   Shaobo He <shaobo@cs.utah.edu>
Message-ID: <3bfdd00d-abff-8683-6e25-1010cc568702@cs.utah.edu>
Date:   Sat, 2 Mar 2019 15:29:25 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <20190302214308.GI4682@pendragon.ideasonboard.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Laurent,

Thank you very much for your reply. This is what I thought, too. It seems that 
there's an implicit order of execution that is not clearly implied in the code, 
meaning `uvc_parse_streaming` is called before `uvc_v4l2_try_format`.

That being said, I was wondering maybe a better practice to write the loop in 
`uvc_v4l2_try_format` would be like the following,

```
format=NULL;
...
for (i = 0; i < stream->nformats; ++i) {
		format = &stream->format[i];
		if (format->fcc == fmt->fmt.pix.pixelformat)
			break;
}
// dereferencing format
```
to
```
// just declaration
format;
i=0;
do {
		format = &stream->format[i];
		if (format->fcc == fmt->fmt.pix.pixelformat)
			break;
		++i;
} while (i<stream->nformats)
// dereferencing format
```
I mean you can save one initialization, provided compiler does it and one branch.

Shaobo
On 2019/3/2 14:43, Laurent Pinchart wrote:
> Hi Shaobo,
> 
> On Sat, Mar 02, 2019 at 01:22:49PM -0700, Shaobo He wrote:
>> Hello everyone,
>>
>> This is Shaobo from Utah again. I've been bugging the mailing list with my
>> patches. I have a quick question about a function in
>> `drivers/media/usb/uvc/uvc_v4l2.c`. In `uvc_v4l2_try_format`, can
>> `stream->nformats` be 0? I saw that in other files, this field could be zero
>> which is considered as error cases. I was wondering if it's true for this
>> function, too.
> 
> The uvc_parse_streaming() function should answer this question :-)
> 
