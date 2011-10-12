Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nexicom.net ([216.168.96.13]:41222 "EHLO smtp.nexicom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750747Ab1JMAmR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Oct 2011 20:42:17 -0400
Received: from mail.lockie.ca (dyn-dsl-mb-216-168-118-207.nexicom.net [216.168.118.207])
	by smtp.nexicom.net (8.13.6/8.13.4) with ESMTP id p9D0gFu5030140
	for <linux-media@vger.kernel.org>; Wed, 12 Oct 2011 20:42:16 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by mail.lockie.ca (Postfix) with ESMTP id 15D761E000D
	for <linux-media@vger.kernel.org>; Wed, 12 Oct 2011 20:41:55 -0400 (EDT)
Message-ID: <4E95FBC9.3060309@lockie.ca>
Date: Wed, 12 Oct 2011 16:42:49 -0400
From: James <bjlockie@lockie.ca>
MIME-Version: 1.0
To: linux-media Mailing List <linux-media@vger.kernel.org>
Subject: Re: where is the cx23887 module in kernel-3.04 config?
References: <4E95F8D3.4070104@lockie.ca>
In-Reply-To: <4E95F8D3.4070104@lockie.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/12/11 16:30, James wrote:
> Where is the cx23887 module in the kernel-3.04 config?
> I'm trying to get a Hauppauge WinTV-HVR-1250 working.
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
Found it under video4lnux driver and not DVB/ATSC adapters (which seems 
more logical).
