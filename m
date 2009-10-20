Return-path: <linux-media-owner@vger.kernel.org>
Received: from znsun1.ifh.de ([141.34.1.16]:57071 "EHLO znsun1.ifh.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750722AbZJTHni (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Oct 2009 03:43:38 -0400
Date: Tue, 20 Oct 2009 09:43:34 +0200 (CEST)
From: Patrick Boettcher <pboettcher@kernellabs.com>
To: Akihiro TSUKADA <tskd2@yahoo.co.jp>
cc: Romont Sylvain <psgman24@yahoo.fr>, linux-media@vger.kernel.org
Subject: Re: ISDB-T tuner
In-Reply-To: <4ADD3341.3050202@yahoo.co.jp>
Message-ID: <alpine.LRH.1.10.0910200935120.3543@pub2.ifh.de>
References: <340263.68846.qm@web25604.mail.ukl.yahoo.com> <4ADD3341.3050202@yahoo.co.jp>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

On Tue, 20 Oct 2009, Akihiro TSUKADA wrote:
> And just  for you information, in addition to EarthSoft PT1,
> there is a driver for 'Friio' ISDB-T USB receiver (which I wrote;) ,
> and it is already included in the main repository.
> Dibcom is maybe for Brazil and may or may not work in Japan.

I'm just stepping in here to clarify Dibcom's ISDB-T support: it's purely 
limited to demodulation with the dib8000-driver. Meaning, using a Dibcom 
reference-design in Japan will give you the BCAS encrypted transport 
stream, not more. This way is primarily used in set-top-boxes and 
car-receivers and things like that.

--

Patrick Boettcher - Kernel Labs
http://www.kernellabs.com/
