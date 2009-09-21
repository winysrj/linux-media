Return-path: <linux-media-owner@vger.kernel.org>
Received: from ffm.saftware.de ([83.141.3.46]:58548 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750707AbZIUQHs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Sep 2009 12:07:48 -0400
Message-ID: <4AB7A4D6.9070709@linuxtv.org>
Date: Mon, 21 Sep 2009 18:07:50 +0200
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: George Joseph <george@playinmedia.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: 
References: <1252297247.18025.8.camel@morgan.walls.org>    <1252369138.2571.17.camel@morgan.walls.org>    <1253413236.13400.24.camel@morgan.walls.org>    <4AB78169.5030800@kernellabs.com>    <34816.188.220.60.62.1253541249.squirrel@webmail.daily.co.uk>    <4AB791DE.1020906@linuxtv.org> <29219.188.220.60.62.1253546846.squirrel@webmail.daily.co.uk>
In-Reply-To: <29219.188.220.60.62.1253546846.squirrel@webmail.daily.co.uk>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

George Joseph wrote:
> Thanks Andreas, That answers my question. I am using a tree I checkd out 3
> months ago. I used the DEMUX_SET_SOURCE API to set the ts feed to the
> tuner. Is this explicity done on Linux DVB 3?

By default, all demux devices are connected to the first frontend slot
of the DM7025. You can use DMX_SET_SOURCE to connect a demux to a
specific slot.

Regards,
Andreas

