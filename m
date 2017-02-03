Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wj0-f193.google.com ([209.85.210.193]:35184 "EHLO
        mail-wj0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751958AbdBCNcW (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 3 Feb 2017 08:32:22 -0500
Date: Fri, 3 Feb 2017 14:32:19 +0100
From: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, robh+dt@kernel.org,
        devicetree@vger.kernel.org, ivo.g.dimitrov.75@gmail.com,
        sre@kernel.org, linux-media@vger.kernel.org, galak@codeaurora.org,
        mchehab@osg.samsung.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] devicetree: Add video bus switch
Message-ID: <20170203133219.GD26759@pali>
References: <20161023200355.GA5391@amd>
 <20161119232943.GF13965@valkosipuli.retiisi.org.uk>
 <20161214122451.GB27011@amd>
 <20161222100104.GA30917@amd>
 <20161222133938.GA30259@amd>
 <20161224152031.GA8420@amd>
 <20170203123508.GA10286@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170203123508.GA10286@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 03 February 2017 13:35:08 Pavel Machek wrote:
> N900 contains front and back camera, with a switch between the
> two. This adds support for the switch component, and it is now
> possible to select between front and back cameras during runtime.

IIRC for controlling cameras on N900 there are two GPIOs. Should not you
have both in switch driver?

-- 
Pali Rohár
pali.rohar@gmail.com
