Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:38477 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbbEXMfi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 May 2015 08:35:38 -0400
Received: by wichy4 with SMTP id hy4so26730163wic.1
        for <linux-media@vger.kernel.org>; Sun, 24 May 2015 05:35:37 -0700 (PDT)
Message-ID: <5561C595.2060603@gmail.com>
Date: Sun, 24 May 2015 13:35:33 +0100
From: Jemma Denson <jdenson@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: mchehab@osg.samsung.com, patrick.boettcher@posteo.de
Subject: Re: [PATCH 4/4] b2c2: Always turn off receive stream
References: <1432326508-6825-1-git-send-email-jdenson@gmail.com> <1432326508-6825-5-git-send-email-jdenson@gmail.com>
In-Reply-To: <1432326508-6825-5-git-send-email-jdenson@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 22/05/15 21:28, Jemma Denson wrote:
> When letting an external device control the receive stream, it won't
> know when there's demand for any feeds, so won't be turning off our
> receive stream. This patch bring back control of turning it off in
> this sitation.
>
> The demod can still delay turning it on until it has data to send,
> and still turn it off temporarily whilst it knows there's no
> stream, such as whilst tuning.
>
> Signed-off-by: Jemma Denson <jdenson@gmail.com>
> ---
>   drivers/media/common/b2c2/flexcop-hw-filter.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/common/b2c2/flexcop-hw-filter.c b/drivers/media/common/b2c2/flexcop-hw-filter.c
> index eceb9c5..8926c82 100644
> --- a/drivers/media/common/b2c2/flexcop-hw-filter.c
> +++ b/drivers/media/common/b2c2/flexcop-hw-filter.c
> @@ -206,7 +206,7 @@ int flexcop_pid_feed_control(struct flexcop_device *fc,
>   
>   	/* if it was the first or last feed request change the stream-status */
>   	if (fc->feedcount == onoff) {
> -		if (!fc->external_stream_control)
> +		if (!fc->external_stream_control || onoff == 0)
>   			flexcop_rcv_data_ctrl(fc, onoff);
>   
>   		if (fc->stream_control) /* device specific stream control */

Hmm, OK. I've done some further testing and this last patch needs either 
ignoring or a rethink. It interferes with flexcop_pci_irq_check_work() 
in pci/b2c2/flexcop-pci.c. That function will try and reset all the hw 
filters with calls to flexcop_pid_feed_control() by turning them all off 
and then back on again.
Including this patch causes the receive stream to be turned off and it 
then doesn't get enabled again.


Jemma.
