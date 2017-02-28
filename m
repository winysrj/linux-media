Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:50190 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751060AbdB1O0u (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Feb 2017 09:26:50 -0500
Date: Tue, 28 Feb 2017 16:16:21 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Pavel Machek <pavel@ucw.cz>
Cc: sre@kernel.org, pali.rohar@gmail.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, laurent.pinchart@ideasonboard.com,
        mchehab@kernel.org, ivo.g.dimitrov.75@gmail.com
Subject: Re: [RFC 08/13] smiapp-pll: Take existing divisor into account in
 minimum divisor check
Message-ID: <20170228141620.GB3220@valkosipuli.retiisi.org.uk>
References: <20170214134004.GA8570@amd>
 <20170214220503.GO16975@valkosipuli.retiisi.org.uk>
 <20170215112757.GA8974@amd>
 <20170228140921.GA8917@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170228140921.GA8917@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Feb 28, 2017 at 03:09:21PM +0100, Pavel Machek wrote:
> Can I get you to apply this one? :-).

Let me try to understand again what does that change actually do. I'll find
the time during the rest of this week.

I'm starting to think we need a test suite for the PLL calculator...

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
