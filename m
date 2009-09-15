Return-path: <linux-media-owner@vger.kernel.org>
Received: from server15.01domain.net ([216.7.191.132]:33846 "EHLO
	server15.01domain.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769AbZIOFLc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Sep 2009 01:11:32 -0400
Message-ID: <20090915151134.5s8l0f63kgcsw4o0@omnitude.net>
Date: Tue, 15 Sep 2009 15:11:34 +1000
From: Adam Swift <vikevid@omnitude.net>
To: hermann pitton <hermann-pitton@arcor.de>
Cc: linux-media@vger.kernel.org
Subject: Re: cx88: 2 channels on each of 2 cards
References: <20090913114622.cwfj5t1kgowgkgo4@omnitude.net>
	<1252813248.3259.14.camel@pc07.localdom.local>
In-Reply-To: <1252813248.3259.14.camel@pc07.localdom.local>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks Hermann,

hermann pitton <hermann-pitton@arcor.de> wrote:
> starting point here is, that neither of the now older chips like bt878,
> saa713x or cx88xx can do two external inputs at the same time on one
> chip at once.
<snip>
> Else, they totally depend on software switching between those external
> inputs.

Ok, I will attempt to correct the implementation in ZoneMinder to allow this.

But as I understand it, one channel on each of two cards should work,  
correct? I'm currently accessing each of /dev/video0 and /dev/video1  
this way (single channel on each), and the card accessed second gives  
no video. I've got the same results with both xawtv and ZoneMinder.

Regards
Adam Swift

