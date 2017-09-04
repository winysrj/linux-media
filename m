Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:55016 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751949AbdIDHrm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 4 Sep 2017 03:47:42 -0400
Date: Mon, 4 Sep 2017 10:47:39 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        robh@kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, devicetree@vger.kernel.org,
        pavel@ucw.cz, sre@kernel.org
Subject: Re: [PATCH v7 00/18] Unified fwnode endpoint parser, async
 sub-device notifier support, N9 flash DTS
Message-ID: <20170904074739.uo2yycszt6luoldd@valkosipuli.retiisi.org.uk>
References: <20170903174958.27058-1-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170903174958.27058-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Oh, and this set depends on this patch, on its way to 4.14-rc1 I believe:

<URL:https://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git/commit/?h=device-properties&id=3e3119d3088f41106f3581d39e7694a50ca3fc02>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
