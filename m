Return-path: <linux-media-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:55039 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbZGWIUc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Jul 2009 04:20:32 -0400
Received: from smtp08.web.de (fmsmtp08.dlan.cinetic.de [172.20.5.216])
	by fmmailgate02.web.de (Postfix) with ESMTP id 6D56D10CC7E64
	for <linux-media@vger.kernel.org>; Thu, 23 Jul 2009 10:20:32 +0200 (CEST)
Received: from [217.228.254.223] (helo=[172.16.99.2])
	by smtp08.web.de with asmtp (TLSv1:AES256-SHA:256)
	(WEB.DE 4.110 #277)
	id 1MTtXU-0008Vq-00
	for linux-media@vger.kernel.org; Thu, 23 Jul 2009 10:20:32 +0200
Message-ID: <4A681D4D.1040109@magic.ms>
Date: Thu, 23 Jul 2009 10:20:29 +0200
From: emagick@magic.ms
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: Cinergy T2 stopped working with kernel 2.6.30
References: <4A61FD76.8010409@magic.ms>
In-Reply-To: <4A61FD76.8010409@magic.ms>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are two new discoveries about my Cinergy T2 problem:

- the Cinergy T2 works when attached to an Intel Core2 board, but doesn't work when
   attached to an Intel Atom N270 board (tuning times out)

- "git bisect" of the Linux kernel points to a bad merge of
   commit 60db56422043aaa455ac7f858ce23c273220f9d9 (good) and
   commit be0ea69674ed95e1e98cb3687a241badc756d228 (good) yielding
   commit 6e15cf04860074ad032e88c306bea656bbdd0f22 (bad).

So, the problem is probably interrupt-related, not dvb-usb-related.
Any idea on how to continue from here?
