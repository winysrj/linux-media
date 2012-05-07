Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:46897 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460Ab2EGKWQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 May 2012 06:22:16 -0400
Received: by bkcji2 with SMTP id ji2so3533224bkc.19
        for <linux-media@vger.kernel.org>; Mon, 07 May 2012 03:22:14 -0700 (PDT)
Message-ID: <4FA7A254.3040204@gmail.com>
Date: Mon, 07 May 2012 12:22:12 +0200
From: =?ISO-8859-15?Q?Ludovic_BOU=C9?= <ludovic.boue@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org, Oliver Endriss <o.endriss@gmx.de>
CC: Brice Dubost <mumudvb@braice.net>
Subject: Re: How to toggle Cine CT V6 to DVB-T mode?
References: <CAO+XwZc5xHCaggg_LCmWNtnCuFWVNGFHY=Dm-eFLchcamrF-ZQ@mail.gmail.com> <201205062226.18652@orion.escape-edv.de>
In-Reply-To: <201205062226.18652@orion.escape-edv.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le 06/05/2012 22:26, Oliver Endriss a écrit :
> Hi,
>
> On Saturday 05 May 2012 16:39:42 Ludovic BOUE wrote:
>> Hello Oliver,
>>
>> I am facing an issue with my Cine CT V6&  DuoFlex CT cards. All tuners are
>> recognized in DVB-C mode and I don't know how to switch to DVB-T mode.
>> Could you tell me how to do that ?
> If you use an application which is unable to switch the delivery system,
> you may use 'dvb-fe-tool' (part of http://git.linuxtv.org/v4l-utils.git)
> to do so.
>
> Applications should be updated to support this new feature.
> Recent vdr developer versions switch the delivery system
> automatically.
>
> CU
> Oliver
>
Oliver,

Thanks a lot for your advice about 'dvb-fe-tool'. The following command 
work perfectly:
dvb-fe-tool -a 0 -d DVBT

But cloning the git repository don't work. I downloaded the archive on 
web interface:
git clone http://git.linuxtv.org/v4l-utils.git
Cloning into v4l-utils...
warning: remote HEAD refers to nonexistent ref, unable to checkout.

Brice and I will fix MuMuDVB support switching delivery system.

Regards,
