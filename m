Return-path: <linux-media-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:45459 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933902AbZGQGIp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jul 2009 02:08:45 -0400
Message-ID: <4A60156A.2010907@s5r6.in-berlin.de>
Date: Fri, 17 Jul 2009 08:08:42 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
MIME-Version: 1.0
To: Henrik Kurelid <henke@kurelid.se>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] firedtv: refine AVC debugging
References: <101260728ec51cc1ec78699fbb0e5c37.squirrel@mail.kurelid.se>
In-Reply-To: <101260728ec51cc1ec78699fbb0e5c37.squirrel@mail.kurelid.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Henrik Kurelid wrote:
> +#if LINUX_VERSION_CODE > KERNEL_VERSION(2, 6, 22)

This expression is always true. :-)
-- 
Stefan Richter
-=====-==--= -=== =---=
http://arcgraph.de/sr/
