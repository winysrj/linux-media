Return-path: <linux-media-owner@vger.kernel.org>
Received: from canardo.mork.no ([148.122.252.1]:57278 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758063Ab3CUNSP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Mar 2013 09:18:15 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 4/6] siano: remove the remaining CamelCase compliants
References: <1363870963-28552-1-git-send-email-mchehab@redhat.com>
	<1363870963-28552-4-git-send-email-mchehab@redhat.com>
Date: Thu, 21 Mar 2013 14:18:11 +0100
In-Reply-To: <1363870963-28552-4-git-send-email-mchehab@redhat.com> (Mauro
	Carvalho Chehab's message of "Thu, 21 Mar 2013 10:02:41 -0300")
Message-ID: <87d2usj3ho.fsf@nemi.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab <mchehab@redhat.com> writes:

> Remove the remaining CamelCase checkpatch.pl compliants.
> There are still a few left, but those are due to USB and
> DVB APIs.
[..]
> @@ -840,31 +840,31 @@ int smscore_configure_board(struct smscore_device_t *coredev)
>  	}
>  
>  	if (board->mtu) {
> -		struct sms_msg_data MtuMsg;
> +		struct sms_msg_data mtu_msg;
>  		sms_debug("set max transmit unit %d", board->mtu);
>  
> -		MtuMsg.x_msg_header.msg_src_id = 0;
> -		MtuMsg.x_msg_header.msg_dst_id = HIF_TASK;
> -		MtuMsg.x_msg_header.msg_flags = 0;
> -		MtuMsg.x_msg_header.msg_type = MSG_SMS_SET_MAX_TX_MSG_LEN_REQ;
> -		MtuMsg.x_msg_header.msg_length = sizeof(MtuMsg);
> -		MtuMsg.msgData[0] = board->mtu;
> +		mtu_msg.x_msg_header.msg_src_id = 0;
> +		mtu_msg.x_msg_header.msg_dst_id = HIF_TASK;
> +		mtu_msg.x_msg_header.msg_flags = 0;
> +		mtu_msg.x_msg_header.msg_type = MSG_SMS_SET_MAX_TX_MSG_LEN_REQ;
> +		mtu_msg.x_msg_header.msg_length = sizeof(mtu_msg);
> +		mtu_msg.msg_data[0] = board->mtu;
>  

Ah, right.  Why don't you just squash patch 1 and 4 together, reducing
the set with about the size of patch 4, and making all this somewhat
more meaningful?

Tounching the exact same lines twice in the same patchset, doing the
exact same type of cleanup, does *not* help review.


Bjørn
