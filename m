Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail10.dotsterhost.com ([66.11.233.3]:33748 "HELO
	mail10.dotsterhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753731AbZDNNmt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Apr 2009 09:42:49 -0400
Received: from [127.0.0.1] (lancer.orthfamily.net [10.182.115.3])
	(Authenticated sender: jmorth)
	by lucas.orthfamily.net (Postfix) with ESMTPA id 2D962BFCA18
	for <linux-media@vger.kernel.org>; Tue, 14 Apr 2009 10:56:57 -0400 (EDT)
Message-ID: <49E492D0.3070101@orthfamily.net>
Date: Tue, 14 Apr 2009 09:42:40 -0400
From: John Orth <john@orthfamily.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: [linux-dvb] Pinnacle HD Stick (801e SE) and i2c issues
References: <49E40322.5040600@orthfamily.net> <412bdbff0904140552m52c0106q960f7c0ee40757c@mail.gmail.com>
In-Reply-To: <412bdbff0904140552m52c0106q960f7c0ee40757c@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thank you for your prompt response, Devin. 
> 1.  Are you sure the port on the PC supports USB 2.0?   
According to the M3A78-EM spec, all 6 USB ports are 2.0, so I don't 
think that is the issue.  I will double-check this, though.
> 2.  Which application are you using to test with?   
I am using MythTV to view video, the "scan" utility from the Ubuntu 
package dvb-apps, and I compiled "w_scan" from source.
> 3.  Are you doing anything with suspend/resume on the PC?   
Not at the moment.  The only power save feature I have enabled is 
turning off the monitor, but these issues occur before the system is 
idle long enough for that to take place.
> 4.  Are you plugged directly into the USB port, or are you using any
> sort of USB extension cable?   
Yes, my 801e SE came with a short (~3") USB extension cable which I am 
using to snake the device out the back of the media shelf.  Not a huge 
deal if it needs to be removed, though.
> Once I know the answers to the above questions, I will see what I can
> figure out.   
Great, thanks so much for your help!

John



