Return-path: <linux-media-owner@vger.kernel.org>
Received: from thor.websupport.sk ([195.210.28.15]:21188 "EHLO
	thor.websupport.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437Ab2ASNoS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Jan 2012 08:44:18 -0500
Message-ID: <4F181BCD.5080008@maindata.sk>
Date: Thu, 19 Jan 2012 14:34:05 +0100
From: Marek Ochaba <ochaba@maindata.sk>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: cpraehaus@cosy.sbg.ac.at
Subject: Re: DVB-S2 multistream support
References: <loom.20111227T105753-96@post.gmane.org>
In-Reply-To: <loom.20111227T105753-96@post.gmane.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Christian,

we interest to your patch for BBFrame demux (we want to read some BBF
header flags and read GS decapsulated data). Could you please publish
latest version of it ? And send link to it ?

Is there also need adaptation in device driver ? We want to us it by DVB-S2
card TBS-6925, which use STV0900 chip.

-- 
Marek Ochaba
