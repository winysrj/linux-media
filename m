Return-path: <linux-media-owner@vger.kernel.org>
Received: from poutre.nerim.net ([62.4.16.124]:59914 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752233AbZJWPrE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Oct 2009 11:47:04 -0400
Received: from localhost (localhost [127.0.0.1])
	by poutre.nerim.net (Postfix) with ESMTP id CD8E839DE7C
	for <linux-media@vger.kernel.org>; Fri, 23 Oct 2009 17:47:04 +0200 (CEST)
Received: from poutre.nerim.net ([127.0.0.1])
	by localhost (poutre.nerim.net [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id u1NVK+g+7jBy for <linux-media@vger.kernel.org>;
	Fri, 23 Oct 2009 17:47:03 +0200 (CEST)
Received: from hyperion.delvare (jdelvare.pck.nerim.net [62.212.121.182])
	by poutre.nerim.net (Postfix) with ESMTP id D334B39DC36
	for <linux-media@vger.kernel.org>; Fri, 23 Oct 2009 17:47:03 +0200 (CEST)
Date: Fri, 23 Oct 2009 17:47:05 +0200
From: Jean Delvare <khali@linux-fr.org>
To: LMML <linux-media@vger.kernel.org>
Subject: Re: Details about DVB frontend API
Message-ID: <20091023174705.7db4db52@hyperion.delvare>
In-Reply-To: <20091022211330.6e84c6e7@hyperion.delvare>
References: <20091022211330.6e84c6e7@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 22 Oct 2009 21:13:30 +0200, Jean Delvare wrote:
> For example, the signal strength. All I know so far is that this is a
> 16-bit value. But then what? Do greater values represent stronger
> signal or weaker signal? Are 0x0000 and 0xffff special values? Is the
> returned value meaningful even when FE_HAS_SIGNAL is 0? When
> FE_HAS_LOCK is 0? Is the scale linear, or do some values have
> well-defined meanings, or is it arbitrary and each driver can have its
> own scale? What are the typical use cases by user-space application for
> this value?

To close the chapter on signal strength... I understand now that we
don't have strict rules about the exact values. But do we have at least
a common agreement that greater values mean stronger signal? I am
asking because the DVB-T adapter model I have here behaves very
strangely in this respect. I get values of:
* 0xffff when there's no signal at all
* 0x2828 to 0x2e2e when signal is OK
* greater values as signal weakens (I have an amplified antenna with
  manual gain control) up to 0x7272

I would have expected it the other way around: 0x0000 for no signal and
greater values as signal strengthens. I think the frontend driver
(cx22702) needs to be fixed.

-- 
Jean Delvare
