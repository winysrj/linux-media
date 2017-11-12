Return-path: <linux-media-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.221]:24327 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750941AbdKLSxU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 12 Nov 2017 13:53:20 -0500
Message-ID: <1510512796.2225.432.camel@rohdewald.de>
Subject: Re: pctv452e oops
From: Wolfgang Rohdewald <wolfgang@rohdewald.de>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Max Kellermann <max.kellermann@gmail.com>,
        linux-media@vger.kernel.org
Date: Sun, 12 Nov 2017 19:53:16 +0100
In-Reply-To: <1510147704.2225.329.camel@rohdewald.de>
References: <1510146389.2225.324.camel@rohdewald.de>
         <1510147704.2225.329.camel@rohdewald.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mi, 2017-11-08 at 14:28 +0100, Wolfgang Rohdewald wrote:
> since kernel 4.9 I cannot use my four dvb-s2 USB receivers anymore, so
> I am stuck with 4.8.x
> 
> Now I tried again with an unmodified kernel 4.13.12. After some time, 
> I get 3 oopses (remember - I have 4 devices). The call trace is always
> the same.
> 
> 
> attached:
> 
> tasks.txt showing the timing of the oopses
> oops.txt with one of them

after this happens, lsmod shows a negative reference count:

Module                  Size  Used by
stb0899                40960  -1

-- 
mit freundlichen Grüssen

Wolfgang Rohdewald
