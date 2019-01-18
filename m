Return-Path: <SRS0=Cp5C=P2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37B17C43387
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 09:52:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 073EF2086D
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 09:52:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726448AbfARJwz (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 18 Jan 2019 04:52:55 -0500
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:51271 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725856AbfARJwz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Jan 2019 04:52:55 -0500
Received: from [IPv6:2001:983:e9a7:1:3849:86c5:b8c2:266c] ([IPv6:2001:983:e9a7:1:3849:86c5:b8c2:266c])
        by smtp-cloud9.xs4all.net with ESMTPA
        id kQpYgcNXBaxzfkQpZgovR3; Fri, 18 Jan 2019 10:52:53 +0100
Subject: Re: [RFT] media: hdpvr: Fix Double kfree() error
To:     Arvind Yadav <arvind.yadav.cs@gmail.com>
Cc:     linux-media@vger.kernel.org
References: <ed0e67f9c56e42827f34d6e2991e6572070f8996.1521544143.git.arvind.yadav.cs@gmail.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <597bc939-8d27-f9dd-1102-7d874e1a9938@xs4all.nl>
Date:   Fri, 18 Jan 2019 10:52:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <ed0e67f9c56e42827f34d6e2991e6572070f8996.1521544143.git.arvind.yadav.cs@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfFWfvAJt20F05Omn8J5gHsVDIIKaTcNzTJEg7UguT4eCo1vZ/YgE5LwoB+w8sNT6+DpBBIJcUWIcJkLclxZUj5y7Vh28CLmMCBc/V7w6/aQdlKCAhVCK
 nqMyE5qyh+9Jai/p22N5HhkN7UpIbXPG/ewN12UYZRJ7IRgaYW1mdyFfl78T1jU+j/+j5L8KPt1Cv3lBZWmH42gyM86MJe7l9nlHmLUT847+1FvqUGQGYvg1
 1olLTrBZsGQ6XZImPZJuGcBr85fjNkptJKc88FvW+s5wtwsYW/p4qKSkLDzRw01UFuX+i/eHmXml1Mnjb73Buw==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Arvind,

Yes, I know, this is an extremely reply. I'm cleaning up some old patches
that fell through the cracks, and this is one of them. My apologies.

On 3/20/18 12:16 PM, Arvind Yadav wrote:
> Here, double-free is happening on error path of hdpvr_probe.
> 
> error_v4l2_unregister:
>   v4l2_device_unregister(&dev->v4l2_dev);
>    =>
>     v4l2_device_disconnect
>     =>
>      put_device
>      =>
>       kobject_put
>       =>
>        kref_put
>        =>
>         v4l2_device_release
>         =>
>          hdpvr_device_release (CALLBACK)

This isn't right: the release callback of struct v4l2_device isn't used
by this driver. The hdpvr_device_release function you refer to is that
of struct video_device.

>          =>
>          kfree(dev)
> 
> error_free_dev:
>            kfree(dev)
> 
> Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
> ---
> reported by:
>            Dan Carpenter<dan.carpenter@oracle.com>

Do you have a pointer to the original report by Dan Carpenter?

Regards,

	Hans

> 
>  drivers/media/usb/hdpvr/hdpvr-core.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/media/usb/hdpvr/hdpvr-core.c b/drivers/media/usb/hdpvr/hdpvr-core.c
> index 29ac7fc..cab100a0 100644
> --- a/drivers/media/usb/hdpvr/hdpvr-core.c
> +++ b/drivers/media/usb/hdpvr/hdpvr-core.c
> @@ -395,6 +395,7 @@ static int hdpvr_probe(struct usb_interface *interface,
>  	kfree(dev->usbc_buf);
>  error_v4l2_unregister:
>  	v4l2_device_unregister(&dev->v4l2_dev);
> +	dev = NULL;
>  error_free_dev:
>  	kfree(dev);
>  error:
> 

