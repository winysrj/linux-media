Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:42022 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752879Ab0EMVhG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 13 May 2010 17:37:06 -0400
Message-ID: <4BEC70FB.5030002@iki.fi>
Date: Fri, 14 May 2010 00:36:59 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Jose Alberto Reguero <jareguero@telefonica.net>
CC: linux-media@vger.kernel.org
Subject: Re: AF9015 suspend problem
References: <201005021739.18393.jareguero@telefonica.net>
In-Reply-To: <201005021739.18393.jareguero@telefonica.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Terve!

On 05/02/2010 06:39 PM, Jose Alberto Reguero wrote:
> When I have a af9015 DVB-T stick plugged I can not recover from pc suspend. I
> must unplug the stick to suspend work. Even if I remove the modules I cannot
> recover from suspend.
> Any idea why this happen?

Did you asked this 7 months ago from me?
I did some tests (http://linuxtv.org/hg/~anttip/suspend/) and looks like 
it is firmware loader problem (fw loader misses something or like 
that...). No one answered when I asked that from ML, but few weeks ago I 
saw some discussion. Look ML archives.

regards
Antti
-- 
http://palosaari.fi/
