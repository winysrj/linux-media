Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38999 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753341Ab0A0A6O (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jan 2010 19:58:14 -0500
Date: Tue, 26 Jan 2010 16:57:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Richard =?ISO-8859-1?Q?R=F6jfors?=
	<richard.rojfors@pelagicore.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Douglas Schilling Landgraf <dougsland@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH v2 0/3] radio: Add support for SAA7706H Car Radio DSP
Message-Id: <20100126165742.a6eec456.akpm@linux-foundation.org>
In-Reply-To: <4B596B1B.1060407@pelagicore.com>
References: <4B596B1B.1060407@pelagicore.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 22 Jan 2010 10:08:43 +0100
Richard R__jfors <richard.rojfors@pelagicore.com> wrote:

> These sets of patches added support for the SAA7706H Car Radio DSP.
> 
> Patch 2 is updated after feedback from Hans Verkuil. Thanks Hans!
> 
> Patch 1:
> Add The saa7706h to the v4l2-chip-ident.h
> Patch 2:
> Add the actual source code
> Patch 3:
> Add the saa7706h to the Kconfig and Makefile

There doesn't seem much point in splitting the patch up along these
lines, so I joined them all into a single patch in my tree.

