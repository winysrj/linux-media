Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:56062 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430Ab1KDKCk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Nov 2011 06:02:40 -0400
Received: by wwi36 with SMTP id 36so3223000wwi.1
        for <linux-media@vger.kernel.org>; Fri, 04 Nov 2011 03:02:39 -0700 (PDT)
From: Patrick Boettcher <pboettcher@kernellabs.com>
To: Alain VOLMAT <alain.volmat@st.com>
Subject: Re: MediaController support in LinuxDVB demux
Date: Fri, 4 Nov 2011 10:57:26 +0100
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <E27519AE45311C49887BE8C438E68FAA01010C61F5A6@SAFEX1MAIL1.st.com>
In-Reply-To: <E27519AE45311C49887BE8C438E68FAA01010C61F5A6@SAFEX1MAIL1.st.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111041057.26112.pboettcher@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Alain,

On Thursday 03 November 2011 10:16:25 Alain VOLMAT wrote:
> Hi
> 
> Last week we started the discussion about having a MediaController
> aware LinuxDVB demux and I would like to proceed on this discussion.
> Then, the discussion rapidly moved to having the requirement for
> dynamic pads in order to be able to add / remove then in the same
> way as demux filters are created for each open of the demux device
> node.
> 
> I am not really sure dynamic pads is really a MUST for MC aware demux
> device. The demux entity could work with a predefined number of
> output pads, determined by the vendor, depending on the demux
> capacity of the device. Of course it is probably better to have only
> pads when needed but it requires quite a lot of change to the
> overall MC framework and such modification could be done afterward,
> when the MC support for LinuxDVB is much better understood.

I insert my comments and questions here, because the last words are 
reflecting my thoughts very well I think. I'm talking about "... when 
the MC support for LinuxDVB is much better understood":

I, for myself, haven't had yet the opportunity to look very closely to 
the MC-implementation in V4l until now. From what I understand it is 
flexible framework which enables precise abstractions of data-flows and 
data-routing between hard- and software components of a "multimedia"-
device.

Extending such a thing to LinuxDVB seems of course a good idea, because 
as of today we are missing some flexibility in this area. One problem 
for example I faced in the past was the correct (from user-space) 
support for multiple frontends which can either do diversity to improve 
reception quality or be standalone receivers (each frontend decodes the 
MPEG2-TS). 

I'm sure that there are other examples which are more common which 
express the need to have MC in DVB.

Would it be a problem for you to elaborate a little bit more around the 
why and how and what around MC in DVB? Before starting to implement it 
like Mauro suggested. Could you go more in detail for you actual problem 
(like what is missing in the current dvb-demux)? 

I think it is absolutely necessary to know more about the reasoning 
around MC - as it has a big potential - before any implementation.

Maybe there are some block-diagrams and presentations around somewhere. 
Until now I only saw this Email-thread and this: 
http://www.linuxtv.org/events.php (at the very bottom).

Thanks in advance.

best regards
--
Patrick Boettcher

Kernel Labs Inc.
http://www.kernellabs.com/
