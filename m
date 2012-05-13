Return-path: <linux-media-owner@vger.kernel.org>
Received: from 7of9.schinagl.nl ([88.159.158.68]:52018 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753236Ab2EMPYK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 13 May 2012 11:24:10 -0400
Received: from [10.2.0.137] (unknown [10.2.0.137])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(No client certificate requested)
	by 7of9.schinagl.nl (Postfix) with ESMTPSA id BEFF120E25
	for <linux-media@vger.kernel.org>; Sun, 13 May 2012 17:32:31 +0200 (CEST)
Message-ID: <4FAFD21D.9000801@schinagl.nl>
Date: Sun, 13 May 2012 17:24:13 +0200
From: Oliver Schinagl <oliver+list@schinagl.nl>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
Subject: AF9035 experimental header changes
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi antti,

I've just updated my local branch of your experimental branch and got 
some conflicts because you moved the header inclusions from the C file 
to the header file. Why is that? I thought it was really bad practice to 
have includes in header files.

http://git.linuxtv.org/anttip/media_tree.git/commitdiff/7d28d8226cffd1ad6e555b36f6f9855d8bba8645
