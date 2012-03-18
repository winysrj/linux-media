Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:38942 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755513Ab2CRQyR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Mar 2012 12:54:17 -0400
Message-ID: <4F661336.3060003@iki.fi>
Date: Sun, 18 Mar 2012 18:54:14 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Roger_M=E5rtensson?= <roger.martensson@gmail.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Terratec H7(az6007), CI support and Kaffeine
References: <4F65F5E2.2030302@gmail.com>
In-Reply-To: <4F65F5E2.2030302@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 18.03.2012 16:49, Roger Mårtensson wrote:
> Hello!
>
> This mail is a small request to see if anyone else except me that has
> problem with viewing encrypted channels.
>
> My problem is as follows:
> When viewing encrypted channels I can watch without problem.
> When I change to another encrypted channel inside kaffeine nothing
> happens. The EPG tells me which program it is but no video is displayed.
>
> To be able to watch the channel I have to close down kaffeine and
> restart it. Then works every time.
>
> I can change to an unencrypted channel without problem but not switch
> back to an encrypted one.
>
> This is using DVB-C and kaffeine 1.2.2 as supplied in Ubuntu 11.10. I am
> using kernel 3.0.0-16-generic with media_build installed for access to
> az6007-driver.
>
> I am using the CI-patch from Jose Alberto Reguero since I'm not sure it
> has been added to media_build yet.
>
> Is this a Kaffeine-problem or is it a driver/dvb-problem?

I suspect it is driver problem. I did some time ago Anysee CI support 
and tested it using VLC, Kaffeine and IIRC gnutv too. It is even 
possible to remove whole CAM and plug it back - still should continue 
working. For example view FTA channel, unplug CAM, plug CAM back; and 
only small glitches are seen during CAM replug when device routes TS via 
CAM / bypass CAM.

regards
Antti
-- 
http://palosaari.fi/
