Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:51031 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752154Ab2GDQWe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Jul 2012 12:22:34 -0400
Message-ID: <4FF46DC4.4070204@iki.fi>
Date: Wed, 04 Jul 2012 19:22:28 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Steve Hill <steve@nexusuk.org>
CC: linux-media@vger.kernel.org
Subject: Re: pctv452e
References: <4FF4697C.8080602@nexusuk.org>
In-Reply-To: <4FF4697C.8080602@nexusuk.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/04/2012 07:04 PM, Steve Hill wrote:
>  >> Ps. Steve, could you please give me full version of kernel which
>  >> works with pctv452e?
>
> I think it was 2.6.37-1-kirkwood from Debian which I was using (this is
> an ARM system).
>
>  > As the new DVB-USB fixes many bugs I ask you to test it. I converted
>  > pctv452e driver for you:
>  >
>  >
> http://git.linuxtv.org/anttip/media_tree.git/shortlog/refs/heads/pctv452e
>  >
>  > Only PCTV device supported currently, not TechnoTrend at that time.
>
> Can I ask why it only works on the PCTV devices?  I was under the
> impression that the TechnoTrend hardware was identical?
>
>
> If you are able to provide any pointers as to where the TechnoTrend
> support is broken (or what debugging I should be turning on to figure
> out where it is broken) then that would be helpful.

I don't have hardware, no PCTV neither TechnoTrend. I just converted 
PCTV as Marx seems to have such device and he was blaming. Code wasn't 
100% similar, for example TechnoTrend has CI PCTV doesn't.

It should not fix problems but it could since I fixed some nasty bugs. 
Lets wait test report first and make decision what to do after that.

regards
Antti

-- 
http://palosaari.fi/


