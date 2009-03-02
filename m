Return-path: <linux-media-owner@vger.kernel.org>
Received: from rouge.crans.org ([138.231.136.3]:33321 "EHLO rouge.crans.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751639AbZCBNcY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Mar 2009 08:32:24 -0500
Received: from localhost (localhost.crans.org [127.0.0.1])
	by rouge.crans.org (Postfix) with ESMTP id AB9D28480
	for <linux-media@vger.kernel.org>; Mon,  2 Mar 2009 14:32:21 +0100 (CET)
Received: from rouge.crans.org ([10.231.136.3])
	by localhost (rouge.crans.org [10.231.136.3]) (amavisd-new, port 10024)
	with LMTP id t7I4JCKc7Ccr for <linux-media@vger.kernel.org>;
	Mon,  2 Mar 2009 14:32:21 +0100 (CET)
Received: from [10.3.3.85] (gw1.icfo.es [84.88.69.1])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by rouge.crans.org (Postfix) with ESMTP id 716E082E8
	for <linux-media@vger.kernel.org>; Mon,  2 Mar 2009 14:32:21 +0100 (CET)
Message-ID: <49ABDFE1.8090508@crans.org>
Date: Mon, 02 Mar 2009 14:32:17 +0100
From: Brice Dubost <dubost@crans.org>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: [linux-dvb] Flickering
References: <20090302123541.AFC49233F8@ws5-3.us4.outblaze.com>
In-Reply-To: <20090302123541.AFC49233F8@ws5-3.us4.outblaze.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Paul Guzowski wrote:
> Greetings,
> 
> I am watching analog TV with MPlayer via a Pinnacle HDTV Pro stick connected to my cable TV set top box. It worked fine before I disconnected the computer and moved it to another room.  When I moved the computer back to my office and reconnected it, it works but the picture flickers a lot.  The only thing I can think of is that I might not have gotten it connected back to the same USB port.  Could this be causing the problem?
> 

Hello,

You can perhaps check in dmesg if it's an usb 1.1 or usb 2 port

I think if you plug this kind of stick on a usb 1.1 port it can be not
sufficient in term of bandwidth

Best regards

-- 
Brice
