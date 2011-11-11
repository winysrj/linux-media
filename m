Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13891 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753248Ab1KKSlp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Nov 2011 13:41:45 -0500
Message-ID: <4EBD6C5F.3050703@redhat.com>
Date: Fri, 11 Nov 2011 16:41:35 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-fbdev@vger.kernel.org, linux-media@vger.kernel.org,
	magnus.damm@gmail.com
Subject: Re: [PATCH v3 0/3] fbdev: Add FOURCC-based format configuration API
References: <1314789501-824-1-git-send-email-laurent.pinchart@ideasonboard.com> <4E764B35.2090009@gmx.de> <201109182249.39536.laurent.pinchart@ideasonboard.com> <4EBD4DD1.7030809@gmx.de>
In-Reply-To: <4EBD4DD1.7030809@gmx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 11-11-2011 14:31, Florian Tobias Schandinat escreveu:
> On 09/18/2011 08:49 PM, Laurent Pinchart wrote:
>>> As the second patch has nothing to do with fbdev it should go mainline via
>>> V4L2. Any problems/comments?
>>
>> The NV24/42 patch will need to reach mainline before the sh_mobile_lcdc YUV 
>> API patch, or compilation will break.
>>
>> Mauro, what's your preference ? Should the patch go through the media tree ? 
>> If so, how should we synchronize it with the fbdev tree ? Should I push it to 
>> 3.2 ?
> 
> ping
> 
> What's going on? I could carry the patch but I'd want an Ack to do so.

I think I had answered it before, on some previous version. I'm OK if you merge
it via your tree.

Just replied to the patch with my ACK.

> 
> 
> Best regards,
> 
> Florian Tobias Schandinat

