Return-path: <linux-media-owner@vger.kernel.org>
Received: from imsantv76.netvigator.com ([210.87.250.209]:44754 "EHLO
	imsantv76.netvigator.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180AbZFXDFn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Jun 2009 23:05:43 -0400
Received: from imsantv76 (imsantv76 [127.0.0.1])
	by imsantv76.netvigator.com (8.14.2/8.14.2) with ESMTP id n5O2U4OW000823
	for <linux-media@vger.kernel.org>; Wed, 24 Jun 2009 10:30:05 +0800
Message-ID: <4A418FA1.5010305@siriushk.com>
Date: Wed, 24 Jun 2009 10:29:53 +0800
From: Timothy Lee <timothy.lee@siriushk.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: David Wong <davidtlwong@gmail.com>,
	Michael Krufky <mkrufky@linuxtv.org>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] [Resend] cxusb, d680 dmbth use unified lgs8gxx code instead
  of lgs8gl5
References: <15ed362e0906101016g13b81df6h1282e3bd410928b2@mail.gmail.com> <20090616160502.43cdb689@pedra.chehab.org>
In-Reply-To: <20090616160502.43cdb689@pedra.chehab.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/17/2009 03:05 AM, Mauro Carvalho Chehab wrote:
> Hi David,
>
> Em Thu, 11 Jun 2009 01:16:13 +0800
> David Wong<davidtlwong@gmail.com>  escreveu:
>    
>> Use unified lgs8gxx frontend instead of reverse engineered lgs8gl5 frontend.
>> After this patch, lgs8gl5 frontend could be mark as deprecated.
>> Future development should base on unified lgs8gxx frontend.
>>
>> Signed-off-by: David T.L. Wong<davidtlwong<at>  gmail.com>
>>      
> Your patch makes sense. Have you tested it with the Magic-Pro DMB-TH usb stick?
>
> Michael and Timothy,
>
> Can you check if the new frontend module works with the currently supported
> devices?
>    
Dear all,

It's Timothy here -- I'm the original author of the lgs8gl5 module.  
Sorry for the late reply, but since my office's relocation, I've been 
having a hard time getting good TV reception, and had not been able to 
exercise the patch.

However, I've been in close contact with David, and did try an earlier 
version of his patch prior to moving, so I'm optimistic that it should work.


Regards,
Timothy Lee
