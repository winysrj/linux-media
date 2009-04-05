Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail4.sea5.speakeasy.net ([69.17.117.6]:44833 "EHLO
	mail4.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442AbZDELuf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Apr 2009 07:50:35 -0400
Date: Sun, 5 Apr 2009 04:50:32 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Uri Shkolnik <urishk@yahoo.com>
cc: LinuxML <linux-media@vger.kernel.org>
Subject: Re: [PATCH] [0904_16] Siano: smsdvb - additional case of endian
 handling.
In-Reply-To: <220734.24824.qm@web110816.mail.gq1.yahoo.com>
Message-ID: <Pine.LNX.4.58.0904050449380.5134@shell2.speakeasy.net>
References: <220734.24824.qm@web110816.mail.gq1.yahoo.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 5 Apr 2009, Uri Shkolnik wrote:
>  	PidMsg.xMsgHeader.msgLength = sizeof(PidMsg);
>  	PidMsg.msgData[0] = feed->pid;
>
> -	/* smsendian_handle_tx_message((struct SmsMsgHdr_ST *)&PidMsg); */
> +	smsendian_handle_tx_message((struct SmsMsgHdr_ST *)&PidMsg);
>  	return smsclient_sendrequest(client->smsclient, &PidMsg,
>  			sizeof(PidMsg));

I don't get it, you wrote the code commented out in one patch, and now
you're going to sumbit patches to uncomment it one line at a time?
