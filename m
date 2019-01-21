Return-Path: <SRS0=kVnX=P5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B561C282F6
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 09:34:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CDBC921738
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 09:34:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726231AbfAUJer (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 21 Jan 2019 04:34:47 -0500
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:35301 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726133AbfAUJer (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Jan 2019 04:34:47 -0500
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id lVybgW4UbBDyIlVyfgNrks; Mon, 21 Jan 2019 10:34:45 +0100
Subject: Re: [v4l-utils PATCH 3/6] v4l2-ctl: test the excpetion fds first in
 streaming_set_m2m
To:     Dafna Hirschfeld <dafna3@gmail.com>, linux-media@vger.kernel.org
Cc:     helen.koike@collabora.com
References: <20190120111520.114305-1-dafna3@gmail.com>
 <20190120111520.114305-4-dafna3@gmail.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <bacda443-6cd9-5729-6b85-9302b61437b3@xs4all.nl>
Date:   Mon, 21 Jan 2019 10:34:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <20190120111520.114305-4-dafna3@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfMnKHNeOHGWcNVf6/A11tc/0u4xcToykzYUIXbVuN3XMTP23VoAYJjeEVZuENUMtDengio4D897sg/fG1c7dg3bNAS43GHj6G8Hoa2WxiiqPhx0ybQUy
 OMmv1vQPoHcn9UAm+NnmaE9hF1NXtcPgXI/lXSNRPGS2L6nBQGDLqK+r6ffTRAJ/0Xl3SMjZH/mysjDtawJIE9wX6gAXOC+cjVwHi4vbXPJofC4g5nB0HyqK
 8xrT7oxwTDVcdjBcLo837Q==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 01/20/2019 12:15 PM, Dafna Hirschfeld wrote:
> test the excpetion fds first in the select loop

excpetion -> exception

> in streaming_set_m2m. This is needed in the next patch
> in order to dequeue a source change event before its
> coresponding last buffer.

coresponding -> corresponding

But besides those typos, I don't think this patch is needed at
all. See my comments for patch 5/6 for more info.

Regards,

	Hans

> 
> Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
> ---
>  utils/v4l2-ctl/v4l2-ctl-streaming.cpp | 26 +++++++++++++-------------
>  1 file changed, 13 insertions(+), 13 deletions(-)
> 
> diff --git a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
> index 3e81fdfc..fc204304 100644
> --- a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
> +++ b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
> @@ -1953,6 +1953,19 @@ static void streaming_set_m2m(cv4l_fd &fd)
>  			goto done;
>  		}
>  
> +		if (ex_fds && FD_ISSET(fd.g_fd(), ex_fds)) {
> +			struct v4l2_event ev;
> +
> +			while (!fd.dqevent(ev)) {
> +				if (ev.type != V4L2_EVENT_EOS)
> +					continue;
> +				wr_fds = NULL;
> +				fprintf(stderr, "EOS");
> +				fflush(stderr);
> +				break;
> +			}
> +		}
> +
>  		if (rd_fds && FD_ISSET(fd.g_fd(), rd_fds)) {
>  			r = do_handle_cap(fd, in, file[CAP], NULL,
>  					  count[CAP], fps_ts[CAP]);
> @@ -1990,19 +2003,6 @@ static void streaming_set_m2m(cv4l_fd &fd)
>  				}
>  			}
>  		}
> -
> -		if (ex_fds && FD_ISSET(fd.g_fd(), ex_fds)) {
> -			struct v4l2_event ev;
> -
> -			while (!fd.dqevent(ev)) {
> -				if (ev.type != V4L2_EVENT_EOS)
> -					continue;
> -				wr_fds = NULL;
> -				fprintf(stderr, "EOS");
> -				fflush(stderr);
> -				break;
> -			}
> -		}
>  	}
>  
>  	fcntl(fd.g_fd(), F_SETFL, fd_flags);
> 

