Return-path: <linux-media-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:25805 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371Ab3JVW5u (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Oct 2013 18:57:50 -0400
Received: from morden (ip-5-146-184-27.unitymediagroup.de [5.146.184.27])
	by smtp.strato.de (RZmta 32.10 DYNA|AUTH)
	with (TLSv1.2:DHE-RSA-AES256-SHA256 encrypted) ESMTPSA id j01f33p9MM0mx9
	for <linux-media@vger.kernel.org>;
	Wed, 23 Oct 2013 00:57:48 +0200 (CEST)
Received: from rjkm by morden with local (Exim 4.80)
	(envelope-from <rjkm@morden.metzler>)
	id 1VYktY-0002HT-2y
	for linux-media@vger.kernel.org; Wed, 23 Oct 2013 00:57:48 +0200
From: Ralph Metzler <rjkm@metzlerbros.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <21095.747.879743.551447@morden.metzler>
Date: Wed, 23 Oct 2013 00:57:47 +0200
To: linux-media@vger.kernel.org
Subject: DVB-C2
In-Reply-To: <1382462076-29121-1-git-send-email-guest@puma.are.ma>
References: <1382462076-29121-1-git-send-email-guest@puma.are.ma>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I am wondering if anybody looked into API extensions for DVB-C2 yet?
Obviously, we need some more modulations, guard intervals, etc. 
even if the demod I use does not actually let me set those (only auto).

But I do need to set the PLP and slice ID.
I currently set them (8 bit each) by combining them into the 32 bit 
stream_id (DTV_STREAM_ID parameter).

By using the stream id like this and not having (or being able) to set
the rest of the new parameters I only have to add SYS_DVBC2 to the delivery systems
right now. But the new parameters should be added for completeness and if we want to
be able to scan we will need calls to read out L1 signalling information.

Any thoughts?

Regards,
Ralph

