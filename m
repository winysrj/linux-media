Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.bredband2.com ([83.219.192.166]:48992 "EHLO
	smtp.bredband2.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471AbZIKIcD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Sep 2009 04:32:03 -0400
Message-ID: <4AAA0AF7.8060201@upcore.net>
Date: Fri, 11 Sep 2009 10:31:51 +0200
From: Magnus Nilsson <magnus@upcore.net>
MIME-Version: 1.0
To: Claes Lindblom <claesl@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: Azurewave AD-CP400 (Twinhan VP-2040 DVB-C)
References: <4A953E52.4020300@upcore.net> <4A956124.5070902@upcore.net> <bcb3ef430909061352v202d5b6fy3c668b64966a2848@mail.gmail.com> <4AA4D4F1.4060308@upcore.net> <4AA9E41B.4010102@gmail.com>
In-Reply-To: <4AA9E41B.4010102@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Claes Lindblom wrote:
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Hi, I have the same problem with Slave RACK Fail on my Azurewave
> AP-SP400 (VP-1041).
> Do you really mean that to don't get theese problems when turning off
> the log from open-sasc-ng or was the problem on open-sasc-ng?
> I have turned off the log completely for a long time since it was
> problems in open-sasc-ng but I still have problems with Slave RACK Fail.
> I'm using the same drivers with  Ubuntu server x86_64 2.6.28-13-generic
> kernel.
> 
> Have you done anything else to work properly, like patching open-sasc-ng
> or the driver?
> From my experience it really starts to fail when using MythTV, otherwise
> I can tune channels for several days straight without any problems.
> But when doing a complete channels scan it can make the driver fail so I
> would not blame mythtv to much but it's feels like something messes
> it up.
> Maybe it's getting better in Mythtv 0.22...
> 
> I'm almost about to sell my tv-card if it does not start to work
> properly. :(
> 
> Best regards
> /Claes
> 

If you read the entire thread it was MartinG that had the problem with
"Slave RACK Fail". My machine just completely locked up before I removed
the logging in open-sasc-ng. I'm currently using a vanilla 2.6.30.5
kernel, with open-sasc-ng r77 and s2-liplianin-16e3dc6f2758, on a Debian
system with MythTV 0.21 from the vanilla sources.
The only thing I've had to do to get open-sasc-ng to compile was comment
out the lines containing "owner", specifically lines 175,187,196,221 in
dvbloopback/module/dvblb_proc.c

I can remember seeing Slave RACK Fail errors when using the older mantis
driver from Manu (not the mantis-v4l one). That was however only when
booting up, since it paused for a few seconds while displaying 4 of
those errors. I don't see it now with the newer drivers though.

Keep in mind that we don't even have the same card, since I have the
AD-CP400 (DVB-C version).

Thanks,
Magnus
