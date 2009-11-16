Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.infomaniak.ch ([84.16.68.89]:36987 "EHLO
	smtp1.infomaniak.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753592AbZKPWex (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Nov 2009 17:34:53 -0500
Message-ID: <4B01D38F.2050603@deckpoint.ch>
Date: Mon, 16 Nov 2009 23:34:55 +0100
From: Thomas Kernen <tkernen@deckpoint.ch>
MIME-Version: 1.0
To: Julian Scheel <julian@jusst.de>
CC: linux-media@vger.kernel.org
Subject: Re: Ubuntu karmic, 2.6.31-14 + KNC1 DVB-S2 = GPF
References: <4B004ABD.9090903@deckpoint.ch> <200911161243.24994.julian@jusst.de>
In-Reply-To: <200911161243.24994.julian@jusst.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Julian Scheel wrote:
>> It would appear that since I've upgraded to Ubuntu Karmic and the
>> 2.6.31-14 kernel, my KNC1 DVB-S2 now enjoys a GPF when I use scan-s2.
>>
>> Has anyone else come across this issue with a KNC1 card? Any suggestions
>> what I can do to trace the issue?
> 
> Which gcc version are you using?
> If you run a gcc 4.4 could you try to compile the v4l-dvb tree with a gcc-4.3 
> and see if it helps?

Hi Julian,

I did recompile with gcc-4.3 as you suggested and yes that solved the 
issue. My card now works fine with v4l-dvb complied with gcc 4.3.

Since gcc 4.4 is the default GCC version with Ubuntu Karmic (9.10), I 
expect others will run into the same issue.

Regards,
Thomas
