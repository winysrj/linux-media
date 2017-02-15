Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36272 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751770AbdBOLlK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Feb 2017 06:41:10 -0500
Date: Wed, 15 Feb 2017 12:41:04 +0100
From: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Pavel Machek <pavel@ucw.cz>, sre@kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        laurent.pinchart@ideasonboard.com, mchehab@kernel.org,
        ivo.g.dimitrov.75@gmail.com
Subject: Re: [RFC 08/13] smiapp-pll: Take existing divisor into account in
 minimum divisor check
Message-ID: <20170215114104.GE32000@pali>
References: <20170214134004.GA8570@amd>
 <20170214220503.GO16975@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170214220503.GO16975@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 15 February 2017 00:05:03 Sakari Ailus wrote:
> Hi Pavel,
> 
> On Tue, Feb 14, 2017 at 02:40:04PM +0100, Pavel Machek wrote:
> > From: Sakari Ailus <sakari.ailus@iki.fi>
> > 
> > Required added multiplier (and divisor) calculation did not take into
> > account the existing divisor when checking the values against the
> > minimum divisor. Do just that.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> > Signed-off-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
> > Signed-off-by: Pavel Machek <pavel@ucw.cz>
> 
> I need to understand again why did I write this patch. :-)
> 
> Could you send me the smiapp driver output with debug level messages
> enabled, please?
> 
> I think the problem was with the secondary sensor.
> 

Hi, search for emails and threads:
Message-Id: <1364719448-29894-1-git-send-email-sakari.ailus@iki.fi>
Message-ID: <5728ED34.3060402@gmail.com>

I think I already resent those information again :-)

-- 
Pali Rohár
pali.rohar@gmail.com
