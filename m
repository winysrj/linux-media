Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:54993 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752706Ab1JJTbr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Oct 2011 15:31:47 -0400
Message-ID: <4E93481F.8010205@iki.fi>
Date: Mon, 10 Oct 2011 22:31:43 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Jason Hecker <jwhecker@gmail.com>
CC: Malcolm Priestley <tvboxspy@gmail.com>,
	Josu Lazkano <josu.lazkano@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] af9013 Extended monitoring in set_frontend.
References: <4e83369f.5d6de30a.485b.ffffdc29@mx.google.com>	<CAL9G6WWK-Fas4Yx2q2gPpLvo5T2SxVVNFtvSXeD7j07JbX2srw@mail.gmail.com>	<CAATJ+fvHQgVMVp1uwxxci61qdCdxG89qK0ja-=jo4JRyGW52cw@mail.gmail.com>	<4e8b8099.95d1e30a.4bee.0501@mx.google.com>	<CAATJ+fvs5OXBS9VREpZM=tY+z+n97Pf42uJFqLXbh58GVZ_reA@mail.gmail.com>	<CAL9G6WWUv+jKY7LkcJMpwMTvV+A-fzwHYJNgpbAkOiQfPoj5ng@mail.gmail.com>	<CAATJ+fu2W=o_xhsoghK1756ZGCw2g0W_95iYC8OX04AK8jAHLg@mail.gmail.com>	<4e8f6b0b.c90fe30a.4a1d.26bb@mx.google.com>	<CAATJ+fvQA4zAcGq+D0+k+OHb8Xsrda5=DATWXbzEO5z=0rWZfw@mail.gmail.com>	<CAL9G6WWMw3npqjt0WHGhyjaW5Mu=1jA5Y_QduSr3KudZTKLgBw@mail.gmail.com>	<4e904f71.ce66e30a.69f3.ffff9870@mx.google.com> <CAATJ+fstZmoctKrv8Owv53-oEPOn6C8d5FOwMAmLL=7R8UwYzg@mail.gmail.com>
In-Reply-To: <CAATJ+fstZmoctKrv8Owv53-oEPOn6C8d5FOwMAmLL=7R8UwYzg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/08/2011 11:05 PM, Jason Hecker wrote:
>> Which kernels are you all running?
>
> 2.6.38-11-generic #50-Ubuntu SMP (Mythbuntu 11.04)

Have you tried other USB-cable or connect it directly to the mobo USB port.

I just used one af9015 + 2x mxl5007t and got some streaming corruptions. 
I was WTF. Switched to af9015 + 2x mxl5005s since it is device I usually 
have used. Still errors. Then I commented out remote controller polling 
and all status polling from drivers. Still some stream corruptions. 
Finally I realized I have other USB-cable than normally. Plugged device 
directly to the mobo USB and now both tuners are streaming same time 
without errors.

Antti


-- 
http://palosaari.fi/
