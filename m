Return-path: <linux-media-owner@vger.kernel.org>
Received: from pitbull.cosy.sbg.ac.at ([141.201.2.122]:59762 "EHLO
	pitbull.cosy.sbg.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756726Ab2AUKfe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Jan 2012 05:35:34 -0500
Cc: linux-media@vger.kernel.org,
	Konstantin Dimitrov <kosio.dimitrov@gmail.com>
Message-Id: <FD47BCF3-7867-4296-A3CB-FB31DA6021E0@cosy.sbg.ac.at>
From: =?ISO-8859-1?Q?Christian_Pr=E4hauser?= <cpraehaus@cosy.sbg.ac.at>
To: Marek Ochaba <ochaba@maindata.sk>
In-Reply-To: <4F181BCD.5080008@maindata.sk>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v936)
Subject: Re: DVB-S2 multistream support
Date: Sat, 21 Jan 2012 11:29:22 +0100
References: <loom.20111227T105753-96@post.gmane.org> <4F181BCD.5080008@maindata.sk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear Marek,

Konstantin and I are currently work on making the BB-demux work with  
recent version of Linux DVB
and the TBS 6925. We well let you know as soon as a working patch is  
available (early february).

In the meantime, maybe you want to tell me more about your use-case,  
for helping us understand
what the user-space API requirements are. I assume you need the data  
in user-space? Would it be
enough for you if you receive the BBFrames (header + data field)?

Kind regards,
Christian.

Am 19.01.2012 um 14:34 schrieb Marek Ochaba:

> Hello Christian,
>
> we interest to your patch for BBFrame demux (we want to read some BBF
> header flags and read GS decapsulated data). Could you please publish
> latest version of it ? And send link to it ?
>
> Is there also need adaptation in device driver ? We want to us it by  
> DVB-S2
> card TBS-6925, which use STV0900 chip.
>
> -- 
> Marek Ochaba

---
Dipl.-Ing. Christian Praehauser <cpraehaus@cosy.sbg.ac.at>

|| //\\//\\ || Multimedia Communications Group,
||//  \/  \\|| Department of Computer Sciences, University of Salzburg
http://www.cosy.sbg.ac.at/~cpraehaus/
http://www.network-research.org/
http://www.uni-salzburg.at/
