Return-path: <linux-media-owner@vger.kernel.org>
Received: from canardo.mork.no ([148.122.252.1]:57212 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757979Ab3CUNKk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Mar 2013 09:10:40 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/6] siano: get rid of CammelCase from smscoreapi.h
References: <1363870963-28552-1-git-send-email-mchehab@redhat.com>
Date: Thu, 21 Mar 2013 14:10:33 +0100
In-Reply-To: <1363870963-28552-1-git-send-email-mchehab@redhat.com> (Mauro
	Carvalho Chehab's message of "Thu, 21 Mar 2013 10:02:38 -0300")
Message-ID: <87hak4j3ue.fsf@nemi.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab <mchehab@redhat.com> writes:

> It is almost impossible to see a compliant with checkpatch.pl
> on those Siano drivers, as there are simply too much violations
> on it. So, now that a big change was done, the better is to
> cleanup the checkpatch compliants.
>
> Let's first replace all CammelCase symbols found at smscoreapi.h
> using camel_case namespace. That removed 144 checkpatch.pl
> compliants on this file. Of course, the other files need to be
> fixed accordingly.
[..]
> @@ -840,14 +840,14 @@ int smscore_configure_board(struct smscore_device_t *coredev)
>  	}
>  
>  	if (board->mtu) {
> -		struct SmsMsgData_ST MtuMsg;
> +		struct sms_msg_data MtuMsg;
>  		sms_debug("set max transmit unit %d", board->mtu);
>  
> -		MtuMsg.xMsgHeader.msgSrcId = 0;
> -		MtuMsg.xMsgHeader.msgDstId = HIF_TASK;
> -		MtuMsg.xMsgHeader.msgFlags = 0;
> -		MtuMsg.xMsgHeader.msgType = MSG_SMS_SET_MAX_TX_MSG_LEN_REQ;
> -		MtuMsg.xMsgHeader.msgLength = sizeof(MtuMsg);
> +		MtuMsg.x_msg_header.msg_src_id = 0;
> +		MtuMsg.x_msg_header.msg_dst_id = HIF_TASK;
> +		MtuMsg.x_msg_header.msg_flags = 0;
> +		MtuMsg.x_msg_header.msg_type = MSG_SMS_SET_MAX_TX_MSG_LEN_REQ;
> +		MtuMsg.x_msg_header.msg_length = sizeof(MtuMsg);
>  		MtuMsg.msgData[0] = board->mtu;
>  
>  		coredev->sendrequest_handler(coredev->context, &MtuMsg,



etc.  This didn't help one bit, did it?  There are exacly the same
number of CamelCased lines here as before your patch.  Why is that?


Bjørn
