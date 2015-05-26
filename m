Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:34910 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703AbbEZPpB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 May 2015 11:45:01 -0400
Received: by wgme6 with SMTP id e6so32539612wgm.2
        for <linux-media@vger.kernel.org>; Tue, 26 May 2015 08:45:00 -0700 (PDT)
Message-ID: <556494F9.1020406@gmail.com>
Date: Tue, 26 May 2015 16:44:57 +0100
From: Jemma Denson <jdenson@gmail.com>
MIME-Version: 1.0
To: Ian Campbell <ijc@hellion.org.uk>, linux-media@vger.kernel.org
Subject: Re: DVB-T2 PCIe vs DVB-S2
References: <1432626810.5748.173.camel@hellion.org.uk>
In-Reply-To: <1432626810.5748.173.camel@hellion.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 26/05/15 08:53, Ian Campbell wrote:
> Hello,
>
> I'm looking to get a DVB-T2 tuner card to add UK Freeview HD to my
> mythtv box.
>
> Looking at http://linuxtv.org/wiki/index.php/DVB-T2_PCIe_Cards is seems
> that many (the majority even) of the cards there are actually DVB-S2.
>
> Is this a mistake or is there something I don't know (like maybe S2 is
> compatible with T2)?
>
> Thanks,
> Ian.

That's a mistake - I don't recall that table looking like that when I 
was looking for one, and S2 is quite definitely not compatible with T2!

I can confirm that the 290e works out of the box with myth with very few 
problems, however it's well out of production now and you might not be 
after a USB device. I'm not sure anything else would work without some 
hacking because last I heard myth doesn't do T2 the proper way using 
DVBv5 yet, and afaik only the 290e driver has a fudge to allow T2 on v3.
(http://lists.mythtv.org/pipermail/mythtv-users/2014-November/374441.html and 
https://code.mythtv.org/trac/ticket/12342)


Jemma.
