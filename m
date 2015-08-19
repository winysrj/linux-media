Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.uni-paderborn.de ([131.234.142.9]:46462 "EHLO
	mail.uni-paderborn.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847AbbHSIhU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Aug 2015 04:37:20 -0400
MIME-Version: 1.0
In-Reply-To: <CALcgO_471LouPKvdDAfOSbtWX+ne4iqvbxC-+fMwy-nQM8Go2w@mail.gmail.com>
References: <CALcgO_6UXp-Xqwim8WpLXz7XWAEpejipR7JNQc0TdH0ETL4JYQ@mail.gmail.com>
	<20150811111604.GD10928@atomide.com>
	<CALcgO_471LouPKvdDAfOSbtWX+ne4iqvbxC-+fMwy-nQM8Go2w@mail.gmail.com>
Date: Wed, 19 Aug 2015 10:37:16 +0200
Message-ID: <CALcgO_44y2dxLgysj-UVZjPoWoWo2uMskL_9UNTYo7=W1caS_w@mail.gmail.com>
Subject: Re: [PATCH RFC] DT support for omap4-iss
From: Michael Allwright <michael.allwright@upb.de>
To: Tony Lindgren <tony@atomide.com>, Tero Kristo <t-kristo@ti.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Arnd Bergmann <arnd@arndb.de>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Everyone,

I'm thinking of using systemtap to create watchpoints on all memory
regions of the ISS and associated PRCM registers to generate two log
files with all memory accesses at any given point of time, one for
3.17 and one for 4.1.4.

Does this sound like reasonable approach, or is this over the top /
inefficient in your experience?

All the best,

Michael Allwright

PhD Student
Paderborn Institute for Advanced Studies in Computer Science and Engineering

University of Paderborn
Office-number 02-10
Zukunftsmeile 1
33102 Paderborn
Germany
