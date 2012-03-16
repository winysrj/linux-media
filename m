Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.ukfsn.org ([77.75.108.3]:36619 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760375Ab2CPKS6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Mar 2012 06:18:58 -0400
Message-ID: <4F631391.6010902@ukfsn.org>
Date: Fri, 16 Mar 2012 10:18:57 +0000
From: Andy Furniss <andyqos@ukfsn.org>
MIME-Version: 1.0
To: Keith Edmunds <kae@midnighthax.com>
CC: linux-media@vger.kernel.org
Subject: Re: cxd2820r: i2c wr failed (PCTV Nanostick 290e)
References: <20120310142042.0f238d3a@ws.the.cage> <20120315201446.17f21639@ws.the.cage> <4F62864B.3090207@ukfsn.org>
In-Reply-To: <4F62864B.3090207@ukfsn.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Andy Furniss wrote:
> (maybe echo 3 > /proc/sys/vm/drop_caches would also work

I don't know if it makes any difference, but I missed a bit from that - 
maybe this would be safer -

sync;echo 3 > /proc/sys/vm/drop_caches
