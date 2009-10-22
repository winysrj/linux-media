Return-path: <linux-media-owner@vger.kernel.org>
Received: from lider.uludag.org.tr ([193.140.100.216]:43087 "EHLO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756054AbZJVP4b (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Oct 2009 11:56:31 -0400
Message-ID: <4AE080AC.4050108@pardus.org.tr>
Date: Thu, 22 Oct 2009 18:56:28 +0300
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>,
	USB list <linux-usb@vger.kernel.org>
Subject: Re: uvcvideo causes ehci_hcd to halt
References: <Pine.LNX.4.44L0.0910220944100.989-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0910220944100.989-100000@netrider.rowland.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Alan Stern wrote:
> On Thu, 22 Oct 2009, [UTF-8] Ozan Ã‡aÄŸlayan wrote:
>
>   
>> Here's the outputs from /sys/kernel/debug/usb/ehci:
>>
>> periodic:
>> ----------------
>> size = 1024
>>    1:  qh1024-0001/f6ffe280 (h2 ep2 [1/0] q0 p8)
>>     
>
> There's something odd about this.  I'd like to see this file again, 
> after the patch below has been applied.
>
>   

Do you want me to apply this patch altogether with the first one that
you sent a while ago in this thread or directly onto the vanilla kernel?
