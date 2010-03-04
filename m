Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:63934 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755212Ab0CDESO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Mar 2010 23:18:14 -0500
Received: by vws9 with SMTP id 9so885044vws.19
        for <linux-media@vger.kernel.org>; Wed, 03 Mar 2010 20:18:12 -0800 (PST)
Message-ID: <4B8F347E.2010206@gmail.com>
Date: Thu, 04 Mar 2010 01:18:06 -0300
From: Mauro Carvalho Chehab <maurochehab@gmail.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Pedro Ribeiro <pedrib@gmail.com>, linux-media@vger.kernel.org
Subject: Re: Excessive rc polling interval in dvb_usb_dib0700 causes 	interference
 with USB soundcard
References: <74fd948d1003031535r1785b36dq4cece00f349975af@mail.gmail.com>	 <829197381003031548n703f0bf9sb44ce3527501c5c0@mail.gmail.com>	 <74fd948d1003031700h187dbfd0v3f54800e652569b@mail.gmail.com> <829197381003031706g1011f442hcc4be40ae2e79a47@mail.gmail.com>
In-Reply-To: <829197381003031706g1011f442hcc4be40ae2e79a47@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Devin Heitmueller wrote:
> On Wed, Mar 3, 2010 at 8:00 PM, Pedro Ribeiro <pedrib@gmail.com> wrote:
>> Its working very well, thanks.
>>
>> Can you please tell me if its going to be pushed to .33 stable? And
>> should I close the kernel bug?
> 
> It's in Mauro's PULL request for 2.6.34-rc1.  It's marked "normal"
> priority so it likely won't get pulled into stable.  It was a
> non-trivial restructuring of the code, so doing a minimal fix that
> would be accepted by stable is unlikely.

The kernel bug should be closed, as this patch has already fixed and
sent upstream.
> 
> Devin
> 


-- 

Cheers,
Mauro
