Return-path: <linux-media-owner@vger.kernel.org>
Received: from jordan.toaster.net ([69.36.241.228]:1538 "EHLO
	jordan.toaster.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbZKPCbx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Nov 2009 21:31:53 -0500
Message-ID: <4B00B988.4090401@toaster.net>
Date: Sun, 15 Nov 2009 18:31:36 -0800
From: Sean <knife@toaster.net>
MIME-Version: 1.0
To: bifferos <bifferos@yahoo.co.uk>
CC: linux-media@vger.kernel.org
Subject: Re: libv4l2: error dequeuing buf: Input/output error
References: <865524.48833.qm@web27006.mail.ukl.yahoo.com>
In-Reply-To: <865524.48833.qm@web27006.mail.ukl.yahoo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There have been some improvements to gspca_main and gspca_pac207 
recently, as well as pac207 specific improvements in libv4l2. Are you 
using the latest v4l-dvb and libv4l2? I get some slowdown halfway when 
using capture-example.c and it seems to improve when I use the latest 
v4l-dvb and libv4l2 from mercurial. http://linuxtv.org/hg/v4l-dvb

Sean

bifferos wrote:
> Hi all,
>
> Can anyone give any clue as to why I might get this error 
> when capturing from a PAC207 webcam?  It happens after a 6-7 
> second delay when capturing.
>
> I've seen this with 2.6.30.1, 2.6.30.5 and 2.6.32-rc7, however 
> I can run the same camera on another (much faster) system using 
> the same kernel(s) and same gspca driver and it works fine, 
> making me think this is a timing issue.
>
> I'm testing with the v4lgrab.c program, compiled statically 
> against libv4l2.  A quick google indicates I'm not the only
> one encountering the problem. 
>
> thanks,
> Biff.
>
>
>       
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>   
