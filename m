Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:58856 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752399AbZCWXkz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Mar 2009 19:40:55 -0400
Date: Mon, 23 Mar 2009 20:40:57 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: LINUX NEWBIE <lnxnewbie@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: cx88 audio input change
Message-ID: <20090323204057.7c400a8e@pedra.chehab.org>
In-Reply-To: <55fdf7050901271437o7afafa42j1db0fd18ca1ce915@mail.gmail.com>
References: <55fdf7050901261409h67f581f1ib6951ecb60eb8e8@mail.gmail.com>
	<20090127102421.06bfd4c1@caramujo.chehab.org>
	<55fdf7050901271437o7afafa42j1db0fd18ca1ce915@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On Tue, 27 Jan 2009 14:37:23 -0800
LINUX NEWBIE <lnxnewbie@gmail.com> wrote:

> In Linux cx88 driver, is it possible to stream audio only without
> video Risc engine running?  If so, what tools/players and commands can
> I use to stream audio only from cx88 card?
> 
Sorry for not answer before. I got flooded of emails.

AFAIK, the cx88 internal RISC processor is responsible for moving the sampling
data. I don't think you can have the device working without uploading the risc
firmware.

-- 

Cheers,
Mauro
