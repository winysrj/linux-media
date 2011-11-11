Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:59591 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752116Ab1KKQbL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Nov 2011 11:31:11 -0500
Message-ID: <4EBD4DD1.7030809@gmx.de>
Date: Fri, 11 Nov 2011 16:31:13 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-fbdev@vger.kernel.org, linux-media@vger.kernel.org,
	magnus.damm@gmail.com, Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH v3 0/3] fbdev: Add FOURCC-based format configuration API
References: <1314789501-824-1-git-send-email-laurent.pinchart@ideasonboard.com> <4E764B35.2090009@gmx.de> <201109182249.39536.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201109182249.39536.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/18/2011 08:49 PM, Laurent Pinchart wrote:
>> As the second patch has nothing to do with fbdev it should go mainline via
>> V4L2. Any problems/comments?
> 
> The NV24/42 patch will need to reach mainline before the sh_mobile_lcdc YUV 
> API patch, or compilation will break.
> 
> Mauro, what's your preference ? Should the patch go through the media tree ? 
> If so, how should we synchronize it with the fbdev tree ? Should I push it to 
> 3.2 ?

ping

What's going on? I could carry the patch but I'd want an Ack to do so.


Best regards,

Florian Tobias Schandinat
