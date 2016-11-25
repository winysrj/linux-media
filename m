Return-path: <linux-media-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:43691 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1750984AbcKYCPk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Nov 2016 21:15:40 -0500
Date: Thu, 24 Nov 2016 21:15:39 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: Arnd Bergmann <arnd@arndb.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        <linux-media@vger.kernel.org>, <linux-pm@vger.kernel.org>
Subject: Re: [PATCH 1/1] smiapp: Implement power-on and power-off sequences
 without runtime PM
In-Reply-To: <2929151.g7xCm3YOsX@avalon>
Message-ID: <Pine.LNX.4.44L0.1611242112030.20545-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 25 Nov 2016, Laurent Pinchart wrote:

> Dear linux-pm developers, what's the suggested way to ensure that a runtime-
> pm-enabled driver can run fine on a system with CONFIG_PM disabled ?

The exact point of your question isn't entirely clear.  In the most 
literal sense, the best ways to ensure this are (1) audit the code, and 
(2) actually try it.

I have a feeling this doesn't quite answer your question, however.  :-)

Alan Stern

