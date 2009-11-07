Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:20775 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073AbZKGSfI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Nov 2009 13:35:08 -0500
Received: by fg-out-1718.google.com with SMTP id d23so217774fga.1
        for <linux-media@vger.kernel.org>; Sat, 07 Nov 2009 10:35:13 -0800 (PST)
Message-ID: <4AF5BDDC.4010608@googlemail.com>
Date: Sat, 07 Nov 2009 19:35:08 +0100
From: e9hack <e9hack@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org
Subject: Re: bug in changeset 13239:54535665f94b ?
References: <4AEDB05E.1090704@googlemail.com> <20091107104113.0df4593b@pedra.chehab.org> <4AF57E8E.5070109@googlemail.com>
In-Reply-To: <4AF57E8E.5070109@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

e9hack schrieb:
>> I agree. We need first to stop DMA activity, and then release the page tables.
>>
>> Could you please test if the enclosed patch fixes the issue?
> 
> your patch doesn't solve the problem, because saa7146_dma_free() doesn't stop a running
> dma transfer of the saa7146. 

Sorry, that was wrong. I did only look, if my additional messages were print or not, but I
didn't wait for the memory corruption, because it may corrupt the file system. With your
patch, I get the messages, but the protection address is set to 0, which disables the dma
transfer even if the dma transfer is enabled within the MC1 register.

Regards,
Hartmut
