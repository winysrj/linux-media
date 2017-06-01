Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:36744 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750848AbdFAIAo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 1 Jun 2017 04:00:44 -0400
Date: Thu, 1 Jun 2017 11:00:04 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Pavel Machek <pavel@ucw.cz>
Cc: Daniel Mack <daniel@zonque.org>, Rob Herring <robh@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        sebastian.reichel@collabora.co.uk
Subject: Re: [RFC v2 3/3] dt: bindings: Add a binding for referencing EEPROM
 from camera sensors
Message-ID: <20170601080004.GI1019@valkosipuli.retiisi.org.uk>
References: <1493974110-26510-1-git-send-email-sakari.ailus@linux.intel.com>
 <1493974110-26510-4-git-send-email-sakari.ailus@linux.intel.com>
 <20170508172418.zha3eyfsnuricfjk@rob-hp-laptop>
 <20170529122004.GE29527@valkosipuli.retiisi.org.uk>
 <c7a98681-4c95-0103-96ee-97ca6a02d9b3@zonque.org>
 <20170529130524.GF29527@valkosipuli.retiisi.org.uk>
 <20170531173718.GA11983@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170531173718.GA11983@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, May 31, 2017 at 07:37:18PM +0200, Pavel Machek wrote:
> Yeah, it would be good to get the corresponding patches to be merged
> to v4l-utils...

There are also no drivers to make use of this currently --- I certainly
don't object using the group_id before better solutions are available. But
the kernel needs to have the information before it can use it. :-)

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
