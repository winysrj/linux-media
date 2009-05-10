Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2.versatel.nl ([62.58.50.89]:55347 "EHLO smtp2.versatel.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751299AbZEJHYZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 10 May 2009 03:24:25 -0400
Message-ID: <4A068129.2050505@hhs.nl>
Date: Sun, 10 May 2009 09:24:25 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: Linux Media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] libv4l: spca508 UV inversion
References: <20090505110846.0780d860@free.fr> <20090510091115.1cfabebb@free.fr>
In-Reply-To: <20090510091115.1cfabebb@free.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/10/2009 09:11 AM, Jean-Francois Moine wrote:
> On Tue, 5 May 2009 11:08:46 +0200
> Jean-Francois Moine<moinejf@free.fr>  wrote:
>
>> People with a spca508 webcam report a color inversion in the images.
>> Here is a simple patch to fix this problem.
>
> Hello Hans,
>
> Sorry, this is not true for all webcams. Please, don't apply the patch!
>

Ok,

Let me know when you've found out to which webcams it does apply, I guess we
need a new pixformat define for those ?

Regards,

Hans
