Return-path: <linux-media-owner@vger.kernel.org>
Received: from colin.muc.de ([193.149.48.1]:2819 "EHLO mail.muc.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754200AbZIDIht (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Sep 2009 04:37:49 -0400
Date: Fri, 4 Sep 2009 10:29:56 +0200
From: Harald Milz <hm@seneca.muc.de>
To: linux-media@vger.kernel.org
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] TechnoTrend TT-connect S2-3650 CI
Message-ID: <20090904082956.GB7618@seneca.muc.de>
References: <!&!AAAAAAAAAAAYAAAAAAAAAMs7WpTkg9MRuRcAACHFyB/CgAAAEAAAAJQ52z3qEFtDsl72y5icHrgBAAAAAA==@coolrose.fsnet.co.uk> <200908122130.15270.jens.nixdorf@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200908122130.15270.jens.nixdorf@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Aug 12, 2009 at 09:30:15PM +0200, Jens Nixdorf wrote:
> As Niels told you already, you cant use both types of driver. I own the 
> same DVB-S2-Box from Technotrend and i'm using it with VDR 1.7.0 in 
> ubuntu 9.04. I was following the wiki for installing s2-liplianin-
> drivers, and since this time the box is running including its CI. 

Mine as well under openSUSE 11.1. The part should definitely get the
"supported" status. I figure the s2-liaplianin tree need to me merged into the
official tree then. As the S2-3200 card which is technically very similar
except for the USB interface is officially supported in kernel 2.6.29, a
respective hint should be added to the Wiki. I may test a 2.6.29 kernel for
openSUSE 11.1 today and give some feedback. 

Same for the S2-3600 which is technically identical except for the CI. 

Any idea if the Satelco part
(http://www.amazon.de/SATELCO-EasyWatch-HDTV-USB-DVB-S2/dp/B000X1C02W) is a
OEM part of the S2-3650? 

> Maybe there could be some optimization (the log is full with some 
> bandwisth-messages from the stb6100-part), but it works at least good 
> enough for me.

"modprobe ... verbose=0"  helps. 

-- 
Save the Whales -- Harpoon a Honda.
