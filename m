Return-path: <linux-media-owner@vger.kernel.org>
Received: from static-72-93-233-3.bstnma.fios.verizon.net ([72.93.233.3]:34928
	"EHLO mail.wilsonet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505AbZHaRq5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Aug 2009 13:46:57 -0400
Received: from mail.wilsonet.com (localhost.localdomain [127.0.0.1])
	by mail.wilsonet.com (Postfix) with ESMTP id 432C89446DB
	for <linux-media@vger.kernel.org>; Mon, 31 Aug 2009 13:46:59 -0400 (EDT)
Received: from mail.wilsonet.com ([127.0.0.1])
 by mail.wilsonet.com (mail.wilsonet.com [127.0.0.1]) (amavisd-maia, port 10024)
 with ESMTP id 17993-08 for <linux-media@vger.kernel.org>;
 Mon, 31 Aug 2009 13:46:44 -0400 (EDT)
Received: from dhcp47-134.lab.bos.redhat.com (lan-nat-pool-bos.redhat.com [66.187.234.200])
	(using TLSv1 with cipher AES128-SHA (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: jarod)
	by mail.wilsonet.com (Postfix) with ESMTPSA id 073A39446DA
	for <linux-media@vger.kernel.org>; Mon, 31 Aug 2009 13:46:44 -0400 (EDT)
Message-Id: <86BDC1B0-F181-4D45-AD8D-2D836EE998CB@wilsonet.com>
From: Jarod Wilson <jarod@wilsonet.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v936)
Subject: hvr-1800 disabling audio on pvr-500?
Date: Mon, 31 Aug 2009 13:45:08 -0400
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Haven't verified this myself, but there's a bugzilla ticket filed w/ 
Red Hat, claiming that audio on a pvr-500 is disabled when its in the  
same system as an hvr-1800.

https://bugzilla.redhat.com/show_bug.cgi?id=480728

Nonsense? Already fixed? Report says it worked fine in 2.6.25, broke  
in 2.6.27, not sure if later kernels have been tried. If its already  
fixed, and someone happens to know the commit that fixed it, I'd  
appreciate a pointer...

-- 
Jarod Wilson
jarod@wilsonet.com



