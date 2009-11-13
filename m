Return-path: <linux-media-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:47156 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755690AbZKMKUg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Nov 2009 05:20:36 -0500
Message-ID: <4AFD32F1.6030902@s5r6.in-berlin.de>
Date: Fri, 13 Nov 2009 11:20:33 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] firedtv: fix regression: tuning fails due to bogus error
 return
References: <4ADA149E.1070704@s5r6.in-berlin.de> <4ADA26D0.6010108@s5r6.in-berlin.de> <tkrat.de5abfc32fa5476d@s5r6.in-berlin.de> <4AFD306F.1020802@s5r6.in-berlin.de>
In-Reply-To: <4AFD306F.1020802@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Stefan Richter wrote:
> ...the firedtv-avc.c part of the patch vanished when you committed it.

It was still there in the linuxtv-commits message of the respective
Mercurial commit, BTW.  Something wrong with the hg to git workflow?
-- 
Stefan Richter
-=====-==--= =-== -==-=
http://arcgraph.de/sr/
