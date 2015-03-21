Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:47240 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751832AbbCUWtG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Mar 2015 18:49:06 -0400
Date: Sun, 22 Mar 2015 00:49:03 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org, kyungmin.park@samsung.com,
	pavel@ucw.cz, cooloney@gmail.com, rpurdie@rpsys.net,
	s.nawrocki@samsung.com, Andrzej Hajda <a.hajda@samsung.com>,
	Lee Jones <lee.jones@linaro.org>,
	Chanwoo Choi <cw00.choi@samsung.com>
Subject: Re: [PATCH v1 02/11] DT: Add documentation for the mfd Maxim max77693
Message-ID: <20150321224903.GE16613@valkosipuli.retiisi.org.uk>
References: <1426863811-12516-1-git-send-email-j.anaszewski@samsung.com>
 <1426863811-12516-3-git-send-email-j.anaszewski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1426863811-12516-3-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacek,

On Fri, Mar 20, 2015 at 04:03:22PM +0100, Jacek Anaszewski wrote:
> +Optional properties of the LED child node:
> +- label : see Documentation/devicetree/bindings/leds/common.txt

I'm still not comfortable using the label field as-is as the entity name in
the later patches, there's one important problem: it is not guaranteed to be
unique in the system.

Do you think this could be added to
Documentation/devicetree/bindings/leds/common.txt, with perhaps enforcing it
in the LED framework? Bryan, what do you think?

The alternative would be to simply ignore it in the entity name, but then
the name of the device would be different in the LED framework and Media
controller.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
