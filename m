Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.ukfsn.org ([77.75.108.3]:56117 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760812Ab2CPPFs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Mar 2012 11:05:48 -0400
Message-ID: <4F6356C5.9010808@ukfsn.org>
Date: Fri, 16 Mar 2012 15:05:41 +0000
From: Andy Furniss <andyqos@ukfsn.org>
MIME-Version: 1.0
To: gennarone@gmail.com
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH] em28xx: pre-allocate DVB isoc transfer buffers
References: <1329155962-22896-1-git-send-email-gennarone@gmail.com> <4F628886.3050009@ukfsn.org> <4F6299A4.1060309@gmail.com> <4F6312F0.1010305@ukfsn.org>
In-Reply-To: <4F6312F0.1010305@ukfsn.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Andy Furniss wrote:
> Gianluca Gennari wrote:

>> Hi Andy,
>> the patch is already in the current media_build tree and is queued for
>> kernel 3.4.
>
> Ahh, I'll give that a try, thanks.

Seems to be working OK so far, I had to avoid building radio to get it 
to compile.

Are these just informational - I get five every time I tune (barring the 
first time IIRC)

Mar 16 14:56:58 noki kernel: ehci_hcd 0000:01:0a.2: shutdown urb 
ced2d000 ep4in-iso
Mar 16 14:56:58 noki kernel: ehci_hcd 0000:01:0a.2: shutdown urb 
ced2d800 ep4in-iso
Mar 16 14:56:58 noki kernel: ehci_hcd 0000:01:0a.2: shutdown urb 
cec3f800 ep4in-iso
Mar 16 14:56:58 noki kernel: ehci_hcd 0000:01:0a.2: shutdown urb 
ced2c000 ep4in-iso
Mar 16 14:56:58 noki kernel: ehci_hcd 0000:01:0a.2: shutdown urb 
ced2c800 ep4in-iso

