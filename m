Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:38336 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760339Ab2ESOpi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 19 May 2012 10:45:38 -0400
Received: by lahd3 with SMTP id d3so2673690lah.19
        for <linux-media@vger.kernel.org>; Sat, 19 May 2012 07:45:36 -0700 (PDT)
Message-ID: <4FB7B209.5070300@gmail.com>
Date: Sat, 19 May 2012 16:45:29 +0200
From: =?ISO-8859-1?Q?Roger_M=E5rtensson?= <roger.martensson@gmail.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Terratec H7(az6007), CI support and Kaffeine
References: <4F65F5E2.2030302@gmail.com> <4F661336.3060003@iki.fi>
In-Reply-To: <4F661336.3060003@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Antti Palosaari skrev 2012-03-18 17:54:
 > On 18.03.2012 16:49, Roger Mårtensson wrote:
 >>
 >> My problem is as follows:
 >> When viewing encrypted channels I can watch without problem.
 >> When I change to another encrypted channel inside kaffeine nothing
 >> happens. The EPG tells me which program it is but no video is displayed.
 >>
 > I suspect it is driver problem. I did some time ago Anysee CI support
 > and tested it using VLC, Kaffeine and IIRC gnutv too. It is even
 > possible to remove whole CAM and plug it back - still should continue
 > working. For example view FTA channel, unplug CAM, plug CAM back; and
 > only small glitches are seen during CAM replug when device routes TS via
 > CAM / bypass CAM.

I've noticed that there have been some patches for az6007(terratec H7, 
etc) but still the same problem. When tuning to an encrypted channel no 
video is showing. Some EPG-data data is shown that tells me what program 
should be playing.

Got a guess on #linuxtv that it could be that the routing to the CAM 
isn't set up after a tune. (my interpretation of the comment on IRC)

According to the developer of the CI-integration on az6007 it works for 
him. The difference is that he used DVB-T and I use DVB-C. Is there a 
difference here?

Linux-media, you're my only hope. :)

