Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.26]:30499 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030269Ab2AFKV4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 6 Jan 2012 05:21:56 -0500
Message-ID: <4F06CB48.8050509@maxwell.research.nokia.com>
Date: Fri, 06 Jan 2012 12:22:00 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org, dacohen@gmail.com, snjw23@gmail.com
Subject: Re: [RFC 03/17] vivi: Add an integer menu test control
References: <4EF0EFC9.6080501@maxwell.research.nokia.com> <1324412889-17961-3-git-send-email-sakari.ailus@maxwell.research.nokia.com> <201201051659.14528.laurent.pinchart@ideasonboard.com> <4F06CAC5.8010902@maxwell.research.nokia.com>
In-Reply-To: <4F06CAC5.8010902@maxwell.research.nokia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sakari Ailus wrote:
...
> I put it there to limit the maximum to 8 instead of 9, but 9 would be
> equally good. I'll change it.

Or not. 8 is still the index of the last value. min is one  to start the
menu from the second item. Would you like that to be changed to zero?

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
