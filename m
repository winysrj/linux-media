Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay01.mx.bawue.net ([193.7.176.67]:41405 "EHLO
	relay01.mx.bawue.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753362Ab2ANNNW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Jan 2012 08:13:22 -0500
Message-ID: <4F117E07.4060202@zorglub.s.bawue.de>
Date: Sat, 14 Jan 2012 14:07:19 +0100
From: Eric Lavarde <deb@zorglub.s.bawue.de>
MIME-Version: 1.0
To: Jonathan Nieder <jrnieder@gmail.com>
CC: linux-media@vger.kernel.org,
	Ralph Metzler <rmetzler@digitaldevices.de>,
	Oliver Endriss <o.endriss@gmx.de>
Subject: Re: [ddbridge] suspend-to-disk takes about a minute ("I2C timeout")
 if vdr in use on ASUS P8H67-M EVO
References: <4ED0CD0C.7010403@zorglub.s.bawue.de> <20111212022944.GA30031@elie.hsd1.il.comcast.net> <4EE7402B.1010203@zorglub.s.bawue.de> <20111224071906.GA11131@elie.Belkin>
In-Reply-To: <20111224071906.GA11131@elie.Belkin>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On 24/12/11 08:19, Jonathan Nieder wrote:
>> [  570.265915] I2C timeout
>> [  570.265921] IRS 00000001
> [...]
>> [... hundreds of line of this type ...]
>
> Ok, sounds like nothing good.
>
> This error message comes from the ddb_i2c_cmd() function in the
> ddbridge driver.  I don't think it's supposed to fail like that. :)
>
> Ralph, Oliver, any hints for debugging this?  The above is with a
> v3.1-based kernel.  More details are below, at
> <http://bugs.debian.org/650081>, and in messages after the first one
> at<http://bugs.debian.org/562008>.
>
I don't want to keep you from trying to fix the problem :-) but:
1. the ddbridge module doesn't come from the standard kernel package but 
from [1]
2. in the mean time, the maintainer / author (UFO, perhaps even reading 
these lines) has stated under [2] that the modules are not meant to 
support suspend/resume.

Also, because my main issue is with not being able to get my PC to wake 
up at a given time from the command line and _not_ with not being able 
to suspend, and because I read that Kernel guys don't like to work on 
"dirty" kernels, I have now a dual boot setup between "pure kernel" and 
"dirty kernel with ddbridge".
Let me know if I can do anything to bring forward the resolution of any 
issue reported. And don't forget to tell me with which Kernel I should test.

This said, I don't see any noticeable difference between both kernels in 
regard of not waking up...

Eric

Links (in German, let me know if I need to translate something):

[1] 
http://www.vdr-portal.de/board16-video-disk-recorder/board85-hdtv-dvb-s2/105803-aktuelle-treiber-f%C3%BCr-octopus-ddbridge-cines2-ngene-ddbridge-duoflex-s2-duoflex-ct-cinect-sowie-tt-s2-6400/

[2] 
http://www.vdr-portal.de/board16-video-disk-recorder/board85-hdtv-dvb-s2/p1046383-aktuelle-treiber-f%C3%BCr-octopus-ddbridge-cines2-ngene-ddbridge-duoflex-s2-duoflex-ct-cinect-sowie-tt-s2-6400/#post1046383
