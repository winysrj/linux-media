Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm18.bullet.mail.ird.yahoo.com ([77.238.189.71]:48446 "EHLO
	nm18.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753068Ab3FJPJK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Jun 2013 11:09:10 -0400
References: <51B26AF1.2000005@gmail.com> <1370876006.1569.YahooMailNeo@web28901.mail.ir2.yahoo.com>
Message-ID: <1370876948.45967.YahooMailNeo@web28904.mail.ir2.yahoo.com>
Date: Mon, 10 Jun 2013 16:09:08 +0100 (BST)
From: marco caminati <marco.caminati@yahoo.it>
Reply-To: marco caminati <marco.caminati@yahoo.it>
Subject: Re: rtl28xxu IR remote
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
In-Reply-To: <1370876006.1569.YahooMailNeo@web28901.mail.ir2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



> Hi, I just compiled and tested Antti Palosaari branch and can confirm the remote works for my RTL2832U. 
> I have updated the wiki[1] entry with the steps necessary to configure the remote control. 
> Please confirm if these fixes your problem.


Thanks, but I can't confirm if this fixes my problem, because the modules I obtain building Antti's branch are not compatible with my existing kernel, so I can't test them (modprobe --force fails, and using a brand new kernel would be too much work on Tinycore at the moment).
On the other hand, I tried the sources fromgit://linuxtv.org/media_build.git, first with manual patches and then (when the latter got accepted) without them. But the ir remote does not work.

I think Antti's repo and patching linuxtv repo should lead to the same results, right?
