Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:52713 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752321AbbC1WfN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Mar 2015 18:35:13 -0400
Date: Sun, 29 Mar 2015 00:35:11 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org, kyungmin.park@samsung.com,
	pavel@ucw.cz, cooloney@gmail.com, rpurdie@rpsys.net,
	s.nawrocki@samsung.com
Subject: Re: [PATCH v2 02/11] leds: add uapi header file
Message-ID: <20150328223510.GX18321@valkosipuli.retiisi.org.uk>
References: <1427464185-27950-1-git-send-email-j.anaszewski@samsung.com>
 <1427464185-27950-3-git-send-email-j.anaszewski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1427464185-27950-3-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacek,

On Fri, Mar 27, 2015 at 02:49:36PM +0100, Jacek Anaszewski wrote:
> This patch adds header file for LED subsystem definitions and
> declarations. The initial need for the header is allowing the
> user space to discover the semantics of flash fault bits.

Where does the user space need these? The fault codes are strings in the
sysfs interface.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
