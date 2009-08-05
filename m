Return-path: <linux-media-owner@vger.kernel.org>
Received: from znsun1.ifh.de ([141.34.1.16]:42004 "EHLO znsun1.ifh.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933091AbZHEIfM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 5 Aug 2009 04:35:12 -0400
Date: Wed, 5 Aug 2009 09:51:22 +0200 (CEST)
From: Patrick Boettcher <pboettcher@kernellabs.com>
To: Akihiro TSUKADA <tskd2@yahoo.co.jp>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	olgrenie@dibcom.fr
Subject: Re: RFC: adding ISDB-T/ISDB-Tsb to DVB-API 5
In-Reply-To: <4A78F3E6.2090708@yahoo.co.jp>
Message-ID: <alpine.LRH.1.10.0908050945190.6890@pub1.ifh.de>
References: <alpine.LRH.1.10.0908031943220.8512@pub1.ifh.de> <alpine.LRH.1.10.0908041617050.8512@pub1.ifh.de> <4A78F3E6.2090708@yahoo.co.jp>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Akihiro,

thanks for commenting.

On Wed, 5 Aug 2009, Akihiro TSUKADA wrote:

> Hi Patrick,
>
> Thank you for your effort to add support for ISDB-T/S.
> I've skimmed through the ARIB standard before,
> but it is too complicated for me to understand well enough.
> So this is not a comment for the API extension itself,
> but for the document part.
>
> Some of the parameters are currently (and probably will stay)
> fixed or not used  according to the "operational guidelines".

Yeah, that's usually the case with complex standards. For DVB-T in theory 
1500 parameter-combinations are possible, but only 5-10 different are used 
in the world. (For ISDB-T the number of possible combinations are more 
than 100000, iirc).

> For example, DQPSK is not used at all (if I read correctly).
> These guidelines are defined in ARIB TR-B14 for ISDB-T and
> in ARIB TR-B15 for ISDB-S respectively.

Hmm, I'm actually not working on ISDB-S (Satelite), but on ISDB-Tsb 
(sound-broadcasting or also known as 1seg) which is based on ISDB-T's 
modulation principles (COFDM, segment etc).

> So, including these two TRs (in additino to ARIB STD-B31)
> as a reference in the document may help readers.

I'll at TR-B14 only.

thanks for the comments,
--

Patrick Boettcher - Kernel Labs
http://www.kernellabs.com/
