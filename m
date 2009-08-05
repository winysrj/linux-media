Return-path: <linux-media-owner@vger.kernel.org>
Received: from znsun1.ifh.de ([141.34.1.16]:38565 "EHLO znsun1.ifh.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933555AbZHEIIF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 5 Aug 2009 04:08:05 -0400
Date: Wed, 5 Aug 2009 10:07:58 +0200 (CEST)
From: Patrick Boettcher <pboettcher@kernellabs.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Akihiro TSUKADA <tskd2@yahoo.co.jp>, olgrenie@dibcom.fr
Subject: Re: RFC: adding ISDB-T/ISDB-Tsb to DVB-API 5
In-Reply-To: <alpine.LRH.1.10.0908050945190.6890@pub1.ifh.de>
Message-ID: <alpine.LRH.1.10.0908051005160.6890@pub1.ifh.de>
References: <alpine.LRH.1.10.0908031943220.8512@pub1.ifh.de> <alpine.LRH.1.10.0908041617050.8512@pub1.ifh.de> <4A78F3E6.2090708@yahoo.co.jp> <alpine.LRH.1.10.0908050945190.6890@pub1.ifh.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 5 Aug 2009, Patrick Boettcher wrote:
>> For example, DQPSK is not used at all (if I read correctly).
>> These guidelines are defined in ARIB TR-B14 for ISDB-T and
>> in ARIB TR-B15 for ISDB-S respectively.
>
> Hmm, I'm actually not working on ISDB-S (Satelite), but on ISDB-Tsb 
> (sound-broadcasting or also known as 1seg) which is based on ISDB-T's

Here I have to correct myself: 1seg is not the (commercial) name for 
ISDB-Tsb, but for the ISDB-T central segment, which can be received 
independently (Partial reception).

--

Patrick Boettcher - Kernel Labs
http://www.kernellabs.com/
