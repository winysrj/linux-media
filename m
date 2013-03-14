Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:63659 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753280Ab3CNXdV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Mar 2013 19:33:21 -0400
Received: by mail-wi0-f172.google.com with SMTP id ez12so9715wid.5
        for <linux-media@vger.kernel.org>; Thu, 14 Mar 2013 16:33:20 -0700 (PDT)
Message-ID: <51425E3D.7080003@gmail.com>
Date: Fri, 15 Mar 2013 00:33:17 +0100
From: Dmitry Katsubo <dmitry.katsubo@gmail.com>
MIME-Version: 1.0
To: Oliver Schinagl <oliver+list@schinagl.nl>
CC: linux-media@vger.kernel.org
Subject: Re: dvb-apps: Additional channels for Netherlands
References: <513B4B24.5000605@gmail.com> <513DC999.2090203@schinagl.nl>
In-Reply-To: <513DC999.2090203@schinagl.nl>
Content-Type: text/plain; charset=windows-1251
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11.03.2013 13:10, Oliver Schinagl wrote:
>> and what is interesting the comments refer to radio-stations only.
> TV zenderlijst is pure DVB-T frequencies. I have not found a single FM
> frequency there. Note that if you open it via their website, there are
> two lists, FM zenderlijst and TV zenderlijst.

I see. I think I have overlooked something.

> You are probably using an old scan file. I pushed an updated version a
> week or two ago. I'm still working on an automated way to have daily
> frequency releases, but even then it can take a while before packagers
> pick it up.
> 
> Until then, you are free to use:
> http://git.linuxtv.org/dtv-scan-tables.git/blob_plain/HEAD:/dvb-t/nl-All

Great! Thanks for updating the nl-All file. What will be the dvb-apps
future version which will include the fix?

Also what is the relation between git repo you've referred and this repo:
http://linuxtv.org/hg/dvb-apps/log/f3a70b206f0f/util/scan/dvb-t/nl-All
?

> As for your patch, I think it's wrong. On 522 Mhz (through the country,
> Delft as well) we have NTS4 (Bouquet 5) which is on a 2/3 coding rate,
> in your patch it's at 1/2.

You're absolutely correct. Perhaps that is the reason why I cannot watch
TV on 522 MHz.

> On 698 MHz we have NTS1 (Bouquet 2) which is on a code rate of 1/2.

Still I cannot make them working. More exactly:

This works (722 MHz):
xine "dvb://Nederland 1"
xine "dvb://Nederland 2"
xine "dvb://Nederland 3"

These do not (522 MHz and 698 MHz):
xine "dvb://Nickelodeon"
xine "dvb://RTL 4"
...

It can be the case the signal is better on 722 MHz... Could you share
your channels.conf? Are there any specific options you pass to scan
utility? But it's likely I need to buy better antenna. Can scan utility
show the signal level?

Thanks.

-- 
With best regards,
Dmitry
