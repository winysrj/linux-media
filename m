Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:38838 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815Ab1KWBsn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Nov 2011 20:48:43 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Ohad Ben-Cohen" <ohad@wizery.com>
Subject: Re: omap3isp hangs with 3.2-rc2
Date: Wed, 23 Nov 2011 02:48:41 +0100
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org
References: <CAK=Wgbbt-c-PzmqWmJ-wMaWup-Jm6vzjrKkonXSMirGq+V-BJQ@mail.gmail.com>
In-Reply-To: <CAK=Wgbbt-c-PzmqWmJ-wMaWup-Jm6vzjrKkonXSMirGq+V-BJQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111230248.41780.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ohad,

On Tuesday 22 November 2011 16:02:29 Ohad Ben-Cohen wrote:
> Hi Laurent,
> 
> With 3.2-rc2, omap3isp seems to silently hang in my setup (sensor-less
> OMAP3).
> 
> Turning on lockdep yields the below messages, care to take a quick look ?

Thanks for the report. I'll try to check that in the next couple of days.

-- 
Regards,

Laurent Pinchart
