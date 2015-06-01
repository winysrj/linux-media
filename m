Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:33583 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750936AbbFAGOu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Jun 2015 02:14:50 -0400
Message-ID: <556BF852.80202@iki.fi>
Date: Mon, 01 Jun 2015 09:14:42 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Jemma Denson <jdenson@gmail.com>, linux-media@vger.kernel.org
CC: mchehab@osg.samsung.com, patrick.boettcher@posteo.de
Subject: Re: [PATCH v2 1/4] b2c2: Add option to skip the first 6 pid filters
References: <1433009409-5622-1-git-send-email-jdenson@gmail.com> <1433009409-5622-2-git-send-email-jdenson@gmail.com>
In-Reply-To: <1433009409-5622-2-git-send-email-jdenson@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/30/2015 09:10 PM, Jemma Denson wrote:
> The flexcop bridge chip has two banks of hardware pid filters -
> an initial 6, and on some chip revisions an additional bank of 32.
>
> A bug is present on the initial 6 - when changing transponders
> one of two PAT packets from the old transponder would be included
> in the initial packets from the new transponder. This usually
> transpired with userspace programs complaining about services
> missing, because they are seeing a PAT that they would not be
> expecting. Running in full TS mode does not exhibit this problem,
> neither does using just the additional 32.
>
> This patch adds in an option to not use the inital 6 and solely use
> just the additional 32, and enables this option for the SkystarS2
> card. Other cards can be added as required if they also have
> this bug.

Why not to use strategy where 32 pid filter is used as a priority and 
that buggy 6 pid filter is used only when 32 pid filter is not available 
(or it is already 100% in use)?

regards
Antti

-- 
http://palosaari.fi/
